#import "header.typ":*
#import "02-header.typ":*

= Systemarchitektur

Um eine Faktenbasierte Auswahl von Systemkomponenten treffen zu können, wurde zunächst anhand der harten Ausschlusskriterien recherchiert. Anschließend werden die oberflächlich Passenden Komponenten anhand ihrer detaillierten technischen Eigenschaften, welche unmittelbar aus den Systemanforderungen hergeleitet sind, nach folgendem Schema bewertet:


=== Auswahl des Mikrocontrollers

Der Mikrocontroller bildet die zentrale Logikeinheit des Datenloggers. Er übernimmt die Initialisierung aller Peripheriegeräte, die Verarbeitung der empfangenen Nachrichten und die Speicherung. Damit bestimmt er direkt die Robustheit, Erweiterbarkeit und Entwicklungsgeschwindigkeit des Prototyps.

Aus den Anforderung #link(<a1>)[A1] (Mindestens 3 CAN-FD Schnittstellen),ergibt sich, dass der Mikrocontroller vor allem eine flexible und anpassbare Plattform bereitstellen muss. Die höchste Gewichtung erhält deshalb die Software-Infrastruktur. Eine klar strukturierte Hardware- Abstraktionsschicht, gute Dokumentation, aktive Beispielprojekte und einfache Debug-Möglichkeiten reduzieren den Entwicklungsaufwand massiv.

Aus A7 (Auslesbarkeit und Datenformat) ergibt sich, dass der Mikrocontroller einen Hardware- USB- Device- Controller braucht.

Aus A5 (Datenrate und Pufferverhalten) sowie A4 (Datenintigrität) ergeben sich ausreichender SRAM, um größere datenmengen speichern zu können, hohe Rechenleistung und flexible Schnittstellen entscheidend. Der SRAM wird für Empfangspuffer, Zwischenspeicher und Dateisystemoperationen benötigt. Die Rechenleistung bestimmt, wie stabil der Datenpfad bei hoher Eingangsdatenrate bleibt. Flexible Peripherie, insbesondere mehrere SPI-Schnittstellen oder rekonfigurierbare I/O-Blöcke, erleichtert die Anbindung externer CAN-FD-Controller und der SD-Karte.

Zusätzlich ist eine hohe Flexibilität beim Pin-Routing vorteilhaft. Sie vereinfacht das Leiterplattendesign und reduziert Engstellen beim Layout. Ein nativer USB-Device-Controller ist ebenfalls relevant, da Programmierung und Debugging über USB erfolgen sollen. Für den Prototyp muss der Mikrocontroller außerdem in einem gut lötbaren Gehäuse verfügbar sein. BGA-Gehäuse werden ausgeschlossen, da sie die Fertigung und Fehlersuche unnötig erschweren.

Die Auswahl des Mikrocontrollers erfolgt daher nicht allein über einzelne Maximalwerte. Entscheidend ist die Kombination aus Software-Support, Speichergröße, Rechenleistung, Schnittstellenflexibilität, einfacher Fertigung und klarer Erweiterbarkeit des Gesamtsystems.

Ein integrierter CAN-FD-Controller ist für diese Systemarchitektur nicht zwingend erforderlich. Stattdessen wird ein externer CAN-FD-Controller eingesetzt. Dadurch wird die CAN-FD-Logik vom Mikrocontroller entkoppelt. Diese Architektur ist skalierbarer, da mehrere externe Controller über flexible Schnittstellen angebunden werden können. Gleichzeitig übernehmen die Controller bereits einen Teil der Nachrichtenfilterung und entlasten damit den Mikrocontroller. Der Mikrocontroller muss dadurch nicht jede Nachricht direkt auf Bitebene verarbeiten, sondern liest nur relevante Empfangspuffer aus.


