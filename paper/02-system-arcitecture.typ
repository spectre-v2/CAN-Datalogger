#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "header.typ":*


= Systemarchitektur
== Auswahl eines Mikrocontrollers
Der Mikrocontroller stellt den Zentralen Baustein dar. 

- Software- Infrastruktur
- Größe des SRAM
- Geschwindigkeit
- Periphrerie
- Flexibles Signal-Routing


== Auswahl eines CAN- FD Controller-Transcievers

== Auswahl eines Speichermediums

== Blockdiagramm des vollständigen Systems


Dieser Datenlogger besteht aus einem RP2350 und drei Microchip MCP251863 Controller-Transceivern für die CAN-Busse Accu-FD, Main-FD und DV-Can, sowie einer micro SD- Karte.
Die MCP's bieten die Möglichkeit, Frames relativ einfach mit ID- Masken zu filtern. Sie kommunizieren über SPI mit dem Mcu. 
Core 0 des Mcu ist für Echtzeit- Handling der eingehenden Frames zuständig und schreibt diese in den RAM- Buffer.
Core 1 übernimmt ausschließlich das Formatieren und schreiben in das FAT32 Dateisystem der SD, da dies rechenintensiv ist und größere Latenzen haben kann.


//Blockdiagramm fürs entgültige Systemlayout
#align(center)[
  #diagram(
   
    debug: 1, 
    edge-stroke: 0.3mm,
    edge-corner-radius: 2mm,
    spacing: 2em,
    node-fill: light_grey,
    node-stroke: 0.3mm,
    node-corner-radius: 2mm,
    node-inset: 6mm,

    node((1, 0), [MCP251863], name: <mcp1>),
    node((2, 0), [MCP251863], name: <mcp2>),
    node((3, 0), [MCP251863], name: <mcp3>),

    node((1, 2), [PIO SM 0], name: <pio0>),
    node((2, 2), [PIO SM 1], name: <pio1>),
    node((3, 2), [PIO SM 2], name: <pio2>),
    node((2, 3), [DMA], name: <dma>),
    node((1, 4), [Core 0], name: <core0>),
    node((3, 4), [Core 1], name: <core1>),
    node((2, 5), [PIO SM 3], name: <pio3>),
    node(
      (0, 3),
      [],
      name: <mcu-title-anchor>,
      inset: 0pt,
      fill: none,
      stroke: none,
    ),

    node(
      align(left + horizon)[
        #rotate(-90deg, reflow: true)[RP2350-Mikrocontroller]
      ],
      name: <mcu>,
      enclose: (<mcu-title-anchor>, <pio0>, <pio1>, <pio2>, <dma>, <core0>, <core1>, <pio3>),
      inset: 4mm,
      shape: "rect",
      corner-radius: 3mm,
    ),

    node((2, 7), [SD-Karte], name: <sd>),

    edge(<mcp1>, <pio0>, "-|>"),
    edge(<mcp2>, <pio1>, "-|>"),
    edge(<mcp3>, <pio2>, "-|>"),

    edge(<pio0>, (1, 3), <dma>, "<|-|>"),
    edge(<pio1>, <dma>, "<|-|>"),
    edge(<pio2>, (3, 3), <dma>, "<|-|>"),
    edge(<dma> , (2, 4), <core0>, "<|-|>"),
    edge(<dma>, (3, 3), <core1>, "<|-|>"),
    edge(<dma>, <pio3>, "<|-|>"),
    edge(<pio3>, <sd>, "-|>"),

    edge(
      <mcp1>, (0.5, 0), (0.6, 4), <core0>, "--|>",
      label: [IRQ],
      label-pos: (1, 25%),
      crossing: true,
    ),
    edge(
      <mcp2>, (2, 1), (0.5, 1), (0.5, 4), <core0>, "--|>",
      label: [IRQ],
      label-pos: (1, 10%),
      crossing: true,
    ),
    edge(
      <mcp3>, (3, 1.5), (0.5, 1.5), (0.5, 4), <core0>, "--|>",
      label: [IRQ],
      label-pos: (1, 50%),
      crossing: true,
    ),

  )
]
== Blockdiagramm des Prototypen

//
#align(center)[
  #diagram(
   
    debug: 0, 
    edge-stroke: 0.3mm,
    edge-corner-radius: 2mm,
    spacing: 2em,
    node-fill: dark_grey,
    node-stroke: 0.3mm,
    node-corner-radius: 2mm,
    node-inset: 6mm,

    node((2, 0), [MCP251863], name: <mcp1>),


    node((2, 2), [SPI 0], name: <spi0>),
    node((2, 3), [DMA], name: <dma>),
    node((1, 4), [Core 0], name: <core0>),
    node((3, 4), [Core 1], name: <core1>),
    node((2, 5), [SPI 1], name: <spi1>),
    node(
      (0, 3),
      [],
      name: <mcu-title-anchor>,
      inset: 0pt,
      fill: none,
      stroke: none,
    ),

    node(
      align(left + horizon)[
        #rotate(-90deg, reflow: true)[RP2350-Mikrocontroller]
      ],
      name: <mcu>,
      enclose: (<mcu-title-anchor>, <spi0>, <dma>, <core0>, <core1>, <spi1>),
      inset: 4mm,
      shape: "rect",
      fill: light_grey,
      corner-radius: 3mm,
    ),

    node((2, 7), [SD-Karte], name: <sd>),

    edge(<mcp1>, <spi0>, "-|>"),


    edge(<spi0>, <dma>, "<|-|>"),
    edge(<dma>, (1, 3), <core0>, "<|-|>"),
    edge(<dma>, (3, 3), <core1>, "<|-|>"),
    edge(<dma>, <spi1>, "<|-|>"),
    edge(<spi1>, <sd>, "-|>"),

    edge(
      <mcp1>, (1.45,0),(1.45,4), (name: <core0>, anchor: "east"), "--|>",
      label: [IRQ],
      label-pos: (1, .1),
      crossing: true,
      snap-to: (<mcp1>, none),
    ),

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
