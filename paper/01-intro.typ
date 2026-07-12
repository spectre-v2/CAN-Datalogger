#import "header.typ":*

= Einleitung <intro>
Moderne technische Systeme stehen unter dem Anspruch, maximale Qualität in Funktionalität, Energieeffizienz,   Zuverlässigkeit sowie Wirtschaftlichkeit zu vereinen. 

Die Grundlage jeder Entwicklung bilden mathematische Modelle, mit denen das Verhalten eines Systems bereits in der Entwurfsphase beschrieben und bewertet wird. Diese Modelle stellen jedoch zwangsläufig eine Vereinfachung der realen physikalischen Zusammenhänge dar. Ihre Aussagekraft ist erst dann gegeben, wenn sie durch Messdaten unter realen Betriebsbedingungen bestätigt werden.

Die präzise und zuverlässige Erfassung von Messdaten ist deshalb ein zentraler Bestandteil moderner Entwicklungsprozesse - sowohl in der industriellen Produktentwicklung als auch in der Formula Student. Sie ermöglicht es, theoretische Annahmen mit der Realität abzugleichen, konstruktive Schwachstellen zu identifizieren und Systeme gezielt weiterzuentwickeln.

Ziel dieser Studienarbeit ist deshalb die Erarbeitung eines Konzeptes zur Aufzeichnung und Analyse relevanter Fahrzeugdaten eines Formula- Student Rennwagens, sowie die Erforschung der technischen Grundlagen dieser.

#v(10mm)

#align(center)[
  #figure(
    image("pictures/ry2025.jpg", width:80%),
    caption: [Der A-25 von Raceyard. @a25]
  )
]


= Methodik <methodology>
Zur Erarbeitung eines funktionalen Konzeptes orientiert sich diese Studienarbeit an einer leicht abgewandelten Version des V- Modells, welches in der VDI- Richtlinie VDI/VDE- 2206 beschrieben wird. @vmod

#align(center)[
  #figure(
    image("pictures/v-model.svg", width: 80%),
    caption: [V-Modell. @vmod]
  )
]

Dabei umfasst diese Studienarbeit jediglich Punkte V1 bis V5, sowie einen Unit- Test in stark vereinfachtem Umfang, um gezielt Fachwissen über die technischen Kernprizipien aufzubauen.


// Um bei der Systemanforderungsanalyse die abstrakten Wünsche der beteiligten Personen in detaillierte technische Ziele zu fassen, wird sich der Methode der Qualitätsfunktionendarstellung oder auch "Quality Function Deployment" bedient. @qfd

#pagebreak()
== Anforderungsanalyse <requirements-analysis>

Der Datenlogger bildet eine wichtige Schnittstelle zwischen Mensch und Maschine. Er dient als zentrales Werkzeug für Ingenieure zur Erfassung und Auswertung von Fahrzeugdaten, um Konstruktionen zu Evaluieren und iterativ zu verbessern. Aus diesem Grund werden folgende Bedarfe des Endnutzers als Startpunkt für die Anforderungsanalyse verwendet: 

- *A1: Einfache Nutzbarkeit* <a1>
  Messdaten tragen nur dann zur tatsächlichen Verbesserung des Fahrzeuges bei, wenn sie schnell einfach und ohne besondere Vorkenntnisse ausgewertet werden können. Der Ausleseprozess muss deshalb extrem simpel sein. Die Daten müssen über eine Standardschnittstelle zugänglich sein und in einem offenen, klar dokumentierten Format vorliegen. Die Analyse muss über plattformübergreifend kompatible, frei verfügbare Software möglich sein.

- *A2: Zuverlässige Datenerfassung* <a2>
  Wichtige Informationen dürfen unter keinen Umständen verloren gehen. Da bei modernen Fahrzeugen enorme Datenmengen mit hohen Geschwindigkeiten auf Datenbussen übertragen werden, muss der Datenlogger echtzeitfähig sein, um auch unter höchster Last mit deterministischen Latenzen zuverlässig Daten zu speichern. Zudem entstehen sehr wertvolle Messdaten meist unmittelbar vor einem Fehler oder vollständigen Systemausfall, weshalb in diesem Szenario der Datenlogger nicht versagen darf. So darf auch ein plötzlicher Spannungsverlust nicht zu einer beschädigten Datei oder zu einem Abbruch der Aufzeichnung führen.

