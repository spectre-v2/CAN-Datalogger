#import "header.typ":*

= Einleitung
Moderne technische Systeme stehen unter dem Anspruch, maximale Funktionalität, hohe Energieeffizienz, geringe Kosten und höchste Zuverlässigkeit miteinander zu vereinen. 

Die Grundlage jeder Entwicklung bilden mathematische Modelle, mit denen das Verhalten eines Systems bereits in der Entwurfsphase beschrieben und bewertet wird. Diese Modelle stellen jedoch zwangsläufig eine Vereinfachung der realen physikalischen Zusammenhänge dar. Ihre Aussagekraft ist daher erst dann gegeben, wenn sie durch Messdaten unter realen Betriebsbedingungen bestätigt werden.

Die präzise und zuverlässige Erfassung von Fahrzeugdaten ist deshalb ein zentraler Bestandteil moderner Entwicklungsprozesse - sowohl in der industriellen Fahrzeugentwicklung als auch in der Formula Student. Sie ermöglicht es, theoretische Annahmen mit der Realität abzugleichen, konstruktive Schwachstellen eindeutig zu identifizieren und Systeme auf Grundlage objektiver Messwerte gezielt weiterzuentwickeln.

Ziel dieser Studienarbeit ist die Erforschung der grundlegenden Konzepte und Technologien für die Entwicklung eines mehrkanaligen CAN-FD-Fahrzeugdatenloggers. Hierzu wird ein vereinfachter Prototyp entwickelt, der die wesentlichen Kernprinzipien eines solchen Systems untersucht und validiert. Die gewonnenen Erkenntnisse bilden die technische Grundlage für die spätere Entwicklung eines leistungsfähigen Datenloggers zur hochpräzisen und synchronen Erfassung kritischer Fahrzeugdaten.

#v(10mm)

#align(center)[
  #figure(
    image("pictures/ry2025.jpg", width:80%),
    caption: [Der A-25 von Raceyard.]
  )
]

#pagebreak()
== Anforderungsanalyse

Der Datenlogger wird fest in ein Formula-Student-Fahrzeug integriert. Damit wird er Teil eines extrem masseempfindlichen Gesamtsystems. Jede Zusatzmasse erhöht die Trägheit. Jeder zusätzliche Bauraum verschärft die Integration. Jeder verlorene Datensatz schwächt die spätere Fehleranalyse. Aus diesen Randbedingungen ergeben sich drei zentrale Anforderungen: 

- *Geringe Masse*
  In der Formula Student wirken hohe Quer- und Längsbeschleunigungen. Jede zusätzliche Masse erhöht nach dem zweiten Newtonschen Gesetz die erforderliche Kraft für dieselbe Beschleunigung. Das verschlechtert Beschleunigung, Bremsverhalten und Kurvendynamik. Der Datenlogger muss deshalb leicht, kompakt und mechanisch robust sein.

- *Robuste und vollständige Datenerfassung*
  Die wichtigsten Daten entstehen unmittelbar vor einem Fehler oder Systemausfall. Genau in diesem Bereich darf der Datenlogger nicht versagen. Er muss mehrere CAN-FD-Busse parallel erfassen, hohe Eingangsdatenraten verarbeiten und empfangene Nachrichten dauerhaft speichern. Auch ein plötzlicher Spannungsverlust darf nicht zu einer beschädigten Datei oder zu einem Abbruch der Aufzeichnung führen.

- *Einfache Nutzbarkeit*
  Messdaten sind nur wertvoll, wenn sie schnell ausgewertet werden können. Der Ausleseprozess muss deshalb extrem einfach sein. Der Endnutzer soll keine spezielle PC-Software installieren müssen. Die Daten müssen über eine Standardschnittstelle zugänglich sein und in einem offenen, klar dokumentierten Format vorliegen.

#pagebreak()
== Anforderungsmatrix

Die abstrakten Anforderungen werden nach dem SMART-Prinzip in konkrete technische Ziele überführt. Jedes Ziel ist spezifisch, messbar, erreichbar, relevant und terminiert. @smart


