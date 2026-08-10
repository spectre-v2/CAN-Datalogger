#import "header.typ":*

= Senden von CAN-FD Nachrichten

Der Candlelight FD bietet den Vorteil, dass dieser vom Linux-Kernel mithilfe seines integrierten Treibers Socketcan als natives Netzwerkinterface erkannt wird. 

```bash
anon@archlinux ~ >ip link show

...

5: can0: <NOARP,ECHO> mtu 16 qdisc noop state DOWN mode DEFAULT group default qlen 10
    link/can 
    ```


Anschließend kann über `ip link ` der Modus und Datenraten eingestellt werden: 

```bash
anon@archlinux ~ >sudo ip link set can0 type can bitrate 1000000 dbitrate 2000000 fd on
anon@archlinux ~ >sudo ip link set can0 up
```

Um nun eine Nachricht zu senden, wird das freie Programm `canutils` verwendet, welches den Befehl `cansend` bereitstellt:
```bash
cansend can0 123##1DEADBEEF
```
= Empfangen von CAN-FD-Nachrichten

== Der Treiber des MCP2518FD

Der RP2350 verarbeitet CAN-FD nicht selbst, sondern über den externen Controller MCP2518FD. Der Treiber trennt deshalb die SPI-Übertragung von der weiterverarbeitung von CAN-spezifischen Nutzdaten.


=== Serial Peripheral Interface

Das Serial Peripheral Interface (SPI) ist ein voll- Duplex Master-Slave Datenbus. Das bedeutet, es werden Daten immer gleichzeitig vom Master an den Slave und vom Slave an den Master zurückgesendet. Dazu besitzt er folgende Leitungen:

- *CSn*: Chip-Select
- *SCK*: Serial Clock
- *MISO*: Master In, Slave out
- *MOSI*: Master Out, Slave In

Das schalten der Csn-Leitung auf Masse (Active-Low) signalisiert den Beginn einer Übertragung.

Vor dem ersten Zugriff initialisiert der Mikrocontroller seine interne SPI- Logik und hält Chip Select auf High. 

#code-snippet("../mcu_hardware_config.c", "can0_spi_configuration")


=== Grundlegende Befehle des MCP2518-FD

Jedes Register des MCP2518FD ist 32 Bit breit und besitzt eine 12-Bit-Startadresse. 
Der Chip unterscheidet drei Grundlegende Befehle zum Schreiben oder Lesen von Registern sowie zum zurücksetzen. Diese sind 4 Bit groß. Im folgenden werden sie um vier stellen nach links verschoben, um die spätere Maskierung zu vereinfachen.

#code-snippet("../mcp2518.h", "mcp_commands")

SPI auf dem RP2350 sendet ausschließlich Byte-Arrays. @picosdk-hardware-spi
Aus diesem Grund muss das erste gesendete Byte die ersten vier Bit des Befehls sowie die ersten vier Bits der Registeradresse enthalten. Das zweite Byte überträgt die verbleibenden acht Bits der Adresse. Anschließend werden die eigentlichen Daten gesendet. @mcp2518fd

#code-snippet("../mcp2518.c", "mcp_write")

Auch beim Lesen werden zwei Bytes aus Befehl und Registeradresse gesendet. Anschließend wird `0b00000000` gesendet, damit die funktion `spi_read_blocking` die Clock- Leitung taktet die gleichzeitig empfangenen Daten speichert.

#code-snippet("../mcp2518.c", "mcp_read")

=== Adressraum und Registerstruktur des MCP2518-FD

Der MCP2518 besitzt 34 Steuerregister- Blöcke. Für einen ersten Funktionstest sind jedoch nur folgende relevant:

- C1CON (Controller 1 Control) 
- C1NBTCFG (Controller 1 Nominal Bit Time Configuration)
- C1FIFOCON (Controller 1 First- In- First- Out Control)
- C1INT (Controller 1 Interrupt)
- C1FLTCON (Controller 1 Filter Configuration)
- C1FIFOUA1 (Controller 1 FIFO User Adress 1)

