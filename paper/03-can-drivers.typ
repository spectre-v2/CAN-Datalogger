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

Der RP2350 verarbeitet CAN-FD nicht selbst, sondern über den externen Controller MCP2518FD. Der Treiber trennt deshalb die SPI-Übertragung von CAN-spezifischen Konfigurationen und Nutzdaten.


=== Serial Peripheral Interface
Das Serial Peripheral Interface (SPI) ist ein voll- Duplex Master-Slave Datenbus. Das bedeutet, es werden Daten immmer gleichzeitig vom Master an den Slave und vom Slave an den Master zurückgesendet. Dazu besitzt er folgende Leitungen:

- *CSn*: Chip-Select
- *SCK*: Serial Clock
- *MISO*: Master In, Slave out
- *MOSI*: Master Out, Slave In

Das schalten der Csn-Leitung auf Masse (Active-Low) signalisiert den Beginn einer Übertragung.

=== Registerzugriff über SPI

Jedes Register des MCP2818FD ist 32 Bit breit und besitzt eine 12-Bit-Startadresse. Der Treiber unterscheidet die drei grundlegenden Befehle zum Schreiben, Lesen und Zurücksetzen.

#code-snippet("../mcp2518.h", "commands")

Da SPI immer mit Byte- Arrays arbeitet @picosdk-hardware-spi, muss ein solches für einen erfolgreichen SPI- transfer zunächst aus dem Befehl sowie der Zieladresse im Addressraum des MCP2518FD zusammengesetzt werden. 
Das erste Befehlsbyte enthält den vier Bit breiten SPI-Befehl sowie die oberen vier Bits der Registeradresse. Das zweite Byte überträgt die verbleibenden acht Bits der Adresse. Anschließend werden die eigentlichen Daten gesendet. @mcp2518fd

#code-snippet("../mcp2518.c", "mcp_write_register")

Beim Lesen eines Registers des MCP2518FD wird zunächst ebenfalls 2 Bytes aus Befehl und Zieladdresse gesendet. Da SPI Vollduplex ist, werden anschließend so viele Nullbytes gesendet, wie von der Zieladresse an Daten gelesen werden sollen, um den Bus zu takten. Gleichzeitig werden die vom MCP2518-FD gesendeten Bytes im Empfangspuffer gespeichert.

#code-snippet("../mcp2518.c", "mcp_read_register")

Damit die 32 Bit eines Registers sowohl byteweise über SPI als auch feldweise im Programm nutzbar sind, werden sie als Union abgebildet. `data_array` ist das Übertragungsformat, da die SPI- Treiber des mikrocontrollers immer mit 8-Bit Arrays arbeiten, und `bits` ordnet den Datenfeldern ihre eigentliche Bedeutung zu.

#code-snippet("../mcp2518.h", "union")

=== Konfiguration des Empfangspfads

Nach einem Reset beginnt die Initialisierung mit den Bitzeiten der nominalen CAN-Phase (1 Mbit/s) und der Datenphase (2 Mbit/s). Die Felder `BRP`, `TSEG1`, `TSEG2` und `SJW` bestimmen dabei den Systemtakt- Prescaler und den Abtastzeitpunkt, sowie die maximal zulässige Zeitspanne, mit der der MCP2518 seine eigene Zeitbasis anhand der Datenflanken auf dem CAN-Bus synchronisieren darf.

#code-snippet("../mcp2518.c", "mcp_bit_timing")

Das Register FIFO 1 wird als Empfangspuffer für genau eine CAN-FD-Nachricht mit bis zu 64 Byte Nutzdaten eingerichtet. TFNRFNIE legt fest, das bei vorhanden Daten im FIFO ein Interrupt ausgelöst werden soll.

#code-snippet("../mcp2518.c", "mcp_receive_fifo")

Filter 0 leitet zunächst alle Nachrichten in FIFO 1. Zusätzlich schaltet `RXIE` den globalen Empfangsinterrupt ein.

#code-snippet("../mcp2518.c", "mcp_receive_interrupt")

#code-snippet("../mcp2518.c", "mcp_receive_filter")

Die vorbereiteten Register- Objekte werden anschließend jeweils vollständig geschrieben. Erst der letzte Zugriff fordert den Normalbetrieb im CAN-FD-Modus an. 

#code-snippet("../mcp2518.c", "mcp_apply_configuration")

=== Inbetriebnahme durch den Mikrocontroller

Vor dem ersten Zugriff initialisiert der Mikrocontroller SPI und hält Chip Select auf High. Ein Reset setzt den MCP2518FD in einen definierten Ausgangszustand.

#code-snippet("../main.c", "can0_spi_setup")

Der Reset-Befehl wird bei aktivem Chip Select übertragen. Nach einer kurzen Wartezeit werden die zuvor vorbereiteten Registerwerte geschrieben und der Controller in den CAN-FD-Betrieb versetzt.

#code-snippet("../mcp2518.c", "mcp_reset")

#code-snippet("../main.c", "can0_controller_start")

=== Interruptgesteuertes Auslesen

Eine empfangene Nachricht zieht die Interrupt- Leitung des MCP2518FD auf Low. Die Interrupt-Routine führt selbst keine SPI-Übertragung aus, sondern setzt nur ein Flag. So bleibt sie kurz und der eigentliche Zugriff erfolgt kontrolliert in der Hauptschleife.

#code-snippet("../main.c", "can0_irq_handler")

Der zugehörige GPIO wird als Eingang mit Pull-up konfiguriert und auf den Low-Pegel überwacht.

#code-snippet("../main.c", "can0_irq_setup")

Beim gesetzten Flag liest die Callback-Funktion zunächst aus `C1FIFOUA1` den Offset der Nachricht im Message-RAM. Anschließend wird das vollständige Nachrichtenobjekt gelesen. Das Setzen von `UINC` bestätigt die Verarbeitung und bewegt den FIFO-Zeiger auf die nächste Nachricht.

#code-snippet("../main.c", "can0_receive_callback")

Die Hauptschleife verbindet beide Schritte: Sie verarbeitet eine Nachricht erst, wenn die Interrupt-Routine dies angefordert hat.

#code-snippet("../main.c", "can0_scheduler")
