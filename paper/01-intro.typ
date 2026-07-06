#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "header.typ":*

= Einleitung
Die Ingenieurswissenschaften treten im 21. Jahrhundert einer besonderen Herausforderung gegenüber: Höchste Anforderungen an die technik
in Funktionsumfang, Energieeffizienz, Kosten sowie Sicherheit machen präziseste Berechnungen in der Vorauslegung sowie verlässliche Validierung unverzichtbar.
Jede Konstruktion basiert auf Mathematischen Modellannahmen, welche fast immer eine starke Vereinfachung der realen Physik darstellen.
Eine Konstruktion ist erst dann validiert, wenn bewiesen werden kann, das ihr zugrunde liegende Mathematische Modell mit der Realitiät übereinstimmt.
Durch präzise und zuverlässige aufzeichnung kritischer Fahrzeugdaten lässt sich die Konstruktion iterativ verbessern.
@whitebook
== Anforderungsanalyse
=== Geringes Gewicht
In der Formula Student sind Streckenlayouts bewusst so gewählt, dass das Fahrzeug starke Querbeschleunigungen bewältigen muss.
Zu diesem Zweck muss das Gewicht des Fahrzeuges so gering wie möglich sein. Der Datenlogger sollte deshalb nicht über 100 gramm wiegen.
=== Zuverlässigkeit
Da wichtige Daten vorallem vor einem eventuellen Ausfall das Systems helfen, den Fehler zu rekonstruieren, muss die Aufzeichnung extrem Zuverlässig 
sein. Es müssen somit auch bei voller Buslast und hoher Datenrate über 90% der empfangenen Nachrichten aufgezeichnet werden. Zudem muss ein Sicherheits-
System vorhanden sein, welches bei einem prötzlichen vollständigen Abschalten des gesamten Fahrzeuges dafür sorgt, dass bis zur vollständigen Inaktivität aller Bus- Teilnehmer noch Daten aufgezeichnet werden, bevor der Datenlogger abschaltet.
== Geschwindigkeit

== Benutzerfreundlichkeit
Der Prozess des Auslesens und der Verarbeitung der gewonnenen Daten muss so einfach wie möglich sein. Zu diesem Zweck soll das System
vollständig ohne externe Software auf dem PC des Endbenutzers auskommen.
== Stand der Technik
== Umfang und Ziele
In dieser Studienarbeit soll zunächst das technische Grundwissen geschaffen werden, um die Entwicklung eines solchen Datenloggers zu ermöglichen. Zu diesem Zweck sollen Grundprinzipen eines naheliegenden Systemaufbaus erforscht und getestet werden.
== Meilensteinplanung //fletcher node für den Zeitstrahl

#let phase(pos, title, date, body, milestone) = node(
  pos,

  block(
    width: 170.0mm,
    inset: 3.0mm,
    fill: light_grey,
    stroke: 0.1mm,
    radius: 3.0mm,
    align(center)[
      #set par(justify: false)
      *#title. #date*

      #body

      *Meilenstein:* #milestone
    ],
  ),
)

#align(center)[
  #diagram(
    debug: 0,
    spacing: 2.2em,
    edge-stroke: 0.3mm,

    phase(
      (0, 0),
      "Phase 1 - Recherche & Systemarchitektur",
      "08.07-19.07",
      [Anforderungsanalyse, Stand der Technik, Auswahl der Hardware-Komponenten.],
      [Erstes Kapitel & Schaltplan fertig.]
    ),

    edge((0, 0), (0, 1), "-|>"),

    phase(
      (0, 1),
      "Phase 2 - Erster Prototyp, CAN-Anbindung",
      "20.07-02.08",
      [SPI-Treiber für CAN-Controller, Konfiguration, Auslesen der RX-Buffer.],
      [Kapitel 2 fertig & CAN-FD-Nachricht erfolgreich empfangen.]
    ),

    edge((0, 1), (0, 2), "-|>"),

    phase(
      (0, 2),
      "Phase 3 - Datenspeicherung",
      "03.08-16.08",
      [Buffern von eingehenden Nachrichten, Umwandlung in FAT32-Dateiformat, Schreibzugriff auf SD-Karte.],
      [Kapitel 3 fertig & Nachricht erfolgreich abgespeichert.]
    ),

    edge((0, 2), (0, 3), "-|>"),

    phase(
      (0, 3),
      "Phase 4 - Validierung und Benchmarking",
      "17.08-30.08",
      [Test unter hoher Datenrate von zweitem Mikrocontroller, Analyse der Robustheit.],
      [Daten zur Anzahl verlorener Frames erfolgreich berechnet und aufgezeichnet.]
    ),

    edge((0, 3), (0, 4), "-|>"),

    phase(
      (0, 4),
      "Phase 5 - Analyse und Evaluation",
      "31.08-13.09",
      [Statistische Auswertung, Abgleich mit Anforderungen und ursprünglichen Zielen.],
      [Analyse und Bewertung abgeschlossen.]
    ),

    edge((0, 4), (0, 5), "-|>"),

    phase(
      (0, 5),
      "Reflexion",
      "14.09-20.09",
      [Wissenschaftliche Aufarbeitung, Fazit und Politur.],
      [Finale Version fertiggestellt.]
    ),
  )
]