Um Nutzdaten auszulesen wird zusätzlich nur das statische Offset des Message- RAM, welches 0x400 beträgt und im folgenden mit MCP_RAM_BASE bezeichnet wird, benötigt.

Die Register des MCP2518FD werden in der Software als Union abgebildet: `data_array` ist das SPI-Format, `bits` macht die einzelnen Felder im Programm zugänglich und ordnet den Rohdaten eine klare Bedeutung zu. Allerdings ist es wichtig zu beachten, dass diese Datenstruktur sich zunächst nur auf dem Mikrocontroller befindet und nicht den tatsächlichen Zustand des MCP2518 Darstellt. Für eine Tatsächliche Modifikation muss deshalb eine Read- Modify- Write operation durchgeführt werden.

#code-snippet("../mcp2518.h", "mcp_register_union")

=== Konfiguration des Empfangspfads

Um den MCP2518 zu konfigurieren, wird zunächst ein reset- Befehl gesendet, um einen definierten Zustand zu erzeugen. 
#code-snippet("../mcp2518.c","mcp_reset")

Danach werden die Bitzeiten für die nominale CAN-Phase auf 500 kbit/s gesetzt  und für die Datenphase auf 2 Mbit/s. Dies geschieht mithilfe der Datenfelder innerhalb von `C1NBTCFG` und `C1DBTCFG`. `BRP` steht für Bit- Rate- Prescaler und bestimmt zunächst den Prescaler, welcher den Systemtakt, welcher abhängig vom externen Quarzoszillator ist, teilen kann. `TSEG1` und `TSEG2` bestimmen die Anzahl der Takte, welche vom Beginn einer Datenflanke bis zum Abtasten der Leitung gewartet werden sollen, und wie lange nach diesem Zeitpunkt die Datenflanke noch im definierten Zustand bleiben soll, sollte der Controller aktiv senden. `SJW` bestimmt, wie viele Takte der Controller die folgende Flanke vor- oder zurück verschieben darf, um den Bus zu Synchronisieren. Dies ist nötig, da CAN-FD ein selbstsynchronisierender Bus ist. Die gewählten Werte orientieren sich an den Standardeinstellungen des Candlelight FD.

#code-snippet("../mcp2518.c", "mcp_bit_timing")

Wird eine CAN- Nachricht empfangen, wird ihr Identifier zunächst mit einem bestimmten Filter verglichen. Meldet dieser Vergleich einen Treffer, speichert der Chip die CAN-Nachricht in dedizierten Bereich im Message- RAM, ein Pointer- Register gibt die Adresse an. Dieses zeigt zunächst auf die zuerst empfangene Nachricht. Wird diese Nachricht ausgelesen, zeigt der Pointer auf die Nachricht, die unmittelbar danach empfangen wurde. Dieses Prinzip bezeichnet man als First- In- First- Out (FIFO).
Das Fifo- control- register C1FIFOCON1 steuert die Anzahl der Nachrichten in diesem FIFO sowie deren Größe, um somit die Pointer- Logik zu ermöglichen. 
Für diesen Test wird das gesamte Message- Ram genutzt, und wir beschränken uns auf CAN-FD Frames mit ausschließlich voller 64- Byte Nutzlast.  
Zudem wird mithilfe von `TFNRFNIE` und `RXIE` eingestellt, dass der Interupt- Pin am Chip ein Signal ausgeben soll, wenn mindestens eine Nachricht im FIFO vorhanden ist. Dies wird später genutzt, um von Seiten des Mikrocontrollers auf dieses Ereignis zu reagieren.


#code-snippet("../mcp2518.c", "mcp_receive_path_configuration")

Die vorbereiteten Structs werden anschließend mithilfe der bereits vorhandenen SPI- Treiberfunktion `mcp_write` an den MCP2518 gesendet. Danach wird der Chip in den normalen CAN-FD Empfangsmodus versetzt

#code-snippet("../mcp2518.c", "mcp_apply_configuration")

