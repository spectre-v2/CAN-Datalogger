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

  Messdaten tragen nur dann zur tatsächlichen Verbesserung des Fahrzeuges bei, wenn sie schnell, einfach und ohne besondere Vorkenntnisse ausgewertet werden können. Der Ausleseprozess muss deshalb extrem simpel sein.

- *A2: Zuverlässige Datenerfassung* <a2>

  Wichtige Informationen dürfen nicht verloren gehen. Die Messdaten müssen auch bei hohen Datenmengen des Fahrzeugs und unmittelbar vor einem Fehler oder vollständigen Systemausfall verlässlich verfügbar sein.

- *A3: Zeit- und Ressourceneffiziente Herstellung.* <a3>

  In den meisten modernen Industriezweigen sowie auch in der Formula Student sind die Produktentwicklungszyklen extrem schnell. Das Team von Raceyard muss innerhalb nur eines halben Jahres einen Rennwagen konstruieren und fertigen. Entwicklung, Beschaffung, Fertigung und Inbetriebnahme des Datenloggers müssen daher mit geringen Zeit- und Kostenaufwand möglich sein.

- *A4: Geringe Masse und Größe* <a4>

  Um höchste Leistungsdichte und Energieeffizienz zu erreichen, ist Leichtbau das Kernprinzip des modernen Fahrzeugbaus.
  In der Formula Student gilt dies in besonderem Maße, denn auf das Fahrzeug wirken enorme Quer- und Längsbeschleunigungen, und zusätzliche Masse erhöht nach dem zweiten Newtonschen Gesetz die erforderliche Kraft und damit die physikalische Arbeit für diese Beschleunigung. Der Datenlogger soll den Bauraum und die Fahrdynamik deshalb möglichst wenig beeinträchtigen.


- *A5: Zukunftsfähigkeit* <a5>

  Systemkonzepte, technische Anforderungen sowie regulatorische Rahmenbedingungen sind in hohem Maße dynamisch. Es bedarf daher eines leicht verständlichen und flexibel anpassbaren Systems, das sowohl bisherige Lösungen ersetzen als auch mit wachsenden Anforderungen skalieren kann.


== Anforderungsmatrix <requirements-matrix>

Die in @requirements-analysis beschriebenen Nutzeranforderungen werden im Folgenden in konkrete technische Anforderungen überführt.
Diese müssen dem SMART- Prinzip folgen, das heißt, sie müssen Spezifisch, Messbar, Attraktiv, Realistisch, und Terminierbar sein. @smart

