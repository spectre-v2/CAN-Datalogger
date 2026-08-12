#import "header.typ":*

= Software- Architektur

Um die die Grundarchitektur der Software so auszurichten, dass sie die übergeordneten Technischen Ziele erreicht, werden folgende Prinzipen angewendet: 

- Zustandsautomat
In eingebetteten Datenverarbeitungssystemen ist ein exakt definiertes Verhalten die Basis für ein Sicheres, zuverlässig vorhersehbares und echtzeitfähiges System. Besonders für einen Datenlogger ist ein klar definiertes Verhalten in Szenarien wie Ausfall der Versorgung, Unterbrechung der Kommunikation oder Crash des Speichermediums essenziell, um #link(<t4>)[T4] zu gewährleisten. Die Aufgaben der Software müssen Zeitlich klar definiert und eingegrenzt sein. #link(<t3>)[T3]

Aus diesem Grund muss ein Zustandsautomat alle möglichen Zustände des Systems lückenlos abbilden. Es muss exakt definiert werden, unter welchen Umständen das System seinen Zustand wechseln soll. Zudem muss der Zustandsraum endlich und seine Mächtigkeit klar definert sein. Jeder Zustand muss einzigartig sein, es soll keine zwei möglichen Varianten eines Zustandes, einen sogenannten Hidden State, geben. @statemachine-paper



#align(center)[
  #figure(
    image("pictures/can-datalogger-state-machine.svg", width: 100%),
    caption: [Zustandsautomat des Datenloggers.],
  )
]


- Modulare Treiberschichten

Die Funktionalitäten des Systems in Modulen mit klaren Zuständigkeitsgrenzen ausgeführt werden, um Zugriffe auf die Systemzustände nur duch die explizit zuständige Hardware oder Software auszuführen. Dies ist essentiell, um komplexe Firmware übersichtlich und wartbar zu gestalten und unvorhergesehenes Verhalten zu vermeiden. 
#align(center)[+
#figure(
  image("pictures/can-datalogger-driver-architecture.svg", width:60%),
  caption: [Treiberarchitektur des Prototypen.]
)]


- Hardware- Zuständigkeitstrennung
Der RP2350 ermöglicht die klare Trennung von funktionalitäten in besonderem Maße durch seine dual- Core architektur. Durch diese ist es möglich, dass einer der Prozessoren ausschließlich als "Empfänger" arbeitet, das heißt er reagiert auf Interrupt- anforderungen des MCP218, führt die SPI- Treiberfunktionen aus, und speichert die ausgelesenen Daten in einem Zwischenspeicher. Der zweite Core nimmt ausschließlich eine Rolle als "Schreiber" ein. Er liest Daten aus dem Zwischenspeicher, wandelt CAN-FD spezifische Daten in .csv tabelleneinträge um, nutzt FAT32- Bibliotheken zur Organisation der Daten in Sektoren sowie verwaltung von Partitionstabellen, und führt SD-Karten spezifische SPI- Treiberfunktionen aus, um diese verarbeiteten Daten zu speichern. Somit agieren beide Cores weitgehend unabhängig voneinander, eine unvorhergesehene, langsame Operation einer der cores beeinflusst den anderen nicht.

- Ringbuffer

== Die Zustandsstruktur

Um den Gesamtzustand des Systems zentral und übersichtlich erfassen zu können, wurde eine Struct definiert, welche sowohl den Systemzustand selbst, als auch alle äußeren Umstände, auf welche das System reagieren muss, darstellt. 

#code-snippet("../statemachine.h", "statemachine-struct")

Die Variablen, welche das System beschreiben, werden mit dem präfix `_Atomic` gekennzeichnet. Dies bewirkt, dass der C- Compiler GCC einen Zugriff auf diese Variable nicht als read modify write opersation mithilfe von LR und SC gestaltet, sondern als atomaren zugriff innerhalb eines einzigen Systemtaktes mithilfe von AMOADD, AMOAND, AMOOR usw. Diese instruktionen sind im RISC-V Befehlssatz der Hazard-3 CPUs definiert. Der Atomic- Zugriff ist wichtig, da es sich bei diesem Microcontroller um ein Multi- Core System handelt, bei dem zwei Prozessoren auf Variablen in einem gemeinsamen RAM-Adressraum zugreifen. Bei gleichzeitigen Read-Modify-Write operationen von zwei Prozessoren auf eine Variable könnten somit Daten verfälscht und das System in einen unvorhergesehenen Zustand übergehen.

Um die Statemachine zusätzlich sicherer zu gestalten, werden die Datenfelder der Zustands- Datenstruktur eindeutig einem der Prozessoren zugeordnet. Core 0 verwaltet ausschließlich initialisierung, SPI, speichern von daten im Ringbuffer sowie die Statemachine selbst. Core1 verwaltet ausschließlich das entnehmen von Daten aus dem ringbuffer und deren speicherung auf der SD-Karte. Somit ergibt sich eine Producer-Consumer architektur.

== Der Zustandsautomat von Core 0


Auf dem RP2350 wird nach Reset immer Core 0 zuerst gestartet. Dieser initialisiert USB, GPIOs und SPI, und legt dann den Zustand des Systems eindeutig fest.
#code-snippet("../core0_main.c", "start-states")


Anschließent tritt der Prozessor in eine Endlosschleife ein. Am Anfang dieser werden zuerst die Zustände der externen Signale geprüft und die Zustandsstruktur aktualisiert. Für diesen Prototypen sind die einzigen externen Signale der Interrupt- Request des MCP2518 sowie der Power-Detect- pin, welcher misst, ob das Fahrzeug eingeschaltet ist und den Datenlogger versorgt, oder nicht. 
#code-snippet("../core0_main.c", "update-statemachine")

Anschließend werden in abhängigkeit von dem aktuellen Systemzustand unterschiedliche Bedingungen überprüft und eventuell aktionen angefordert. Dazu wird ein switch-case statement verwendet.

#code-snippet("../core0_main.c", "core0-loop")

Core 0 muss Core 1 aktiv starten und einen Pointer auf den Einstiegspunkt übergeben, oder per Reset abschalten um anschließend den Mikrocontroller in den Stromsparenden Dormant- Zustand zu versetzen.
 Dies geschieht durch die Funktionen `multicore_launch_core1(void (*entry)(void))` und `multicore_reset_core1(void)`.
 
 Ab diesem Zeitpunkt führt Core 1 selbstständig Code aus.

 == Der Zustandsautomat von Core 1

 Da Core 1 grundsätzlich vollständig unabhängig und gleichzeitig zu Core 0 code ausführt, erhält dieser seine eigene Zustandsmaschine, um auf Basis der für beide Cores sichtbaren globalen Zustandsstruktur Entscheidungen Treffen zu können. 

 #code-snippet("../core1_main.c", "core1-loop")

Hier wird die Wichtigkeit des Ownership- prinzips wichtig, den Theoretisch könnte Core 1 variablen des System States verändern, die die Statemachine von Core 0 beeinflussen. Aus diesem Grund verändert Core 1 ausschließlich die struct `datalogger_state.sd_state`.