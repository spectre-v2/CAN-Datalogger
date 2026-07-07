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
== Meilensteinplanung

#align(center)[
  #figure(
    image("pictures/timeline.svg", width: 60%),
    caption: [Meilensteinplanung]
    
  )
]