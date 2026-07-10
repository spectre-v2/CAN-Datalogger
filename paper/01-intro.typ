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
    image("/paper/pictures/v-model.svg", width: 80%),
    caption: [V-Modell. @vmod]
  )
]

Dabei umfasst diese Studienarbeit jediglich Punkte V1 bis V5, sowie einen Unit- Test in stark vereinfachtem Umfang, um gezielt Fachwissen über die technischen Kernprizipien aufzubauen.

Um bei der Systemanforderungsanalyse die abstrakten Wünsche der beteiligten Personen in detaillierte technische Ziele zu fassen, wird sich der Methode der Qualitätsfunktionendarstellung oder auch "Quality Function Deployment" bedient. @qfd

#pagebreak()
== Anforderungsanalyse <requirements-analysis>

Der Datenlogger bildet eine wichtige Schnittstelle zwischen Mensch und Maschine. Er dient als zentrales Werkzeug für Ingenieure zur Erfassung und Auswertung von Fahrzeugdaten, um Konstruktionen zu Evaluieren und iterativ zu verbessern. Aus diesem Grund werden folgende Bedarfe des Endnutzers als Startpunkt für die Anforderungsanalyse verwendet: 

- *A1: Einfache Nutzbarkeit* <a1>
  Messdaten tragen nur dann zur tatsächlichen Verbesserung des Fahrzeuges bei, wenn sie schnell einfach und ohne besondere Vorkenntnisse ausgewertet werden können. Der Ausleseprozess muss deshalb extrem simpel sein. Die Daten müssen über eine Standardschnittstelle zugänglich sein und in einem offenen, klar dokumentierten Format vorliegen. Die Analyse muss über plattformübergreifend kompatible, frei verfügbare Software möglich sein.

- *A2: Zuverlässige Datenerfassung* <a2>
  Wichtige Informationen dürfen unter keinen Umständen verloren gehen. Da bei modernen Fahrzeugen enorme Datenmengen mit hohen Geschwindigkeiten auf Datenbussen übertragen werden, muss der Datenlogger echtzeitfähig sein, um auch unter höchster Last mit deterministischen Latenzen zuverlässig Daten zu speichern. Zudem entstehen sehr wertvolle Messdaten meist unmittelbar vor einem Fehler oder vollständigen Systemausfall, weshalb in diesem Szenario der Datenlogger nicht versagen darf. So darf auch ein plötzlicher Spannungsverlust nicht zu einer beschädigten Datei oder zu einem Abbruch der Aufzeichnung führen.

- *A3: Einfache und schnelle Fertigung.* <a3>
  In den meisten modernen Industriezweigen, sowie auch in der Formula Student, sind die Produktentwicklungszyklen extrem schnell. So muss das Team von Raceyard innerhalb nur eines halben Jahres einen Rennwagen konstruierten und fertigen. Aus diesem Grund müssen sowohl die Entwicklungszeit von Hardware und Software, sowie auch die Beschaffung der Komponenten, und natürlich die Fertigung und anschließende Inbetriebnahme und eventuelle Fehlersuche des Datenloggers besonders schnell und einfach, und die Kosten gering sein. Qualitätssicherungsmethoden muss hohe Aufmerksamkeit zukommen, Fehlermöglichkeiten müssen in allen Produktentwicklungsphasen systematisch minimiert werden.

- *A4: Geringe Masse und Größe* <a4>
  Um höchste Leistungsdichte und Energieeffizienz zu erreichen, ist Leichtbau das Kernprinzip des modernen Fahrzeugbaus.
  In der Formula Student gilt dies in besonderem Maße, denn auf das Fahrzeug wirken enorme Quer- und Längsbeschleunigungen, und zusätzliche Masse erhöht nach dem zweiten Newtonschen Gesetz die erforderliche Kraft und damit physikalische Arbeit für diese Beschleunigung. Der Datenlogger muss deshalb leicht, kompakt und mechanisch robust sein. Die Zielmasse orientiert sich an den aktuellen Marktführern, eine umfassende Analyse folgt in @state-of-the-art.

- *A5: Zukunftsfähigkeit* <a5>
  Systemkkonzepte, technische Anforderungen sowie regulatorischen Rahmenbedingungen sind in höchstem Maße dynamisch. Es bedarf also eines Systems, welches sowohl leicht verständlich, also auch flexibel anpassbar ist. Um ein Design zu erarbeiten, welches eine universelle, erweiterbare Plattform darstellt, wird eine Trennung von Funktionalitäten sowie ein Modularer Aufgebau angestrebt. Durch diese kann die Funktionalität des Datenloggers in Zukunft vollständig in das eingebettete Regelungssystem des Fahrzeuges integriert werden. Das System soll abwärts- sowie aufwärtskompatibel sein, um einerseits als Ersatz für bisherige Lösungen zu dienen, gleichzeitig aber eine Plattform zu bieten, welche gut mit wachsende Anforderungen skaliert.

