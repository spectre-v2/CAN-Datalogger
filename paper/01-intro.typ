#import "header.typ":*

= Einleitung
Moderne technische Systeme stehen unter dem Anspruch, maximale Qualität in Funktionalität, Energieeffizienz,   Zuverlässigkeit sowie Wirtschaftlichkeit zu vereinen. 

Die Grundlage jeder Entwicklung bilden mathematische Modelle, mit denen das Verhalten eines Systems bereits in der Entwurfsphase beschrieben und bewertet wird. Diese Modelle stellen jedoch zwangsläufig eine Vereinfachung der realen physikalischen Zusammenhänge dar. Ihre Aussagekraft ist daher erst dann gegeben, wenn sie durch Messdaten unter realen Betriebsbedingungen bestätigt werden.

Die präzise und zuverlässige Erfassung von Messdaten ist deshalb ein zentraler Bestandteil moderner Entwicklungsprozesse - sowohl in der industriellen Fahrzeugentwicklung als auch in der Formula Student. Sie ermöglicht es, theoretische Annahmen mit der Realität abzugleichen, konstruktive Schwachstellen eindeutig zu identifizieren und Systeme gezielt weiterzuentwickeln.

Ziel dieser Studienarbeit ist deshalb die Erarbeitung eines Konzeptes zur Aufzeichnung und Analyse relevanter Fahrzeugdaten eines Formula- Student Rennwagens, sowie die erforschung der technischen Grundlagen dieser.


#v(10mm)

#align(center)[
  #figure(
    image("pictures/ry2025.jpg", width:80%),
    caption: [Der A-25 von Raceyard.]
  )
]


= Methodik
Zur Erarbeitung eines Funktionalen Konzeptes orientiert sich diese Studienarbeit an einer leicht abgewandelten und präzisierteren Version des V- Modells aus der VDI- Richtlinie VDI/VDE- 2206 @vmod

#align(center)[
  #figure(
    image("/paper/pictures/v-model.svg", width: 80%),
    caption: [V-Modell. @vmod]
  )
]


#pagebreak()
== Anforderungsanalyse

Der Datenlogger wird nicht nur fest in ein Formula-Student-Fahrzeug integriert, sondern dient auch zukünftigen Generationen als Werkzeug, um Fahrzeugdaten zu erfassen, sowie als Referenz für zukünftige Designs. Instanzen oder Varianten des Datenloggers müssen einfach herstellbar, anpassbar, programmierbar und benutzbar sein. 
Daraus ergeben sich einige Zentrale Anforderungen:

- *Geringe Masse und Größe*
  In der Formula Student wirken hohe Quer- und Längsbeschleunigungen. Jede zusätzliche Masse erhöht nach dem zweiten Newtonschen Gesetz die erforderliche Kraft für dieselbe Beschleunigung. Das verschlechtert Beschleunigung, Bremsverhalten und Kurvendynamik. Der Datenlogger muss deshalb leicht, kompakt und mechanisch robust sein.

- *Robuste und vollständige Datenerfassung*
  Die wichtigsten Daten entstehen unmittelbar vor einem Fehler oder Systemausfall. Genau in diesem Bereich darf der Datenlogger nicht versagen. Er muss mehrere CAN-FD-Busse parallel erfassen, hohe Eingangsdatenraten verarbeiten und empfangene Nachrichten dauerhaft speichern. Auch ein plötzlicher Spannungsverlust darf nicht zu einer beschädigten Datei oder zu einem Abbruch der Aufzeichnung führen.

- *Einfache Nutzbarkeit*
  Messdaten sind nur wertvoll, wenn sie schnell ausgewertet werden können. Der Ausleseprozess muss deshalb extrem einfach sein. Der Endnutzer soll keine spezielle PC-Software installieren müssen. Die Daten müssen über eine Standardschnittstelle zugänglich sein und in einem offenen, klar dokumentierten Format vorliegen.

#pagebreak()
== Anforderungsmatrix

Die abstrakten Anforderungen werden in zwei Gruppen getrennt. Zwingende Anforderungen sind harte Ja/Nein-Kriterien: Wird eine davon nicht erfüllt, ist der Lösungsansatz für das Gesamtsystem ungeeignet. Bewertungsrelevante Anforderungen beschreiben dagegen messbare technische Eigenschaften, mit denen geeignete Lösungen miteinander verglichen werden.


#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: left,
    inset: 8pt,
    table.header(
      [*Nr.*],
      [*Ausschlusskriterium*],
      [*Muss-Bedingung*],
      [*Nachweis*],
    ),
    [A1 <a1>],
    [Mehrkanal-CAN-FD-Erfassung],
    [Das Gesamtsystem muss die gleichzeitige Erfassung von mindestens drei unabhängigen CAN-FD-Bussen ermöglichen.],
    [Prüfung der Systemarchitektur und erfolgreicher Empfang definierter Testnachrichten auf allen vorgesehenen Kanälen.],

    [A2 <a2>],
    [Nichtflüchtige Speicherung],
    [Empfangene Messdaten müssen dauerhaft auf einem nichtflüchtigen Speichermedium abgelegt werden.],
    [Aufzeichnung, Spannungsabschaltung und anschließende Prüfung der gespeicherten Datei.],

    [A3 <a3>],
    [Fertigbarer Prototyp],
    [Der Prototyp muss mit den verfügbaren Fertigungs- und Debug-Möglichkeiten aufbaubar und prüfbar sein.],
    [Prüfung von Gehäuseformen, Leiterplattenlayout, Lötbarkeit, Programmierzugang und Testpunkten.],
  ),
  caption: [Zwingende Anforderungen],
)

