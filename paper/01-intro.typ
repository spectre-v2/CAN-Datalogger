#import "header.typ":*

= Einleitung
Moderne Technik muss in Funktionsumfang, Energieeffizienz, Kosten sowie Sicherheit höchsten Standards entsprechen. Aus diesem Grund sind präzise Berechnungen in der Vorauslegung sowie eine verlässliche Validierung dieser unverzichtbar.
Jede Konstruktion basiert auf mathematischen Modellannahmen, die fast immer eine starke Vereinfachung der realen Physik darstellen.
Eine Konstruktion ist erst dann validiert, wenn bewiesen werden kann, dass das ihr zugrunde liegende mathematische Modell mit der Realität übereinstimmt.
Durch präzise und zuverlässige Aufzeichnung kritischer Fahrzeugdaten lässt sich die Konstruktion iterativ verbessern.

== Anforderungsanalyse

- Geringes Gewicht
In der Formula Student sind Streckenlayouts bewusst so gewählt, dass das Fahrzeug starke Querbeschleunigungen bewältigen muss. Zu diesem Zweck muss das Gewicht des Fahrzeugs so gering wie möglich sein.

- Zuverlässigkeit und Geschwindigkeit
Da wichtige Daten vor allem vor einem eventuellen Ausfall des Systems helfen, den Fehler zu rekonstruieren, muss die Aufzeichnung extrem zuverlässig sein. Es müssen somit auch bei voller Buslast und hoher Datenrate über 90 % der empfangenen Nachrichten aufgezeichnet werden. Zudem muss ein Sicherheitssystem vorhanden sein, das bei einem plötzlichen vollständigen Abschalten des gesamten Fahrzeugs dafür sorgt, dass bis zur vollständigen Inaktivität aller Bus-Teilnehmer noch Daten aufgezeichnet werden, bevor der Datenlogger abschaltet. Zudem muss der Speichervorgang schnell genug sein, sodass auch bei hohen Eingangsdatenraten alle wichtigen Informationen gespeichert werden können.

- Benutzerfreundlichkeit
Der Prozess des Auslesens und der Verarbeitung der gewonnenen Daten muss so einfach wie möglich sein. Zu diesem Zweck soll das System vollständig ohne externe Software auf dem PC des Endbenutzers auskommen.

=== Anforderungsmatrix

- wird noch ergänzt
// #table(
//  align: horizon,
//   table.header(
//     [Kriterium], [Gewichtung], [],
//   )  columns: (auto, auto, auto, auto,auto, auto),
//   inset: 10pt,
// 
//)

#pagebreak()

== Stand der Technik

Auf dem Markt existieren nur eine geringe Anzahl an CAN-FD-Datenloggern, die den Anforderungen dieses Anwendungsfalls entsprechen. Datenlogger, die für die Automobilindustrie entwickelt wurden, sind meist als robuste Multi-Bus-Logger mit umfangreicher Konnektivität ausgeführt. Die größte Einschränkung ist dabei oft die Anzahl der CAN-FD-Kanäle, das Gewicht und Volumen sowie der Anschaffungspreis.
Die gelisteten Geräte entsprechen am ehesten den Anforderungen dieses Projekts und dienen als technische Referenz:

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
  - Preis: ca. 1.215 USD
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
    caption: [Vector GL2400]
  )
]
  - Kanäle: 4
  - Speicher: SD/SDHC-Karte
  - Gewicht: ca. 580 g
  - Volumen: 839 cm³
  - Preis: auf Anfrage
  - Quelle: Vector GL Logger Produktseite @vectorgl




== Umfang und Ziele
In dieser Studienarbeit soll zunächst das technische Grundwissen geschaffen werden, um die Entwicklung eines solchen Datenloggers zu ermöglichen. Zu diesem Zweck sollen die Kernprinzipien eines naheliegenden Systemaufbaus anhand eines vereinfachten Prototyps erforscht und getestet werden.


== Meilensteinplanung
#align(center)[
  #figure(
    image("pictures/timeline.svg", width: 60%),
    caption: [Meilensteinplanung]
    
  )
]