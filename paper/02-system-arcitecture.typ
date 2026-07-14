#import "header.typ":*
#import "02-header.typ":*

= Systemarchitektur <system-architecture>

== Grundarchitektur

Der Datenlogger wird als modularer Datenpfad aus Mikrocontroller, externen CAN-FD-Controllern, microSD-Karte und USB-Schnittstelle aufgebaut. Jede Komponente übernimmt dabei eine klar abgegrenzte Aufgabe. Das reduziert den Entwicklungsaufwand (#link(<t6>)[T6]), erleichtert die prüfgerechte Fertigung (#link(<t7>)[T7]) und erlaubt spätere Erweiterungen ohne grundlegende Neukonstruktion (#link(<t9>)[T9]).

=== Mikrocontroller

Der Mikrocontroller koordiniert die Peripherie, verarbeitet empfangene Nachrichten und steuert die Datenspeicherung. Gegenüber einer FPGA-Lösung bietet er eine besser zugängliche Entwicklungsumgebung, Debug-Möglichkeiten und verfügbare Softwarebibliotheken; damit unterstützt er die schnelle Entwicklung unmittelbar (#link(<t6>)[T6]). Ausreichende Rechenleistung, RAM und flexible Schnittstellen sind erforderlich, um den Datenstrom mit deterministischen Latenzen zu verarbeiten (#link(<t3>)[T3]) und mehrere externe Controller sowie das Speichermedium anzubinden (#link(<t5>)[T5]).

=== Externe CAN-FD-Controller

Die Forderung nach mindestens vier unabhängigen CAN-FD-Bussen (#link(<t5>)[T5]) wird nicht von einem einzelnen, üblichen Mikrocontroller mit integrierten CAN-FD-Controllern erfüllt. Der Mikrocontroller mit den meisten integrierten CAN-FD-Controllern ist der STM32G474, welcher drei Controller bietet. @stm32g4 Aus diesem Grund wird jeder Bus über einen spezialisierten externen CAN-FD-Controller angebunden. Dessen Filter und Empfangspuffer entlasten den Mikrocontroller und unterstützen eine verlustfreie Echtzeiterfassung (#link(<t3>)[T3]). Die Anzahl der Kanäle kann durch zusätzliche gleichartige Controller erweitert werden (#link(<t9>)[T9]).

=== microSD-Karte

Die Messdaten werden auf einer entnehmbaren microSD-Karte in einem FAT32-Dateisystem gespeichert. Das Standardmedium kann ohne Spezialhardware am PC gelesen werden und unterstützt damit die standardisierte Datenauslese (#link(<t1>)[T1]); ein offen dokumentiertes Logformat erfüllt zusätzlich die Anforderungen an das Datenformat (#link(<t2>)[T2]). Das integrierte Flash-Management der Karte sowie ein RAM-Zwischenspeicher entkoppeln Datenerfassung und Schreibvorgang und tragen zur ausfallsicheren Speicherung bei (#link(<t4>)[T4]).

=== USB-Schnittstelle und Platine

USB dient als Standardschnittstelle für Programmierung, Debugging und die direkte Datenauslese (#link(<t1>)[T1], #link(<t6>)[T6]). Die Leiterplatte trennt Mikrocontroller, CAN-FD-Anbindung, Speicher und Spannungsversorgung in klar prüfbare Funktionsbereiche (#link(<t7>)[T7], #link(<t9>)[T9]). Gut lötbare Gehäuse, Testpunkte und ein für die Fertigung geeignetes Layout vereinfachen Inbetriebnahme und Qualitätssicherung (#link(<t6>)[T6], #link(<t7>)[T7]); eine kompakte Platzierung reduziert zugleich Masse und Volumen (#link(<t8>)[T8]).

Die nachfolgenden Komponentenauswahlen vergleichen zunächst harte Ausschlusskriterien und bewerten die verbleibenden Optionen anschließend anhand der technischen Anforderungen.

== Auswahl des Mikrocontrollers <microcontroller-selection>

Entscheidend für die Auswahl sind neben Rechenleistung und RAM für die Echtzeitverarbeitung (#link(<t3>)[T3]) vor allem mehrere flexible Schnittstellen für CAN-FD-Controller und Speichermedium (#link(<t5>)[T5]). Hohe Priorität haben außerdem eine gut dokumentierte Software-Infrastruktur und einfache Debug-Möglichkeiten (#link(<t6>)[T6]), ein fertigungsgerechtes Gehäuse (#link(<t7>)[T7]) sowie Reserven für spätere Erweiterungen (#link(<t9>)[T9]).

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
      columns: (auto, auto, auto, auto, auto, auto),
      align: (left + horizon),
      inset: 8pt,
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


#block(breakable: false)[
== Auswahl eines CAN- FD Controller-Transcievers <can-fd-controller-selection>
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

#figure(
  table(
    columns: (auto,auto,auto,auto,auto,auto),
    align: (left+horizon),
    inset: 1mm,
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

== Auswahl eines Speichermediums <storage-selection>

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

#figure(
  table(
    columns: (auto, auto, auto, auto, auto, auto),
    align: (left + horizon),
    inset: 1mm,
    table.header([T-Nr.], [Eigenschaft], [Multiplikator], [*SPI-NAND-Flash* @w25n01gv], [*eMMC* @kingstonemmc], [*microSD* @kingstonmicrosd]),
    [#link(<t4>)[T4]], [Nutzbare Speicherkapazität], [#storage_multi.capacity], [#spinand_scores.capacity], [#emmc_scores.capacity], [#microsd_scores.capacity],
    [#link(<t3>)[T3]], [Schreibgeschwindigkeit], [#storage_multi.write_speed], [#spinand_scores.write_speed], [#emmc_scores.write_speed], [#microsd_scores.write_speed],
    [#link(<t6>)[T6]], [Schnittstellenaufwand], [#storage_multi.interface], [#spinand_scores.interface], [#emmc_scores.interface], [#microsd_scores.interface],
    [#link(<t4>)[T4]], [Integriertes Flash-Management], [#storage_multi.flash_management], [#spinand_scores.flash_management], [#emmc_scores.flash_management], [#microsd_scores.flash_management],
    [#link(<t1>)[T1]], [Auslesbarkeit am PC], [#storage_multi.pc_readability], [#spinand_scores.pc_readability], [#emmc_scores.pc_readability], [#microsd_scores.pc_readability],
    [#link(<t7>)[T7]], [Mechanische Integration], [#storage_multi.integration], [#spinand_scores.integration], [#emmc_scores.integration], [#microsd_scores.integration],
    [#link(<t9>)[T9]], [Verfügbarkeit], [#storage_multi.availability], [#spinand_scores.availability], [#emmc_scores.availability], [#microsd_scores.availability],
    [#link(<t7>)[T7]], [Geringe Kosten], [#storage_multi.cost], [#spinand_scores.cost], [#emmc_scores.cost], [#microsd_scores.cost],
    [], [*Gewichtete Summe*], [], [*#storage_score(spinand_scores)*], [*#storage_score(emmc_scores)*], [*#storage_score(microsd_scores)*],
  ),
  caption: [Entscheidungsmatrix Speichermedium],
)

Die microSD-Karte erzielt die höchste gewichtete Bewertung. Sie verbindet eine direkte PC-Auslesbarkeit mit integriertem Flash-Management, geringem Integrationsaufwand und ausreichender Schreibgeschwindigkeit und wird daher als Speichermedium eingesetzt.


== Blockdiagramm <block-diagram>

#align(center)[
  #figure(
    image("pictures/full-system-diagram.svg", width: 80%),
    caption: [Vollständiger Datenlogger.],
  )
]

== Blockdiagramm des Prototypen <prototype-block-diagram>
#align(center)[
  #figure(
    image("pictures/prototype-diagram.svg", width: 80%),
    caption: [Zeitplanung],
  )
]
=== Vorteile <advantages>
- Reduzierung der Masse um bis zu 3/4.
- Effektive Filterung der Frames nach Can-ID.
- Erprobung des RP2350, sehr flexible und leistungsstarke Plattform welche es in Zukunft ermöglichen könnte, Fahrzeuglogik und -Funktionalität noch stärker in wenige Steuergeräte zu integrieren. 
- Sehr cleane low level HAL für C/C++
=== Herausforderungen <challenges>
- Es ist unklar, ob die MCP's genau so gut sind wie die internen Controller eines STM32, und ob sie unter Last zuverlässig sind. Muss getestet werden. 
- Der Buffer ist begrenzt. Der Mcu hat 520kb RAM. Opfert man 300kb als Buffer, kann man bei hängender SD und 12Mbits auf 3 Can's für `300*10^3 byte ram /(1/8 bytes pro bit * 10^6 * 12 Mbits * 3 Can busse) = 66ms `noch aufzeichnen. Zur Not ist es aber möglich, den Mcu mit externem RAM zu erweitern.
== Zustandsautomat <state-machine>
So sieht die einbindung von C- Code aus:
#code-snippet("../main.c","main")