#figure(
  table(
    columns: (1fr, 2fr),
    align: left, inset: 3mm,
    table.header(
     [*Projektanforderung*], [*Technische Anforderung*]
    ),

    [#link(<a1>)[A1: Einfache Nutzbarkeit]],
    [*T1: Standardisierte Datenauslese* <t1> #linebreak() Die Messdaten müssen über eine Standardschnittstelle auf gängigen Betriebssystemen ohne proprietäre Software auslesbar sein.],

    [#link(<a1>)[A1: Einfache Nutzbarkeit]],
    [*T2: Offenes Datenformat* <t2> #linebreak() Die Messdaten müssen in einem offenen, klar dokumentierten Format vorliegen, das mit frei verfügbarer, plattformübergreifender Software analysierbar ist.],

    [#link(<a2>)[A2: Zuverlässige Datenerfassung]],
    [*T3: Echtzeitfähige Datenerfassung* <t3> #linebreak() Das System muss CAN-FD-Nachrichten bei der vorgesehenen maximalen Buslast mit deterministischen Latenzen und ohne Nachrichtenverlust erfassen.],

    [#link(<a2>)[A2: Zuverlässige Datenerfassung]],
    [*T4: Ausfallsichere Speicherung* <t4> #linebreak() Messdaten müssen dauerhaft gespeichert werden; ein plötzlicher Spannungsverlust darf weder Dateien beschädigen noch die laufende Aufzeichnung unabgeschlossen beenden.],
      ),
)

#figure(
  table(
    columns: (1fr, 2fr),
    align: left, inset: 3mm,
    table.header(
     [*Projektanforderung*], [*Technische Anforderung*],
    ),

    [#link(<a2>)[A2: Zuverlässige Datenerfassung], 
    
    #link(<a5>)[A5: Zukunftsfähigkeit]],
    [*T5: Mehrkanal-Datenerfassung* <t5> #linebreak() Das System muss mindestens vier unabhängige CAN-FD-Busse gleichzeitig erfassen können und für weitere Datenkanäle erweiterbar sein.],

    [#link(<a3>)[A3: Zeit- und ressourceneffiziente Fertigung]],
    [*T6: Einfache, schnelle Entwicklung* <t6> #linebreak() Hard- und Software müssen schnell entwickelt, in Betrieb genommen validiert werden. Dafür sind gut dokumentierte Komponenten, verfügbare Entwicklungswerkzeuge und einfache Debug-Möglichkeiten einzusetzen.],

    [#link(<a3>)[A3: Zeit- und ressourceneffiziente Fertigung]],
    [*T7: Prüfgerechte Fertigung* <t7> #linebreak() Hardware, Bauteile und Schnittstellen müssen mit den im Team verfügbaren Mitteln herstellbar sein. Qualitätssicherungsmaßnahmen müssen Fehler systematisch minimieren.],

    [#link(<a4>)[A4: Geringe Masse und Größe]],
    [*T8: Kompakte, robuste Bauform* <t8> #linebreak() Masse und Volumen dürfen die Größenordnung der besten auf dem Markt verfügbaren Fahrzeugdatenlogger nicht überschreiten.],

    [#link(<a3>)[A3: Zeit- und ressourceneffiziente Fertigung], 
    
    #link(<a5>)[A5: Zukunftsfähigkeit]],
    [*T9: Modulare Erweiterbarkeit* <t9> #linebreak() Hard- und Software müssen in austauschbare Funktionsbereiche gegliedert sein; zusätzliche Schnittstellen und zukünftige Fahrzeugfunktionen bis hin zur Integration in die Fahrzeugregelung müssen ohne grundlegende Neukonstruktion integrierbar sein.],
      ),
  caption: [Anforderungsmatrix],
)

== Stand der Technik <state-of-the-art>

Auf dem Markt existieren nur eine geringe Anzahl an CAN-FD-Datenloggern, die diesen Anforderungen entsprechen. 

Datenlogger, die für die Automobilindustrie entwickelt wurden, sind meist als robuste Multi-Bus-Logger mit umfangreicher Konnektivität ausgeführt. Die größten Einschränkungen sind dabei oft die Anzahl der CAN-FD-Kanäle, das Gewicht und Volumen sowie der Anschaffungspreis.
Die hier gelisteten Geräte entsprechen am ehesten den Anforderungen dieses Projekts und dienen als technische Referenz:

Die öffentlich einsehbaren Eigenschaften der angebotenen Produkte werden nach folgendem Schema gewertet. Die Eigenschaften sind in allen Tabellen den jeweiligen technischen Anforderungen T1 bis T9 zugeordnet. Auf eine Gewichtung der Kriterien wird aus Gründen der Einfachheit verzichtet.

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
    table.header([Technische\ Anforderung],[Eigenschaft],[Bewertung]),
    [#link(<t1>)[T1]],[Datenübertragung über LTE statt über USB],[-1],
    [#link(<t1>)[T1]],[Verschlüsselte Datenübertragung],[-1],
    [#link(<t1>)[T1]],[Browserbasierte Bedienoberfläche],[0],
    [#link(<t4>)[T4]],[Fest integrierter eMMC-Speicher mit 32 GB],[0],
    [#link(<t7>)[T7]],[Preis von etwa 1.215 USD],[1],
    [#link(<t8>)[T8]],[Masse von 112 g],[1],
    [#link(<t8>)[T8]],[Volumen von 195 cm³],[1],
    [#link(<t9>)[T9]],[Open-Source-API],[1],
    [#link(<t9>)[T9]],[Integrierte inertiale Messeinheit],[0],
    [#link(<t5>)[T5]],[Vier unabhängige CAN-Kanäle],[1],
    [#link(<t9>)[T9]],[Zwei digitale und zwei analoge Messeingänge],[0],
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
    table.header([Technische\ Anforderung],[Eigenschaft],[Bewertung]),
    [#link(<t1>)[T1]],[Zentraler D-Sub-Steckverbinder für alle Signale],[1],
    [#link(<t1>)[T1]],[Unterstützung von SocketCAN (Linux Kernel- Treiber)],[1],
    [#link(<t3>)[T3]],[Umfangreiche Filterfunktionen],[1],
    [#link(<t4>)[T4]],[SD-Karte mit wählbarer Speicherkapazität],[1],
    [#link(<t7>)[T7]],[Preis von etwa 3.362 USD],[-1],
    [#link(<t8>)[T8]],[Masse von 159 g],[0],
    [#link(<t8>)[T8]],[Volumen von 242 cm³],[1],
    [#link(<t5>)[T5]],[Fünf CAN-FD-Kanäle],[1],

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
    table.header([Technische\ Anforderung],[Eigenschaft],[Bewertung]),
    [#link(<t1>)[T1]],[Auswertung mit CANalyzer oder CANoe],[1],
    [#link(<t1>)[T1]],[Drahtlose Datenübertragung über 3G],[0],
    [#link(<t4>)[T4]],[Speicherung auf SSD oder SD-Karte],[1],
    [#link(<t7>)[T7]],[Preis nicht öffentlich angegeben],[-1],
    [#link(<t8>)[T8]],[Masse von etwa 580 g],[-1],
    [#link(<t8>)[T8]],[Volumen von 839 cm³],[-1],
    [#link(<t5>)[T5]],[Vier CAN-Kanäle],[1],
    [#link(<t9>)[T9]],[Unterstützung von Ethernet, FlexRay und LIN],[0],

    [],[*Summe*],[*0*]
),
caption: [Evaluation des Vector GL2400 @vectorgl]
  )
]

*Fazit*

Der Kvaser Memorator Pro 5xHS überzeugt durch sein geringes Gewicht und einfacher Anbindung von 5 CAN- FD Kanälen, weshalb sein Design im Folgenden Analysiert und als technische Referenz genutzt wird.

#pagebreak()

== Referenzdesign-Analyse

Auf Produktbildern des Memorator Pro 5- PCBs ist erkennbar, dass dieser zum erreichen von #link(<t4>)[T4] einen 3.7V 500mAh Li-ion Batterie verwendet. Als User-interface wird eine Micro-USB Buchse eingesetzt (#link(<t1>)[T1]).

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
