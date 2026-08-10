#import "header.typ":*
#import "02-header.typ":*

= Systemarchitektur <system-architecture>

== Grundarchitektur

Der Datenlogger wird als modularer Datenpfad aus CAN-FD-Controllern, Mikrocontroller mit USB- Schnittstelle und microSD-Karte aufgebaut. Jede Komponente übernimmt dabei eine klar abgegrenzte Aufgabe. Das reduziert den Entwicklungsaufwand (#link(<t6>)[T6]), erleichtert die prüfgerechte Fertigung (#link(<t7>)[T7]) und erlaubt spätere Erweiterungen ohne grundlegende Neukonstruktion (#link(<t9>)[T9]). 

=== Mikrocontroller

Der Mikrocontroller koordiniert die Peripherie, verarbeitet empfangene Nachrichten und steuert die Datenspeicherung. Gegenüber einer FPGA-Lösung bietet er eine besser zugängliche Entwicklungsumgebung, Debug-Möglichkeiten und verfügbare Softwarebibliotheken.(#link(<t6>)[T6]). Ausreichende Rechenleistung, RAM und flexible Schnittstellen sind erforderlich, um den Datenstrom mit deterministischen Latenzen zu verarbeiten (#link(<t3>)[T3]) und mehrere externe Controller sowie das Speichermedium anzubinden (#link(<t5>)[T5]).

=== Externe CAN-FD-Controller

Der Bedarf von mindestens vier unabhängigen CAN-FD-Bussen (#link(<t5>)[T5]) kann nicht von einem einzelnen, üblichen Mikrocontroller mit integrierten CAN-FD-Controllern erfüllt werden. Im niedrigen Preissegment bietet aktuell jediglich der STM32G474 drei CAN-FD-Controller. @stm32g4 Aus diesem Grund wird jeder Bus über einen spezialisierten externen CAN-FD-Controller angebunden. Dessen Filter und Empfangspuffer sollen den Mikrocontroller entlasten und unterstützen eine verlustfreie Echtzeiterfassung (#link(<t3>)[T3]). Die Anzahl der Kanäle kann durch zusätzliche gleichartige Controller erweitert werden (#link(<t9>)[T9]).

=== microSD-Karte

Die Messdaten werden auf einer entnehmbaren microSD-Karte in einem FAT32-Dateisystem gespeichert. Das Standardmedium kann ohne Spezialhardware am PC gelesen werden und unterstützt damit die standardisierte Datenauslese (#link(<t1>)[T1]). Durch Verwendung einer CSV- Tabelle als Logformat soll die Auswertung möglichst einfach gestalten (#link(<t2>)[T2]). Das integrierte Flash-Management der Karte sowie ein RAM-Zwischenspeicher entkoppeln Datenerfassung und Schreibvorgang und tragen zur ausfallsicheren Speicherung bei (#link(<t4>)[T4]).

=== USB-Schnittstelle und Platine

USB dient als Standardschnittstelle für Programmierung, Debugging und die direkte Datenauslese (#link(<t1>)[T1], #link(<t6>)[T6]). Die Leiterplatte trennt Mikrocontroller, CAN-FD-Anbindung, Speicher und Spannungsversorgung in klar prüfbare Funktionsbereiche (#link(<t7>)[T7], #link(<t9>)[T9]). Gut lötbare Gehäuse, Testpunkte und ein für die Fertigung geeignetes Layout vereinfachen Inbetriebnahme und Qualitätssicherung (#link(<t6>)[T6], #link(<t7>)[T7]); eine kompakte Platzierung reduziert zugleich Masse und Volumen (#link(<t8>)[T8]).

=== Sender

Um den Prototypen sinnvoll testen zu können, wird das USB- zu CAN-FD Interface Candlelight FD des Herstellers Linux Automation GmbH verwendet. Dieses basiert seinerseits auf einem STM32G0 und bietet die einfachste Möglichkeit, Nachrichten mit inkrementell angepasstem Inhalt zu versenden, um schlussendlich die Vollständigkeit des Datensatzes zu überprüfen.


== Auswahl und Bewertung von Komponenten

Um fundierte Entscheidungen treffen zu können, werden im Folgenden die aktuellen in der Industrie üblichen Technologien anhand von harten Ausschlusskriterien vorausgewählt, und mit einer dreistufigen Bewertung versehen. Anschließend wird diese je nach Relevanz für diesen konkreten Anwendungsfall mit einem Multiplikator gewichtet.



#figure(
  table(
    columns: (auto, auto),
    align: (left + horizon),
    inset: STD_INSET,
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
    inset: STD_INSET,
 table.header([*Multiplikator*], [*Bewertungsrelevanz*]),
[1], [Grundlegende Relevanz für die Systemauswahl],
[2], [Hoher Einfluss auf die Eignung im Anwendungsfall],
[3], [Entscheidender Einfluss auf die technische Umsetzbarkeit]
  ),
  caption: [Gewichtungsskala]
)

== Auswahl des Mikrocontrollers <microcontroller-selection>

Entscheidend für die Auswahl sind neben Rechenleistung und RAM für die Echtzeitverarbeitung (#link(<t3>)[T3]) vor allem mehrere flexible Schnittstellen für CAN-FD-Controller und Speichermedium (#link(<t5>)[T5]). Hohe Priorität haben außerdem eine gut dokumentierte Software-Infrastruktur und einfache Debug-Möglichkeiten (#link(<t6>)[T6]), ein fertigungsgerechtes Gehäuse (#link(<t7>)[T7]) sowie Reserven für spätere Erweiterungen (#link(<t9>)[T9]).
In der folgenden Tabelle wird eine Auswahl der  aktuellsten Modelle der gängigsten Hersteller gelistet.


                
#block(breakable: false)[

  #figure(
    table(
      columns: (auto, auto, auto, auto), align: (left + horizon), inset: STD_INSET,

      table.header([Mikrocontroller],
      [*AVR64DU* @avr64du #figure(image("pictures/avr64du32.png"))],
      [*STM32-C5* @stm32c5 #figure(image("pictures/stm32c5.webp"))],
      [*RP2350* @rp2350 #figure(image("pictures/rp2350.png"))],
      ),

      [Hersteller],[Microchip],[STMicroelectronics],[Raspberry Pi],
      [Veröffentlichung],[2026],[2026],[2024],
      [Architektur],[8-Bit AVR-Mega],[32-Bit Cortex-M33],[2x 32-Bit Cortex-M33 / 2x 32-Bit RISC-V],
      [Anzahl Prozessoren],[1],[1],[2],
      [RAM-Größe],[8 KB],[bis 256 KB],[520 KB],
      [Schnittstellen],[1x SPI, 1x I²C, 2x USART, USB FS],[USB, OctoSPI, CAN-FD],[2x SPI, 2x I²C, USB, 12x PIO-SM],
      [Pin-Multiplexer],[Eingeschränkt],[Eingeschränkt],[sehr flexibel über GPIO-Funktionen],
      [Anzahl CAN-FD-Controller],[0],[2],[0],
      [Treiber/ Software workflow],[Melody],[STM- HAL, CubeMX-2],[Pico C/ C++ SDK]),
    
      caption: [Gängige aktuelle Mikrocontroller],
  )
]


*Entscheidungsmatrix Mikrocontroller*

  #figure(
    table(
      columns: (auto, auto, auto, auto, auto, auto),
      align: (left + horizon),
      inset: STD_INSET,
      table.header(
        [T-Nr.],
        [Eigenschaft],
        [Gewichtung],
        [*AVR64DU* @avr64du],
        [*STM32C5* @stm32c5],
        [*RP2350* @rp2350],
      ),

      [#link(<t9>)[T9]],
      [Modernität],
      [#mcu_multi.modern],
      [#avr64du_scores.modern],
      [#stm32c5_scores.modern],
      [#rp2350_scores.modern],

      [#link(<t3>)[T3]],
      [Single core- Performance],
      [#mcu_multi.core_perf],
      [#avr64du_scores.core_perf],
      [#stm32c5_scores.core_perf],
      [#rp2350_scores.core_perf],

      [#link(<t3>)[T3]],
      [Multi- Core- Architektur],
      [#mcu_multi.multicore],
      [#avr64du_scores.multicore],
      [#stm32c5_scores.multicore],
      [#rp2350_scores.multicore],

      [#link(<t3>)[T3]],
      [RAM-Größe],
      [#mcu_multi.ramsize],
      [#avr64du_scores.ramsize],
      [#stm32c5_scores.ramsize],
      [#rp2350_scores.ramsize],


      [#link(<t5>)[T5]],
      [Flexibilität Schnittstellen],
      [#mcu_multi.interface],
      [#avr64du_scores.interface],
      [#stm32c5_scores.interface],
      [#rp2350_scores.interface],

      [#link(<t7>)[T7]],
      [Flexibilität Signal- Routing],
      [#mcu_multi.signalrout],
      [#avr64du_scores.signalrout],
      [#stm32c5_scores.signalrout],
      [#rp2350_scores.signalrout],

      [#link(<t5>)[T5]],
      [CAN-FD-Integration],
      [#mcu_multi.canfdinteg],
      [#avr64du_scores.canfdinteg],
      [#stm32c5_scores.canfdinteg],
      [#rp2350_scores.canfdinteg],

      [#link(<t6>)[T6]],
      [Qualität Software- Support],
      [#mcu_multi.software],
      [#avr64du_scores.software],
      [#stm32c5_scores.software],
      [#rp2350_scores.software],


      [],
      [Gewichtete Summe],
      [],
      [#mcu_score(avr64du_scores)],
      [#mcu_score(stm32c5_scores)],
      [#mcu_score(rp2350_scores)],
    ),
    caption: [Entscheidungsmatrix Mikrocontroller],
  )
*Fazit*

Der RP2350 eignet sich vorallem durch seie flexiblen Pin-Multiplexer, die freie Gestaltung von seriellen Schnittstellen mithilfe von Programmable- Input- Output  State Machines (PIO-SM), großem SRAM und Dual-Core RISC-V Prozessoren, sowie aufgrund seiner übersichtlichen, gut dokumentierten C/C++ Entwicklungsumgebung. Für die Prototypenentwicklung steht die Entwicklungsplatine Raspberry Pico 2 zur Verfügung.

#align(center)[
  #figure(
    image("pictures/pico2.jpg", width: 50%),
    caption: [Raspberry Pico 2 Entwicklungsplatine @pico2],
  )
]

#block(breakable: false)[
== Auswahl eines CAN- FD Controller-Transcievers <can-fd-controller-selection>
Für die Anbindung der externen CAN-FD-Busse werden Controller. Besonders relevant sind ein integrierter Transceiver, die maximale Datenrate, die Filtermöglichkeiten und die Größe des internen Nachrichtenspeichers.


  #figure(
    table(
      columns: (auto, 1fr, 1fr, 1fr),
      align: (left + horizon),
      inset: STD_INSET,
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
      [8 Mbit/s],
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

*Entscheidungsmatrix CAN-FD- Controller*

#figure(
  table(
    columns: (auto,auto,auto,auto,auto,auto),
    align: (left+horizon),
    inset: STD_INSET,
    table.header([T-Nr.], [Eigenschaft], [Multiplikator],[*TCAN4550-Q1* @tcan4550q1], [*MCP251863* @mcp251863], [*MCP2518FD* @mcp2518fd],),
    [#link(<t9>)[T9]],[Modernität],[#can_multi.modern],[#tcan4550_scores.modern],[#mcp251863_scores.modern],[#mcp2518fd_scores.modern],
    [#link(<t7>)[T7]],[Simple externe Beschaltung],[#can_multi.external_circuit],[#tcan4550_scores.external_circuit],[#mcp251863_scores.external_circuit],[#mcp2518fd_scores.external_circuit],
    [#link(<t3>)[T3]],[Hohe CAN- Datenrate],[#can_multi.can_rate],[#tcan4550_scores.can_rate],[#mcp251863_scores.can_rate],[#mcp2518fd_scores.can_rate],
    [#link(<t3>)[T3]],[Hohe SPI- Datenrate],[#can_multi.spi_rate],[#tcan4550_scores.spi_rate],[#mcp251863_scores.spi_rate],[#mcp2518fd_scores.spi_rate],
    [#link(<t3>)[T3]],[Großer Datenspeicher],[#can_multi.memory],[#tcan4550_scores.memory],[#mcp251863_scores.memory],[#mcp2518fd_scores.memory],
    [#link(<t3>)[T3]],[Effektivität der Filterung],[#can_multi.filtering],[#tcan4550_scores.filtering],[#mcp251863_scores.filtering],[#mcp2518fd_scores.filtering],
    [#link(<t6>)[T6]],[Simplizität des Interfaces],[#can_multi.interface],[#tcan4550_scores.interface],[#mcp251863_scores.interface],[#mcp2518fd_scores.interface],
    [#link(<t7>)[T7]],[Geringe Kosten],[#can_multi.cost],[#tcan4550_scores.cost],[#mcp251863_scores.cost],[#mcp2518fd_scores.cost],
    [],[*Gewichtete Summe*],[],[*#can_score(tcan4550_scores)*],[*#can_score(mcp251863_scores)*],[*#can_score(mcp2518fd_scores)*],
  ),
  caption: [Entscheidungsmatrix CAN-FD-Controller],
)

Der MCP251863 bietet eine Lösung, welche die gesamte CAN-FD Funktionalität inklusive RAM, CAN-Controller sowie Bus-Transciever auf einem Chip vereint. Seine übersichtliche Registerstruktur, schnelles SPI- Interface und flexible Filterobjekte machen ihn besonders geeignet. Der CAN-Controller des MCP251863 ist mit dem des MCP2518-FD identisch, der einzige Unterschied besteht darin, dass der MCP2518-FD keinen internen CAN- Transciever besitzt.
Für die Entwicklung eines Prototypen wird aufgrund einfacher Verfügbarkeit ein fertiges Modul verwendet, welches einen MCP2518-FD und einen ATA6563-Transciever kombiniert. Dies ist Softwaretechnisch vollständig äquivalent.

#align(center)[
  #figure(
    image("pictures/mcp2518fd-module.jpg", width: 40%),
    caption: [MCP-2518-FD Modul.@mcp2518fd-module],
  )
]


== Auswahl eines Speichermediums <storage-selection>

Für die dauerhafte Speicherung der Messdaten werden die in der Industrie gängigen Lösungen SPI-NAND-Flash, eMMC und microSD betrachtet. Entscheidend sind dabei nutzbare Speicherkapazität, Schreibgeschwindigkeit, Schnittstellenaufwand, integriertes Flash-Management, mechanische Integration und die einfache Auslesbarkeit am PC.

#block(breakable: false)[
  #figure(
    table(
      columns: (auto, 1fr, 1fr, 1fr),
      align: (left + horizon),
      inset: STD_INSET,
      table.header(
        [Speichermedium],
        [*ISSI NAND-Flash* @ISSI-nand-datasheet],
        [*Swissbit eMMC* @swissbit-emmc-datasheet],
        [*SanDisk MicroSDHC* @sandisk-sdhc-datasheet],
      ),

      [Kapazität],
      [8 Gb],
      [512 GB],
      [32 GB],

      [Schreibgeschwindigkeit],
      [27 MB/s],
      [150 MB/s],
      [40 MB/s],

      [Schnittstelle],
      [NAND-Interface],
      [eMMC Communication Interface],
      [SPI],

      [Flash-Controller],
      [nein, Host verwaltet Wear-Leveling],
      [ja, Wear-Leveling integriert],
      [ja, Wear-Leveling integriert],

      [Auslesbarkeit am PC],
      [nur über eigene Firmware],
      [nur über Testhardware],
      [direkt über Kartenleser],

      [Gehäuse / Integration],
      [48-pin TSOP oder 63-ball VFBGA],
      [153-ball BGA],
      [Sockel oder Push-Push-Halter],

      [Preis],
      [36,77 € @ISSI-nand-shop],
      [119,33 € @swissbit-emmc-shop],
      [24,53€ @sandisk-sdhc-shop],

    ),
    caption: [Vergleich verfügbarer Speichermedien],
  )
]

*Entscheidungsmatrix Speichermedium*

#figure(
  table(
    columns: (auto, auto, auto, auto, auto, auto),
    align: (left + horizon),
    inset: STD_INSET,
    table.header([T-Nr.], [Eigenschaft], [Multiplikator], [*SPI-NAND-Flash*], [*eMMC*], [*microSD*]),
    [#link(<t4>)[T4]], [Nutzbare Speicher- \kapazität], [#storage_multi.capacity], [#spinand_scores.capacity], [#emmc_scores.capacity], [#microsd_scores.capacity],
    [#link(<t3>)[T3]], [Schreib-\geschwindigkeit], [#storage_multi.write_speed], [#spinand_scores.write_speed], [#emmc_scores.write_speed], [#microsd_scores.write_speed],
    [#link(<t6>)[T6]], [Schnittstellen Komplexität], [#storage_multi.interface], [#spinand_scores.interface], [#emmc_scores.interface], [#microsd_scores.interface],
    [#link(<t4>)[T4]], [Integriertes Flash-Management], [#storage_multi.flash_management], [#spinand_scores.flash_management], [#emmc_scores.flash_management], [#microsd_scores.flash_management],
    [#link(<t1>)[T1]], [Auslesbarkeit am PC], [#storage_multi.pc_readability], [#spinand_scores.pc_readability], [#emmc_scores.pc_readability], [#microsd_scores.pc_readability],
    [#link(<t7>)[T7]], [Mechanische Integration], [#storage_multi.integration], [#spinand_scores.integration], [#emmc_scores.integration], [#microsd_scores.integration],
    [#link(<t7>)[T7]], [Geringe Kosten], [#storage_multi.cost], [#spinand_scores.cost], [#emmc_scores.cost], [#microsd_scores.cost],
    [], [*Gewichtete Summe*], [], [*#storage_score(spinand_scores)*], [*#storage_score(emmc_scores)*], [*#storage_score(microsd_scores)*],
  ),
  caption: [Entscheidungsmatrix Speichermedium],
)

Die SanDisk High Endurance 32GB MicroSDHC Memory Card eignet sich aufgrund ihrer einfachen Integration sowie bester Speicher- Kapazität und Geschwindigkeit im Verhältnis zum Preis.

== Blockdiagramm <block-diagram>

#align(center)[
  #figure(
    image("pictures/full-system-diagram.svg", width: 80%),
    caption: [Blockdiagramm des vollständigen Datenloggers.],
  )
]
 <prototype-block-diagram>
#align(center)[
  #figure(
    image("pictures/prototype-diagram.svg", width: 80%),
    caption: [Blockdiagramm des Protoypen],
  )
]