- *A3: Zeit- und Ressourceneffiziente Fertigung.* <a3>
  In den meisten modernen Industriezweigen, sowie auch in der Formula Student, sind die Produktentwicklungszyklen extrem schnell. So muss das Team von Raceyard innerhalb nur eines halben Jahres einen Rennwagen konstruierten und fertigen. Aus diesem Grund müssen sowohl die Entwicklungszeit von Hardware und Software, sowie auch die Beschaffung der Komponenten, und natürlich die Fertigung und anschließende Inbetriebnahme und eventuelle Fehlersuche des Datenloggers besonders schnell und einfach, und die Kosten gering sein. Qualitätssicherungsmethoden muss hohe Aufmerksamkeit zukommen, Fehlermöglichkeiten müssen in allen Produktentwicklungsphasen systematisch minimiert werden.

- *A4: Geringe Masse und Größe* <a4>
  Um höchste Leistungsdichte und Energieeffizienz zu erreichen, ist Leichtbau das Kernprinzip des modernen Fahrzeugbaus.
  In der Formula Student gilt dies in besonderem Maße, denn auf das Fahrzeug wirken enorme Quer- und Längsbeschleunigungen, und zusätzliche Masse erhöht nach dem zweiten Newtonschen Gesetz die erforderliche Kraft und damit physikalische Arbeit für diese Beschleunigung. Der Datenlogger muss deshalb leicht, kompakt und mechanisch robust sein. Die Zielmasse orientiert sich an den aktuellen Marktführern, eine umfassende Analyse folgt in @state-of-the-art.


- *A5: Zukunftsfähigkeit* <a5>
  Systemkkonzepte, technische Anforderungen sowie regulatorischen Rahmenbedingungen sind in höchstem Maße dynamisch. Es bedarf also eines Systems, welches sowohl leicht verständlich, also auch flexibel anpassbar ist. Das Design soll eine universelle, erweiterbare Plattform darstellen. Durch diese kann die Funktionalität des Datenloggers in Zukunft vollständig in das eingebettete Regelungssystem des Fahrzeuges integriert werden. Das System soll abwärts- sowie aufwärtskompatibel sein, um einerseits als Ersatz für bisherige Lösungen zu dienen, gleichzeitig aber eine Plattform zu bieten, welche gut mit wachsende Anforderungen skaliert.


== Stand der Technik <state-of-the-art>

Auf dem Markt existieren nur eine geringe Anzahl an CAN-FD-Datenloggern, die diesen Anforderungen entsprechen. 

Datenlogger, die für die Automobilindustrie entwickelt wurden, sind meist als robuste Multi-Bus-Logger mit umfangreicher Konnektivität ausgeführt. Die größten Einschränkungen sind dabei oft die Anzahl der CAN-FD-Kanäle, das Gewicht und Volumen sowie der Anschaffungspreis.
Die hier gelisteten Geräte entsprechen am ehesten den Anforderungen dieses Projekts und dienen als technische Referenz:

Die öffentlich einsehbaren Eigenschaften der angebotenen Produkte werden nach folgendem Schema gewertet. Die Eigenschaften sind in allen Tabellen nach den Anforderungen A1 bis A5 geordnet. Auf eine Gewichtung der Kriterien wird aus Gründen der Einfachheit verzichtet.

#align(center)[
  #figure(
    table(
      columns:(1fr,5fr),
      align: left, inset: 2mm,
      table.header([Bewertung],[Bedeutung]),
      [-1],[Eigenschaft ist für die Erreichung der Projektanforderungen nach @requirements-matrix hinderlich.],
      [0], [Eigenschaft hat keine Relevanz für die Projektziele und wirkt somit weder positiv noch negativ.],
      [1], [Eigenschaft ist den Projektzielen zuträglich.]
    ),
    caption: [Bewertungsskala für Marktanalyse]
  )
]

#block(breakable: false)[
=== *Influx ReXgen Air*


#align(center)[
  #figure(
    image("pictures/rexgenair.webp", width: 30%),
    caption: [Influx ReXgen Air @rexgenair]
  )
]