#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: left,
    inset: 8pt,
    table.header(
      [*Nr.*],
      [*Bewertungskriterium*],
      [*Messgröße*],
      [*Bewertung*],
    ),

    [A4 <a4>],
    [Datenintegrität],
    [Anteil vollständig und korrekt gespeicherter Nachrichten sowie Anzahl beschädigter Dateien im Belastungstest.],
    [Höherer Anteil korrekt gespeicherter Nachrichten und weniger beschädigte Dateien sind besser.],

    [A5 <a5>],
    [Datenrate und Pufferverhalten],
    [Maximal dauerhaft verarbeitbare Eingangsdatenrate, Pufferfüllstand und Speicherlatenz bei definierter Buslast.],
    [Höhere stabile Datenrate, geringerer Pufferfüllstand und geringere Latenz sind besser.],

    [A6 <a6>],
    [Abschaltsicherheit],
    [Zeitspanne nach Ausfall der Fahrzeugversorgung, in der ein Schreibvorgang noch abgeschlossen werden kann.],
    [Längere Überbrückungszeit und reproduzierbar abgeschlossene Dateien sind besser.],

    [A7 <a7>],
    [Auslesbarkeit und Datenformat],
    [Benötigte Schritte und Zeit zum Auslesen auf einem Standard-PC sowie Dokumentationsgrad des Dateiformats.],
    [Weniger Schritte, kürzere Auslesezeit und ein klar dokumentiertes Format sind besser.],

    [A8 <a8>],
    [Masse und Bauraum],
    [Gesamtmasse, Leiterplattenfläche und erforderliches Einbauvolumen des vollständigen Datenloggers.],
    [Geringere Masse und kleinerer Bauraum sind besser.],

    [A9 <a9>],
    [Kosten und Verfügbarkeit],
    [Stücklistenkosten, Anzahl schwer beschaffbarer Bauteile und Lieferbarkeit der Schlüsselkomponenten.],
    [Niedrigere Kosten und bessere Verfügbarkeit sind besser.],

    [A10 <a10>],
    [Erweiterbarkeit und Entwicklungsaufwand],
    [Freie Schnittstellen, Modularität der Hardware, Treiberqualität und Aufwand für Erweiterung auf weitere Kanäle.],
    [Mehr Reserven, klarere Modulgrenzen und geringerer Erweiterungsaufwand sind besser.],
  ),
  caption: [Bewertungsrelevante Anforderungen],
)


#pagebreak()

== Stand der Technik

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
== Ziele und Umfang
Ziel dieser Studienarbeit ist die Erforschung der grundlegenden Konzepte und Technologien für die Entwicklung eines mehrkanaligen CAN-FD-Fahrzeugdatenloggers. Hierzu wird ein vereinfachter Prototyp entwickelt, der die wesentlichen Kernprinzipien eines solchen Systems untersucht und validiert. Die gewonnenen Erkenntnisse bilden die technische Grundlage für die spätere Entwicklung eines leistungsfähigen Datenloggers zur hochpräzisen und synchronen Erfassung kritischer Fahrzeugdaten.

In dieser Studienarbeit soll zunächst das technische Grundwissen geschaffen werden, um die Entwicklung eines CAN-FD-Datenloggers für ein Formula-Student-Fahrzeug zu ermöglichen. Dazu werden die Kernprinzipien eines naheliegenden Systemaufbaus anhand eines vereinfachten Prototyps erforscht.

Der Prototyp bildet nicht den vollständigen späteren Fahrzeug-Datenlogger ab. Stattdessen wird bewusst ein reduzierter Versuchsaufbau verwendet. Dieser Aufbau konzentriert sich auf die zentrale Funktion des Systems: das Empfangen von CAN-FD-Nachrichten und das dauerhafte Speichern dieser Daten auf einem lokalen Speichermedium.

Der Umfang der Studienarbeit beschränkt sich auf einen einzelnen CAN-FD-Empfangskanal. Die Datenübertragung erfolgt nur in eine Richtung. Ein zweiter Testaufbau wird als Sender eingesetzt, um definierte CAN-FD-Nachrichten zu erzeugen.

Das Kernsystem basiert auf einem Mikrocontroller. Im Vergleich zu FPGA-basierten Lösungen bietet dieser eine deutlich einfachere Programmierung und eignet sich damit besser für eine schnelle Prototypenentwicklung. Der Fokus liegt auf der Anbindung eines externen CAN-FD-Controllers, der Verarbeitung der empfangenen CAN-FD-Nachrichten und der Speicherung dieser Daten auf einer SD-Karte. Programmierung und Debugging erfolgen über ein USB-Terminal. Die Auswertung der gespeicherten Daten erfolgt durch Entnehmen der SD-Karte und anschließendes Lesen der Datei am PC.

Nicht Bestandteil dieser Studienarbeit sind ein vollständiges Mehrkanal-System, oder eine vollständige Integration in die Fahrzeugelektronik. Diese Punkte sind für ein späteres Gesamtsystem relevant, liegen jedoch außerhalb des betrachteten Umfangs.

Die Studienarbeit gilt als abgeschlossen, wenn das Kernsystem validiert ist. Dafür muss nachgewiesen werden, dass der Prototyp CAN-FD-Nachrichten über einen Empfangskanal zuverlässig erfasst, verarbeitet und dauerhaft auf der SD-Karte speichert. Damit wird die technische Grundlage geschaffen, auf der ein späterer mehrkanaliger Fahrzeug-Datenlogger aufgebaut werden kann.

== Meilensteinplanung
#align(center)[
  #figure(
    image("pictures/timeline.svg", width: 60%),
    caption: [Meilensteinplanung]
    
  )
]
