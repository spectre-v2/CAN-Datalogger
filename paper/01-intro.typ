#import "header.typ":*

= Einleitung
Moderne Technik muss in Funktionsumfang, Energieeffizienz, Kosten sowie Sicherheit höchsten standarts entsprechen. präziseste Berechnungen in der Vorauslegung sowie verlässliche Validierung sind unverzichtbar.
Jede Konstruktion basiert auf Mathematischen Modellannahmen, welche fast immer eine starke Vereinfachung der realen Physik darstellen.
Eine Konstruktion ist erst dann validiert, wenn bewiesen werden kann, das ihr zugrunde liegende Mathematische Modell mit der Realitiät übereinstimmt. Zu diesem Zweck bedarf es einen schnellen zuverlässigen CAN- FD datenlogger.
Durch präzise und zuverlässige aufzeichnung kritischer Fahrzeugdaten lässt sich die Konstruktion iterativ verbessern.
== Anforderungsanalyse
=== Geringes Gewicht
In der Formula Student sind Streckenlayouts bewusst so gewählt, dass das Fahrzeug starke Querbeschleunigungen bewältigen muss.
Zu diesem Zweck muss das Gewicht des Fahrzeuges so gering wie möglich sein. Der Datenlogger sollte deshalb nicht über 100 gramm wiegen.
=== Zuverlässigkeit
Da wichtige Daten vorallem vor einem eventuellen Ausfall das Systems helfen, den Fehler zu rekonstruieren, muss die Aufzeichnung extrem Zuverlässig 
sein. Es müssen somit auch bei voller Buslast und hoher Datenrate über 90% der empfangenen Nachrichten aufgezeichnet werden. Zudem muss ein Sicherheits-
System vorhanden sein, welches bei einem prötzlichen vollständigen Abschalten des gesamten Fahrzeuges dafür sorgt, dass bis zur vollständigen Inaktivität aller Bus- Teilnehmer noch Daten aufgezeichnet werden, bevor der Datenlogger abschaltet.
=== Geschwindigkeit

=== Datenausle

=== Benutzerfreundlichkeit
Der Prozess des Auslesens und der Verarbeitung der gewonnenen Daten muss so einfach wie möglich sein. Zu diesem Zweck soll das System
vollständig ohne externe Software auf dem PC des Endbenutzers auskommen.

=== Anforderungsmatrix

#table(
  columns: (auto, auto, auto,auto,auto, auto),
  inset: 10pt,
  align: horizon,
  table.header(
    [Kriterium], [Gewichtung], [],
  )
)

== Stand der Technik


- *Influx ReXgen Air*
#align(center)[
  #figure(
    image("pictures/rexgenair.webp", width: 40%),
    caption: [Influx ReXgen Air]
  )
]
  - Kanäle: bis zu 4x CAN/CAN-FD
  - Speicher: 32 GB eMMC
  - Gewicht: 112 g
  - Volumen: 195 cm³
  - Preis: ab ca. 1.215 USD
  - Quelle: Influx ReXgen Air Datenblatt @rexgenair

- *Kvaser Memorator Pro 5xHS*
#align(center)[
  #figure(
    image("pictures/memorator.jpg", width: 40%),
    caption: [Kvaser Memorator Pro 5xHS]
  )
]
  - Kanäle: 5
  - Speicher: SD/SDHC, 16 GB
  - Gewicht: 159 g
  - Volumen: 242 cm³
  - Preis: ca. 3.362 USD
  - Quelle: Kvaser Produktseite @kvaser

- *Vector GL2400*
#align(center)[
  #figure(
    image("pictures/vectorgl.jpg", width: 60%),
    caption: [Influx ReXgen Air]
  )
]
  - Kanäle: 4x CAN-FD, 2x LIN
  - Speicher: SD/SDHC-Karte
  - Gewicht: ca. 580 g
  - Volumen: 839 cm³
  - Preis: auf Anfrage
  - Quelle: Vector GL Logger Produktseite @vectorgl




== Umfang und Ziele
In dieser Studienarbeit soll zunächst das technische Grundwissen geschaffen werden, um die Entwicklung eines solchen Datenloggers zu ermöglichen. Zu diesem Zweck sollen Grundprinzipen eines naheliegenden Systemaufbaus erforscht und getestet werden.

== Meilensteinplanung
#align(center)[
  #figure(
    image("pictures/timeline.svg", width: 60%),
    caption: [Meilensteinplanung]
    
  )
]