#pagebreak()
== Anforderungsmatrix <requirements-matrix>

Um die Kriterien aus @requirements-analysis, welche die vom Nutzer wahrgenommenen und abstrakten Anforderungen darstellen, müssen nun in konkrete Technische Ziele und Merkmale überführt werden. Diese müssen dem SMART- Prinzip folgen, das heißt, sie müssen Spezifisch, Messbar, Attraktiv, Realistisch, und Terminiert sein. @smart

#figure(
  table(
    columns: (10mm, auto, auto, auto, auto),
    align: left, inset: 2mm,
    table.header(
     [*Anforderung*], [*Maßnahme*], [*Begründung*], [*Nachweis*], [*Termin*],
    ),

    [A1],
    [Natives USB- Device.],
    [Gerät mountet in allen gängigen Betriebssystemen als Standard- USB- Massenspeichergerät, wodurch das Auslesen von Daten einfach und zuverlässig ist.],
    [Erfolgreiches Auslesen einer empfangenen Nachricht am PC.], 
    [],

    [A1],
    [Speichern der Daten in FAT-32- Format],
    [Durch die Berechnung dieses Dateiformates innerhalb des Datenloggers ist die nahtlose Weiterverwendung ohne Zusatzsoftware nötig.],
    [Prüfen der Dateiintegrität.],
    [],

    [A2],
    [],
    [],
    [],

    [A2],
    [Verwenden einses nicht flüchtigen Speichergerätes mit Speicher- Controller.],
    [Speichermedium bleibt durch wear-leveling auch nach vielen Schreibzyklen Zuverlässig, nach Poweroff bleiben Daten vorhanden.],
    [Aufzeichnung, Spannungsabschaltung und anschließende Prüfung der gespeicherten Datei.],

    [A2],
    [Integration eines Energiespeichers],
    [Nach abschalten der Versorgung wird das System weiter versorgt, um den aktuellen Schreibvorgang anzuschließen. ],
    [Prüfung von Gehäuseformen, Leiterplattenlayout, Lötbarkeit, Programmierzugang und Testpunkten.],

    [A5],
    [Multi-Channel Architektur],
    [Deshalb soll der Datenlogger. Das System muss die gleichzeitige Erfassung von vier unabhängigen CAN-FD-Bussen ermöglichen. Maximal dauerhaft verarbeitbare Eingangsdatenrate, Pufferfüllstand und Speicherlatenz bei definierter Buslast.],
    [Höhere stabile Datenrate, geringerer Pufferfüllstand und geringere Latenz sind besser.],

    [Trennung von],
    [A6],
    [Abschaltsicherheit],
    [Zeitspanne nach Ausfall der Fahrzeugversorgung, in der ein Schreibvorgang noch abgeschlossen werden kann.],
    [Längere Überbrückungszeit und reproduzierbar abgeschlossene Dateien sind besser.],

    [A7],
    [Auslesbarkeit und Datenformat],
    [Benötigte Schritte und Zeit zum Auslesen auf einem Standard-PC sowie Dokumentationsgrad des Dateiformats.Deshalb soll der Datenlogger als USB- Device vom PC wie ein übliches USB-Massenspeichergerät auslesbar sein.
    Der Endnutzer soll keine spezielle PC-Software installieren müssen.],
    [Weniger Schritte, kürzere Auslesezeit und ein klar dokumentiertes Format sind besser.],

    [A8],
    [Masse und Bauraum],
    [Gesamtmasse, Leiterplattenfläche und erforderliches Einbauvolumen des vollständigen Datenloggers.],
    [Geringere Masse und kleinerer Bauraum sind besser.],

    [A9],
    [Kosten und Verfügbarkeit],
    [Stücklistenkosten, Anzahl schwer beschaffbarer Bauteile und Lieferbarkeit der Schlüsselkomponenten.],
    [Niedrigere Kosten und bessere Verfügbarkeit sind besser.],

    [A10],
    [Erweiterbarkeit und Entwicklungsaufwand],
    [Freie Schnittstellen, Modularität der Hardware, Treiberqualität und Aufwand für Erweiterung auf weitere Kanäle.],
    [Mehr Reserven, klarere Modulgrenzen und geringerer Erweiterungsaufwand sind besser.],
  ),
  caption: [Anforderungen],
)
== Qualitätsfunktionendarstellung <quality-function-deployment>

 Um anschließend zu überprüfen, in welchem Maße diese Produktmerkmale den tatsächlichen Anforderungen des Endbenutzers entsprechen, und daraus einen Qualitätsplan abzuleiten, wird die Methode des Quality Function Depoyment eingesetzt.

#pagebreak()

== Stand der Technik <state-of-the-art>

Auf dem Markt existieren nur eine geringe Anzahl an CAN-FD-Datenloggern, die diesen Anforderungen entsprechen. 