#align(center)[
  #figure(
  table(
    columns: (1fr, 4fr, 1fr),
    align: left, inset: 2mm,
    table.header([Anfor-\derung],[Eigenschaft],[Bewertung]),
    [#link(<a1>)[A1]],[Datenübertragung über LTE statt über USB],[-1],
    [#link(<a1>)[A1]],[Verschlüsselte Datenübertragung],[-1],
    [#link(<a1>)[A1]],[Browserbasierte Bedienoberfläche],[0],
    [#link(<a2>)[A2]],[Fest integrierter eMMC-Speicher mit 32 GB],[0],
    [#link(<a3>)[A3]],[Preis von etwa 1.215 USD],[1],
    [#link(<a4>)[A4]],[Masse von 112 g],[1],
    [#link(<a4>)[A4]],[Volumen von 195 cm³],[1],
    [#link(<a5>)[A5]],[Open-Source-API],[1],
    [#link(<a5>)[A5]],[Integrierte inertiale Messeinheit],[0],
    [#link(<a5>)[A5]],[Vier unabhängige CAN-Kanäle],[1],
    [#link(<a5>)[A5]],[Zwei digitale und zwei analoge Messeingänge],[0],
    [],[*Summe*],[*4*]
),
caption: [Evaluation des Influx ReXgen Air @rexgenair]
  )
]
]

#block(breakable: false)[
=== *Kvaser Memorator Pro 5xHS*
#align(center)[
  #figure(
    image("pictures/memorator.jpg", width: 30%),
    caption: [Kvaser Memorator Pro 5xHS @kvaser]
  )
]
#align(center)[
  #figure(
  table(
    columns: (1fr, 4fr, 1fr),
    align: left, inset: 2mm,
    table.header([Anfor-\derung],[Eigenschaft],[Bewertung]),
    [#link(<a1>)[A1]],[Zentraler D-Sub-Steckverbinder für alle Signale],[1],
    [#link(<a1>)[A1]],[Unterstützung von SocketCAN (Linux Kernel- Treiber)],[1],
    [#link(<a2>)[A2]],[Umfangreiche Filterfunktionen],[1],
    [#link(<a2>)[A2]],[SD-Karte mit wählbarer Speicherkapazität],[1],
    [#link(<a3>)[A3]],[Preis von etwa 3.362 USD],[-1],
    [#link(<a4>)[A4]],[Masse von 159 g],[0],
    [#link(<a4>)[A4]],[Volumen von 242 cm³],[1],
    [#link(<a5>)[A5]],[Fünf CAN-FD-Kanäle],[1],

    [],[*Summe*],[*5*]
),
caption: [Evaluation des Kvaser Memorator Pro 5 @kvaser]
  )
]
]


#block(breakable: false)[
=== *Vector GL2400*
#align(center)[
  #figure(
    image("pictures/vectorgl.jpg", width: 60%),
    caption: [Vector GL2400 @vectorgl]
  )
]
  #figure(
  table(
    columns: (1fr, 4fr, 1fr),
    align: left, inset: 2mm,
    table.header([Anfor-\derung],[Eigenschaft],[Bewertung]),
    [#link(<a1>)[A1]],[Auswertung mit CANalyzer oder CANoe],[1],
    [#link(<a1>)[A1]],[Drahtlose Datenübertragung über 3G],[0],
    [#link(<a2>)[A2]],[Speicherung auf SSD oder SD-Karte],[1],
    [#link(<a3>)[A3]],[Preis nicht öffentlich angegeben],[-1],
    [#link(<a4>)[A4]],[Masse von etwa 580 g],[-1],
    [#link(<a4>)[A4]],[Volumen von 839 cm³],[-1],
    [#link(<a5>)[A5]],[Vier CAN-Kanäle],[1],
    [#link(<a5>)[A5]],[Unterstützung von Ethernet, FlexRay und LIN],[0],

    [],[*Summe*],[*0*]
),
caption: [Evaluation des Vector GL2400 @vectorgl]
  )
]

*Fazit*

Der Kvaser Memorator Pro 5xHS überzeugt durch sein geringes Gewicht und einfacher Anbindung von 5 CAN- FD Kanälen, weshalb sein Design im Folgenden Analysiert und als technische Referenz genutzt wird.

#pagebreak()

== Referenzdesign-Analyse

Auf Produktbildern des Memorator Pro 5- PCBs ist erkennbar, dass dieser einen 3.7V 500mAh Li-ion Batterie verwendet. Als User-interface wird eine Micro-USB Buchse eingesetzt.

#align(center)[
  #figure(
    image("pictures/memorator-pro5-pcb-2.webp", width: 60%),
    caption: [PCB des Kvaser Memorator Pro 5 @kvaser-pcb]
  )
]


#align(center)[
  #figure(
    image("pictures/memorator-pro5-pcb.webp", width: 80%),
    caption: [PCB des Kvaser Memorator Pro 5 @kvaser-pcb]
  )
]

#align(center)[
  #figure(
    image("pictures/memorator-pro2-pcb-2.webp", width: 80%),
    caption: [USB- Anschluss am Kvaser Memorator Pro 5 @kvaser-pcb]
  )
]

Anhand von Produktbildern des Memorator Pro 5 ist nicht erkennbar, welche integrierten Schaltkreise genutzt werden.
Ein Hinweis findet sich allerdings in der minimaleren und günstigeren Ausführung des Datenloggers, dem Memorator Pro 2, welcher nur 2 CAN-FD Kanäle besitzt. 

#align(center)[
  #figure(
    image("pictures/memorator-pro2-pcb-1.webp", width: 100%),
    caption: [PCB des Kvaser Memorator Pro 2 @kvaser-chip]
  )
]

Bei dieser Platine wurde sich offensichtlich für ein Altera Cyclone- FPGA entschlossen. 
Dies ist technisch eine sehr naheliegende Lösung, da die extrem flexible Gestaltung der digitalen Schaltungen durch individuelle Auswahl von IP-Cores in einem FPGA sich besonders für spezialisierte und hoch Echtzeit- performante Anwendungen eignet. 

#align(center)[
  #figure(
    image("pictures/memorator-pro2-pcb-3.webp", width: 80%),
    caption: [PCB des Kvaser Memorator Pro 2 mit Akku und SD-Karte @kvaser-chip]
  )
]

#pagebreak()

== Anforderungsmatrix <requirements-matrix>

Um die Kriterien aus @requirements-analysis, welche die vom Nutzer wahrgenommenen und abstrakten Anforderungen darstellen, müssen nun, unter Berücksichtigung des Aktuellen Standes der Technik, in konkrete Technische Ziele und Merkmale überführt werden. Diese müssen dem SMART- Prinzip folgen, das heißt, sie müssen Spezifisch, Messbar, Attraktiv, Realistisch, und Terminierbar sein. @smart

#figure(
  table(
    columns: (1fr, 3fr, 3fr),
    align: left, inset: 2mm,
    table.header(
     [*Projekt-\Anfor-\derung*], [*Technisches Ziel*], [*Begründung*]
    ),

    [#link(<a1>)[A1]],
    [*T1:* <t1> Mounting in gängigen Betriebssystemen als standard USB- Device.],
    [Auslesen von Daten wird einfach und zuverlässig.],

    [#link(<a1>)[A1], #link(<a2>)[A2]],
    [*T2:* <t2> Speicherung der Daten in FAT-32- Format, Umwandlung in Datenlogger- Software.],
    [Nahtlose Weiterverwendung der Daten wird ermöglicht.],

    [#link(<a2>)[A2], #link(<a3>)[A3]],
    [*T3:* <t3> Nicht flüchtiges Speichergerät mit Speicher- Controller.],
    [Einfache Software, Speichermedium bleibt durch wear-leveling nach vielen Schreibzyklen zuverlässig, nach Power- off bleiben Daten vorhanden.],

    [#link(<a2>)[A2], #link(<a5>)[A5]],
    [*T4:* <t4> Außreichend großer Datenpuffer.],
    [Großer und performanter Zwischenspeicher beugt bei größeren Latenzen des permanenten Speichermediums Datenverlust vor.],
  
    [#link(<a2>)[A2]],
    [*T5:* <t5> Integrierter Energiespeicher.],
    [Nach Abschalten der Versorgung wird das System weiter versorgt, um den aktuellen Schreibvorgang anzuschließen. ],
      
      ),
)

#figure(
  table(
    columns: (1fr, 3fr, 3fr),
    align: left, inset: 2mm,
    table.header(
     [*Projekt-\Anfor-\derung*], [*Technisches Ziel*], [*Begründung*],
    ),
     [#link(<a2>)[A2], #link(<a3>)[A3], #link(<a5>)[A5]],
    [*T6:* <t6> Modulares Design.],
    [Klare Zuordnung von Funktionalitäten zu Komponenten und Baugruppen erleichtern Entwicklung, Eingrenzung von Fehlern, Anpassung des Designs sowie Integration in größere Baugruppen.],


    [#link(<a3>)[A3]],
    [*T7:* <t7> Testpads auf Platinen.],
    [Leicht zugängliche Testpads machen wichtige Netze per Multimeter überprüfbar.],


    [#link(<a3>)[A3]],
    [*T8:* <t8> Fertigung mit Lötpasten- Schablone und Reflow- Ofen.],
    [Durch definierte Temperaturprofile im Reflow- Ofen wird Lötstellen- Qualität kontrollierbar.],

    [#link(<a3>)[A3]],
    [*T9:* <t9> Nutzung von einfach lötbaren Packages für ICs.],
    [Packages mit großem Pitch und außenliegenden, optisch kontrollierbaren Pads ermöglichen Überpfüfung der Lötqualität.],

    [#link(<a4>)[A4], #link(<a5>)[A5]],
    [*T10:* <t10> Reduzierung der Platinengröße durch flexibles Routing.],
    [Verwendung von Komponenten mit frei konfigurierbaren Pin- Multiplexern reduziert Leiterbahnlängen sowie Anzahl der Vias und Layer.],
  ),

)

#figure(
  table(
    columns: (1fr, 3fr, 3fr),
    align: left, inset: 2mm,
    table.header(
     [*Projekt-\Anfor-\derung*], [*Technisches Ziel*], [*Begründung*],
    ),

    [#link(<a4>)[A4]],
    [*T11:* <t11> Verwendung von 1mm- Platinen.],
    [Gegenüber der Verwendung üblichen 1.55mm- Platinen wird der Daterlogger leichter.],

    [#link(<a2>)[A2], #link(<a5>)[A5]],
    [*T13:* <t13> Verwendung von leistungsstarken, aktuellen Komponenten.],
    [Strukturierte Architektur von Hard- und Software beschleunigen das Design, Sicherstellung von zukünftiger Verfügbarkeit und Kompatibilität],

    [#link(<a2>)[A2], #link(<a5>)[A5]],
    [*T14:* <t14> Multi-Channel Architektur],
    [Gleichzeitige Erfassung von mehreren unabhängigen Dantenbussen sowie mögliche Erweiterung auf weitere Kanäle und andere Datenbusse sorgen für hohe Kompatibilität.],
      ),
  caption: [Anforderungsmatrix],
)

// == Qualitätsfunktionendarstellung <quality-function-deployment>
//  Um anschließend zu überprüfen, in welchem Maße diese Produktmerkmale den tatsächlichen Anforderungen des Endbenutzers entsprechen, und daraus einen Qualitätsplan abzuleiten, wird die Methode des Quality Function Depoyment eingesetzt.

#pagebreak()




== Ziele und Umfang <goals-and-scope>

Ziel dieser Studienarbeit ist die Erforschung der grundlegenden Technologien, auswahl von Komponenten, Architektur für die Entwicklung,  eines CAN-FD-Fahrzeugdatenloggers für ein Formula- Student- Fahrzeug.

Hierzu wird ein vereinfachter Prototyp entwickelt, der die zentralen Funktionen eines solchen Systems validiert: das Empfangen von CAN-FD-Nachrichten und das dauerhafte Speichern dieser Daten auf einem lokalen Speichermedium.

Der Prototyp bildet nicht den vollständigen Fahrzeug-Datenlogger mit mehreren Kanälen und dessen integration in die Fahrzeugelektronik ab.


== Meilensteinplanung <milestones>
#align(center)[
  #figure(
    image("pictures/timeline.svg", width: 60%),
    caption: [Meilensteinplanung]
    
  )
]
