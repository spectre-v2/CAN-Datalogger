#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "header.typ":*


= Systemarchitektur
== Auswahl eines Mikrocontrollers


== Auswahl eines CAN- FD Controller-Transcievers

== Auswahl eines Speichermediums

== Blockschaltplan


Dieser Datenlogger besteht aus einem RP2350 und drei Microchip MCP251863 Controller-Transceivern für Accu-FD, Main-FD und DV-Can, sowie einer micro SD- Karte.
Die MCP's bieten die Möglichkeit, Frames relativ einfach mit ID- Masken zu filtern. Sie kommunizieren über SPI mit dem Mcu. 
Core 0 des Mcu ist für Echtzeit- Handling der eingehenden Frames zuständig und schreibt diese in den RAM- Buffer.
Core 1 übernimmt ausschließlich das Formatieren und schreiben in das FAT32 Dateisystem der SD, da dies rechenintensiv ist und größere Latenzen haben kann.

=== Vorteile
- Reduzierung der Masse um bis zu 3/4.
- Effektive Filterung der Frames nach Can-ID.
- Erprobung des RP2350, sehr flexible und leistungsstarke Plattform welche es in Zukunft ermöglichen könnte, Fahrzeuglogik und -Funktionalität noch stärker in wenige Steuergeräte zu integrieren. 
- Sehr cleane low level HAL für C/C++
=== Herausforderungen
- Es ist unklar, ob die MCP's genau so gut sind wie die internen Controller eines STM32, und ob sie unter Last zuverlässig sind. Muss getestet werden. 
- Der Buffer ist begrenzt. Der Mcu hat 520kb RAM. Opfert man 300kb als Buffer, kann man bei hängender SD und 12Mbits auf 3 Can's für `300*10^3 byte ram /(1/8 bytes pro bit * 10^6 * 12 Mbits * 3 Can busse) = 66ms `noch aufzeichnen. Zur Not ist es aber möglich, den Mcu mit externem RAM zu erweitern.
== Zustandsautomat