Datenlogger, die für die Automobilindustrie entwickelt wurden, sind meist als robuste Multi-Bus-Logger mit umfangreicher Konnektivität ausgeführt. Die größten Einschränkungen sind dabei oft die Anzahl der CAN-FD-Kanäle, das Gewicht und Volumen sowie der Anschaffungspreis.
Die hier gelisteten Geräte entsprechen am ehesten den Anforderungen dieses Projekts und dienen als technische Referenz:

#block(breakable: false)[
- *Influx ReXgen Air*
#align(center)[
  #figure(
    image("pictures/rexgenair.webp", width: 30%),
    caption: [Influx ReXgen Air]
  )
]
  - Kanäle: 4
  - Speicher: 32 GB eMMC
  - Gewicht: 112 g
  - Volumen: 195 cm³
  - Preis: ca. 1.215 USD
  - Quelle: Influx ReXgen Air Datenblatt @rexgenair
]

#block(breakable: false)[
- *Kvaser Memorator Pro 5xHS*
#align(center)[
  #figure(
    image("pictures/memorator.jpg", width: 30%),
    caption: [Kvaser Memorator Pro 5xHS]
  )
]
  - Kanäle: 5
  - Speicher: SD/SDHC, 16 GB
  - Gewicht: 159 g
  - Volumen: 242 cm³
  - Preis: ca. 3.362 USD
  - Quelle: Kvaser Produktseite @kvaser
]
#block(breakable: false)[
- *Vector GL2400*
#align(center)[
  #figure(
    image("pictures/vectorgl.jpg", width: 60%),
    caption: [Vector GL2400]
  )
]
  - Kanäle: 4
  - Speicher: SD/SDHC-Karte
  - Gewicht: ca. 580 g
  - Volumen: 839 cm³
  - Preis: auf Anfrage
  - Quelle: Vector GL Logger Produktseite @vectorgl
]
== Ziele und Umfang <goals-and-scope>
Ziel dieser Studienarbeit ist die Erforschung der grundlegenden Konzepte und Technologien für die Entwicklung eines mehrkanaligen CAN-FD-Fahrzeugdatenloggers. Hierzu wird ein vereinfachter Prototyp entwickelt, der die wesentlichen Kernprinzipien eines solchen Systems untersucht und validiert. Die gewonnenen Erkenntnisse bilden die technische Grundlage für die spätere Entwicklung eines leistungsfähigen Datenloggers zur hochpräzisen und synchronen Erfassung kritischer Fahrzeugdaten.

In dieser Studienarbeit soll zunächst das technische Grundwissen geschaffen werden, um die Entwicklung eines CAN-FD-Datenloggers für ein Formula-Student-Fahrzeug zu ermöglichen. Dazu werden die Kernprinzipien eines naheliegenden Systemaufbaus anhand eines vereinfachten Prototyps erforscht.

Der Prototyp bildet nicht den vollständigen späteren Fahrzeug-Datenlogger ab. Stattdessen wird bewusst ein reduzierter Versuchsaufbau verwendet. Dieser Aufbau konzentriert sich auf die zentrale Funktion des Systems: das Empfangen von CAN-FD-Nachrichten und das dauerhafte Speichern dieser Daten auf einem lokalen Speichermedium.

Der Umfang der Studienarbeit beschränkt sich auf einen einzelnen CAN-FD-Empfangskanal. Die Datenübertragung erfolgt nur in eine Richtung. Ein zweiter Testaufbau wird als Sender eingesetzt, um definierte CAN-FD-Nachrichten zu erzeugen.

Das Kernsystem basiert auf einem Mikrocontroller. Im Vergleich zu FPGA-basierten Lösungen bietet dieser eine deutlich einfachere Programmierung und eignet sich damit besser für eine schnelle Prototypenentwicklung. Der Fokus liegt auf der Anbindung eines externen CAN-FD-Controllers, der Verarbeitung der empfangenen CAN-FD-Nachrichten und der Speicherung dieser Daten auf einer SD-Karte. Programmierung und Debugging erfolgen über ein USB-Terminal. Die Auswertung der gespeicherten Daten erfolgt durch Entnehmen der SD-Karte und anschließendes Lesen der Datei am PC.

Nicht Bestandteil dieser Studienarbeit sind ein vollständiges Mehrkanal-System, oder eine vollständige Integration in die Fahrzeugelektronik. Diese Punkte sind für ein späteres Gesamtsystem relevant, liegen jedoch außerhalb des betrachteten Umfangs.

Die Studienarbeit gilt als abgeschlossen, wenn das Kernsystem validiert ist. Dafür muss nachgewiesen werden, dass der Prototyp CAN-FD-Nachrichten über einen Empfangskanal zuverlässig erfasst, verarbeitet und dauerhaft auf der SD-Karte speichert. Damit wird die technische Grundlage geschaffen, auf der ein späterer mehrkanaliger Fahrzeug-Datenlogger aufgebaut werden kann.

== Meilensteinplanung <milestones>
#align(center)[
  #figure(
    image("pictures/timeline.svg", width: 60%),
    caption: [Meilensteinplanung]
    
  )
]