#block(breakable: false)[

  #figure(
    table(
      columns: (auto, auto, auto, auto), align: (left + horizon), inset: 8pt,

      table.header([Mikrocontroller],[*AVR64DU* @avr64du],[*STM32C5* @stm32c5],[*RP2350* @rp2350],),

      [Hersteller],[Microchip],[STMicroelectronics],[Raspberry Pi],
      [Veröffentlichung],[2026],[2026],[2024],
      [Architektur],[8-Bit AVR-Mega],[32-Bit Cortex-M33],[32-Bit Cortex-M33 / RISC-V],
      [Anzahl Prozessoren],[1],[1],[2],
      [RAM-Größe],[8 KB],[bis 256 KB],[520 KB],
      [Schnittstellen],[1x SPI, 1x I²C, 2x USART, USB FS],[USB, OctoSPI, CAN-FD],[2x SPI, 2x I²C, USB, 12x PIO-SM],
      [Pin-Multiplexer],[PORTMUX eingeschränkt],[Alternate-Function-Matrix],[sehr flexibel über GPIO-Funktionen],
      [Anzahl CAN-FD-Controller],[0],[2],[0],
      [Treiber/ Software workflow],[Melody],[STM- HAL, CubeMX-2],[Pico C/ C++ SDK]),

      caption: [Gängige aktuelle Mikrocontroller],
  )
]

Eine engere auswahl der modernsten Mikrocontroller wird im folgenden anhand der aus den Zielen hergeleiteten Kriterien auf einer Skala von 1-3 bewertet.

*Entscheidungsmatrix Mikrocontroller*

Im folgenden werden die ausgewählten Mikrocontroller mit einer dreistufigen Bewertung versehen, anschließend wird diese je nach Relevanz für diesen konkreten Anwendungsfall mit einem Multiplikator Gewichtet.


#figure(
  table(
    columns: (auto, auto),
    align: (left + horizon),
    inset: 8pt,
table.header([*Bewertung*], [*Bedeutung*]),
[-1], [Keine oder ungeeignete Umsetzung des Kriteriums],
[0],  [Ausreichende Erfüllung des Kriteriums],
[1],  [Besonders vorteilhafte Erfüllung des Kriteriums]),
  caption: [Bewertungsskala]
)