#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: left,
    inset: 8pt,
    table.header(
      [*Nr.*],
      [*Technische Anforderung*],
      [*Ziel*],
      [*Nachweis*],
    ),

    [A1 <a1>],
    [CAN-FD-Schnittstellen],
    [Mindestens 3 unabhängige CAN-FD-Kanäle parallel erfassen können.],
    [Prüfung der Hardware-Schnittstellen und erfolgreicher Empfang definierter Testnachrichten auf allen Kanälen.],

    [A2 <a2>],
    [Systemmasse],
    [Die Masse des vollständigen Datenloggers darf 100g nicht überschreiten.],
    [Messung der Gesamtmasse mit Leiterplatte, Gehäuse und notwendigen Anschlussleitungen.],

    [A3 <a3>],
    [Systemvolumen],
    [Das Volumen des vollständigen Datenloggers darf 250 cm³ nicht überschreiten.],
    [Berechnung.],

    [A4 <a4>],
    [Datenintegrität],
    [Bei definierter maximaler Buslast müssen mindestens 99% der empfangenen Nachrichten dauerhaft gespeichert werden.],
    [Vergleich der empfangenen Nachrichten mit den gespeicherten Datensätzen im Belastungstest.],

    [A5 <a5>],
    [Datenrate und Pufferverhalten],
    [Der Datenlogger muss die Eingangsdatenrate aller aktiven CAN-FD-Kanäle ohne Rückstau verarbeiten.],
    [Messung der Pufferfüllstände Messung der Speicherlatenz.],
  ),
  caption: [Anforderungsmatrix],
)

#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: left,
    inset: 8pt,
    table.header(
      [*Nr.*],
      [*Technische Anforderung*],
      [*Ziel*],
      [*Nachweis*],
    ),

    [A6 <a6>],
    [Abschaltsicherheit],
    [Nach Ausfall der Fahrzeugversorgung muss der Datenlogger mindestens 1s weiter betrieben werden und den aktuellen Schreibvorgang abschließen.],
    [Simulierter Spannungsverlust mit anschließender Prüfung der Datensatzvollständigkeit.],

    [A7 <a7>],
    [Auslesbarkeit und Datenformat],
    [Die Messdaten müssen ohne spezielle PC-Software über eine Standardschnittstelle auslesbar sein und in einem offenen, dokumentierten Format vorliegen.],
    [Auslesen auf einem unveränderten Windows-PC und Auswertung der erzeugten Datei mit Standardwerkzeugen.],

    [A8 <a8>],
    [Produktionskosten],
    [Die Materialkosten des vollständigen Prototyps dürfen 100 EUR nicht überschreiten.],
    [Erstellung einer Stückliste mit Einzelpreisen und Berechnung der Gesamtkosten.],

    [A9 <a9>],
    [Einfache Fertigung und Fehlersuche],
    [Der Prototyp muss mit gut lötbaren Bauteilen, klarem Leiterplattenlayout, dokumentierten Schnittstellen und definierten Testpunkten aufgebaut werden.],
    [Prüfung des Leiterplattenlayouts, Sichtprüfung der Baugruppe und elektrische Messung an den Testpunkten.],

    [A10 <a10>],
    [Schnelle Produktentwicklung],
    [Der Systemaufbau muss funktional klar getrennt, flexibel erweiterbar und softwareseitig sauber strukturiert sein.],
    [Prüfung der Modulstruktur in Hardware und Software sowie Nachvollziehbarkeit der Signal- und Datenpfade.],
  ),
  caption: [Anforderungsmatrix, Fortsetzung],
)


#pagebreak()

== Stand der Technik

Auf dem Markt existieren nur eine geringe Anzahl an CAN-FD-Datenloggern, die diesen Anforderungen entsprechen. 

Datenlogger, die für die Automobilindustrie entwickelt wurden, sind meist als robuste Multi-Bus-Logger mit umfangreicher Konnektivität ausgeführt. Die größte Einschränkung ist dabei oft die Anzahl der CAN-FD-Kanäle, das Gewicht und Volumen sowie der Anschaffungspreis.
Die hier gelisteten Geräte entsprechen am ehesten den Anforderungen dieses Projekts und dienen als technische Referenz:

#block(breakable: false)[
- *Influx ReXgen Air*
#align(center)[
  #figure(
    image("pictures/rexgenair.webp", width: 30%),
    caption: [Influx ReXgen Air]
  )
]
  - Kanäle: bis zu 4x CAN/CAN-FD
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