#figure(
  table(
    columns: (auto, auto),
    align: (left + horizon),
    inset: 8pt,
 table.header([*Multiplikator*], [*Bewertungsrelevanz*]),
[1], [Grundlegende Relevanz für die Systemauswahl],
[2], [Hoher Einfluss auf die Eignung im Anwendungsfall],
[3], [Entscheidender Einfluss auf die technische Umsetzbarkeit]
  ),
  caption: [Gewichtungsskala]
)

  #figure(
    table(
      columns: (auto, auto, auto, auto, auto),
      align: (left + horizon),
      inset: 8pt,
      table.header(
        [Eigenschaft],
        [Gewichtung],
        [*AVR64DU* @avr64du],
        [*STM32C5* @stm32c5],
        [*RP2350* @rp2350],
      ),

      [Modernität],
      [#mcu_multi.modern],
      [#avr64du_scores.modern],
      [#stm32c5_scores.modern],
      [#rp2350_scores.modern],

      [Single core- Performance],
      [#mcu_multi.core_perf],
      [#avr64du_scores.core_perf],
      [#stm32c5_scores.core_perf],
      [#rp2350_scores.core_perf],

      [Multi- Core- Architektur],
      [#mcu_multi.multicore],
      [#avr64du_scores.multicore],
      [#stm32c5_scores.multicore],
      [#rp2350_scores.multicore],

      [RAM-Größe],
      [#mcu_multi.ramsize],
      [#avr64du_scores.ramsize],
      [#stm32c5_scores.ramsize],
      [#rp2350_scores.ramsize],


      [Flexibilität Schnittstellen],
      [#mcu_multi.interface],
      [#avr64du_scores.interface],
      [#stm32c5_scores.interface],
      [#rp2350_scores.interface],

      [Flexibilität Signal- Routing],
      [#mcu_multi.signalrout],
      [#avr64du_scores.signalrout],
      [#stm32c5_scores.signalrout],
      [#rp2350_scores.signalrout],

      [CAN-FD-Integration],
      [#mcu_multi.canfdinteg],
      [#avr64du_scores.canfdinteg],
      [#stm32c5_scores.canfdinteg],
      [#rp2350_scores.canfdinteg],

      [Qualität Software- Support],
      [#mcu_multi.software],
      [#avr64du_scores.software],
      [#stm32c5_scores.software],
      [#rp2350_scores.software],


      [Gewichtete Summe],
      [],
      [#mcu_score(avr64du_scores)],
      [#mcu_score(stm32c5_scores)],
      [#mcu_score(rp2350_scores)],
    ),
    caption: [Entscheidungsmatrix Mikrocontroller],
  )


#block(breakable: false)[
== Auswahl eines CAN- FD Controller-Transcievers
Für die Anbindung der externen CAN-FD-Busse werden Controller mit SPI-Schnittstelle betrachtet. Besonders relevant sind ein integrierter Transceiver, die maximale Datenrate, die Filtermöglichkeiten und die Größe des internen Nachrichtenspeichers.


  #figure(
    table(
      columns: (auto, 1fr, 1fr, 1fr),
      align: (left + horizon),
      inset: 8pt,
      table.header(
        [Baustein],
        [*TCAN4550-Q1* @tcan4550q1],
        [*MCP251863* @mcp251863],
        [*MCP2518FD* @mcp2518fd],
      ),

      [Hersteller],
      [Texas Instruments],
      [Microchip],
      [Microchip],

      [Transciever integriert],
      [Ja],
      [Ja],
      [Nein],

      [CAN-FD-Datenrate],
      [8 Mbit/s],
      [5 Mbit/s],
      [8 Mbit/s],

      [SPI-Takt],
      [bis 18 MHz],
      [bis 20 MHz],
      [bis 20 MHz],

      [Nachrichtenspeicher],
      [2 KB],
      [2 KB],
      [2 KB],

      [Filter],
      [128 Standard-ID oder 64 Extended-ID Filter],
      [32 flexible Filter-/Masken],
      [32 flexible Filter-/Masken],

      [FIFO-Struktur],
      [konfigurierbare Rx-/Tx-FIFOs und Tx-Queue],
      [31 konfigurierbare FIFOs und Tx-Queue],
      [31 konfigurierbare FIFOs und Tx-Queue],

    ),
    caption: [Verfügbare CAN-FD-Controller-Transceiver],
  )
]

//hier bewertungsmatrix einfügen

//kriterien: modernität, hohe datenrate,interface- geschwindigkeit, simplizität der interface- implementierung, buffer/ speichergröße, Kosten 

#figure(
  table(
    columns: (auto,auto,auto,auto),
    align: (left+horizon),
    inset: 1mm,
    table.header([Controller], [Multiplikator],[*TCAN4550-Q1* @tcan4550q1], [*MCP251863* @mcp251863], [*MCP2518FD* @mcp2518fd],),
    [Modernität],[],[],[],[],
    [Simple externe Beschaltung],[],[],[],[],
    [Hohe CAN- Datenrate],[],[],[],[],
    [Hohe SPI- Datenrate],[],[],[],[],
    [Großer Datenspeicher],[],[],[],[],
    [Effektivität der Filterung],[],[],[],[],
    [Simplizität des Interfaces],[],[],[],[],
    [Geringe Kosten],[],[],[],[],

  )
)

== Auswahl eines Speichermediums

Für die dauerhafte Speicherung der Messdaten werden SPI-NAND-Flash, eMMC und microSD betrachtet. Entscheidend sind dabei nutzbare Speicherkapazität, Schreibgeschwindigkeit, Schnittstellenaufwand, integriertes Flash-Management, mechanische Integration und die einfache Auslesbarkeit am PC.

#block(breakable: false)[
  #figure(
    table(
      columns: (auto, 1fr, 1fr, 1fr),
      align: (left + horizon),
      inset: 8pt,
      table.header(
        [Speichermedium],
        [*SPI-NAND-Flash* @w25n01gv],
        [*eMMC* @kingstonemmc],
        [*microSD* @kingstonmicrosd],
      ),

      [Beispiel],
      [Winbond W25N01GV],
      [Kingston eMMC 5.1],
      [Kingston Industrial microSD],

      [Schnittstelle],
      [SPI / Quad-SPI],
      [eMMC 5.1 HS400],
      [SD / SPI-Modus],

      [Schreibgeschwindigkeit],
      [seitenweise, controllerabhängig],
      [hoch, host- und typabhängig],
      [bis 80 MB/s],

      [Flash-Controller],
      [nein, Host verwaltet Wear-Leveling],
      [ja, ECC und Wear-Leveling integriert],
      [ja, ECC und Wear-Leveling integriert],

      [Auslesbarkeit am PC],
      [nur über eigene Firmware],
      [nur über Adapter/Testhardware],
      [direkt über Kartenleser],

      [Gehäuse / Integration],
      [SOIC/WSON, gut lötbar],
      [BGA, schwer zu löten],
      [Sockel oder Push-Push-Halter],

      [Verfügbarkeit],
      [gut als Bauteil],
      [gut, aber Variantenbindung],
      [sehr gut als Standardmedium],

      [Kosten pro GB],
      [hoch],
      [mittel],
      [niedrig],

      [Bewertung],
      [robust, aber hoher Softwareaufwand],
      [technisch stark, aber aufwendig zu fertigen],
      [einfach auslesbar und prototypenfreundlich],
    ),
    caption: [Vergleich verfügbarer Speichermedien],
  )
]


== Blockdiagramm

Dieser Datenlogger besteht aus einem RP2350 und drei Microchip MCP251863 Controller-Transceivern für die CAN-Busse Accu-FD, Main-FD und DV-Can, sowie einer micro SD- Karte.
Die MCP's bieten die Möglichkeit, Frames relativ einfach mit ID- Masken zu filtern. Sie kommunizieren über SPI mit dem Mcu. 
Core 0 des Mcu ist für Echtzeit- Handling der eingehenden Frames zuständig und schreibt diese in den RAM- Buffer.
Core 1 übernimmt ausschließlich das Formatieren und schreiben in das FAT32 Dateisystem der SD, da dies rechenintensiv ist und größere Latenzen haben kann.
#align(center)[
  #figure(
    image("pictures/full-system-diagram.svg", width: 80%),
    caption: [Vollständiger Datenlogger.],
  )
]

== Blockdiagramm des Prototypen
#align(center)[
  #figure(
    image("pictures/prototype-diagram.svg", width: 80%),
    caption: [Zeitplanung],
  )
]
=== Vorteile
- Reduzierung der Masse um bis zu 3/4.
- Effektive Filterung der Frames nach Can-ID.
- Erprobung des RP2350, sehr flexible und leistungsstarke Plattform welche es in Zukunft ermöglichen könnte, Fahrzeuglogik und -Funktionalität noch stärker in wenige Steuergeräte zu integrieren. 
- Sehr cleane low level HAL für C/C++
=== Herausforderungen
- Es ist unklar, ob die MCP's genau so gut sind wie die internen Controller eines STM32, und ob sie unter Last zuverlässig sind. Muss getestet werden. 
- Der Buffer ist begrenzt. Der Mcu hat 520kb RAM. Opfert man 300kb als Buffer, kann man bei hängender SD und 12Mbits auf 3 Can's für `300*10^3 byte ram /(1/8 bytes pro bit * 10^6 * 12 Mbits * 3 Can busse) = 66ms `noch aufzeichnen. Zur Not ist es aber möglich, den Mcu mit externem RAM zu erweitern.
== Zustandsautomat
So sieht die einbindung von C- Code aus:
#code-snippet("../main.c","main")
