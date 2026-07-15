#import "header.typ":*

= Empfangen von CAN-FD-Nachrichten

== Der Treiber des MCP2518FD

Der RP2350 verarbeitet CAN-FD nicht selbst, sondern über den externen Controller MCP2518FD. Der Treiber trennt deshalb die SPI-Übertragung von der CAN-spezifischen Konfiguration: Zuerst werden Befehle und Registeradressen übertragen; anschließend werden Bitzeiten, Empfangspuffer und Interrupts eingestellt.

=== Registerzugriff über SPI

Der MCP2518FD wird über SPI adressiert. Jedes Register ist 32 Bit breit und besitzt eine 12-Bit-Startadresse. Der Treiber unterscheidet die drei grundlegenden Befehle zum Schreiben, Lesen und Zurücksetzen.

#code-snippet("../mcp.h", "commands")

Das erste Befehlsbyte enthält den vier Bit breiten SPI-Befehl sowie die oberen vier Bits der Registeradresse. Das zweite Byte überträgt die verbleibenden acht Adressbits. Chip Select rahmt eine vollständige Transaktion ein; erst danach wertet der Controller den Zugriff aus.

#code-snippet("../mcp.c", "mcp_write_register")

Beim Lesen wird zunächst dieselbe Adressphase gesendet. SPI ist vollduplex: Die Leseaufrufe erzeugen mit Nullbytes den benötigten Takt und speichern die gleichzeitig vom Controller gesendeten Registerbytes im Empfangspuffer.

#code-snippet("../mcp.c", "mcp_read_register")

Damit die 32 Bit eines Registers sowohl byteweise über SPI als auch feldweise im Programm nutzbar sind, werden sie als Union abgebildet. `data_array` ist das Übertragungsformat; `bits` benennt die Bitfelder. So wird etwa die gewünschte Betriebsart gesetzt, ohne Bitpositionen im Anwendungscode berechnen zu müssen.

#code-snippet("../mcp.h", "union")

=== Konfiguration des Empfangspfads

Nach einem Reset beginnt die Initialisierung mit den Bitzeiten der nominalen CAN-Phase (500 kbit/s) und der Datenphase (2 Mbit/s). Die Felder `BRP`, `TSEG1`, `TSEG2` und `SJW` bestimmen dabei den Zeitraster und den Abtastzeitpunkt auf dem CAN-Bus.

#code-snippet("../mcp.c", "mcp_bit_timing")

FIFO 1 wird als Empfangspuffer für genau eine CAN-FD-Nachricht mit bis zu 64 Byte Nutzdaten eingerichtet. `TXEN = 0` legt den FIFO als Empfangs-FIFO fest; die FIFO-Benachrichtigung signalisiert, dass eine Nachricht darin bereitsteht.

#code-snippet("../mcp.c", "mcp_receive_fifo")

Filter 0 leitet passende Nachrichten in FIFO 1. Zusätzlich schaltet `RXIE` den globalen Empfangsinterrupt ein, während `REQOP` den CAN-FD-Normalbetrieb anfordert.

#code-snippet("../mcp.c", "mcp_receive_interrupt")

Die vorbereiteten Registerbilder werden anschließend jeweils vollständig, also mit vier Byte, geschrieben. Erst der letzte Zugriff fordert den Normalbetrieb im CAN-FD-Modus an. Dadurch ist die Empfangskette konfiguriert, bevor der Controller am Bus arbeitet.

#code-snippet("../mcp.c", "mcp_apply_configuration")

=== Inbetriebnahme durch den Mikrocontroller

Vor dem ersten Zugriff initialisiert der Mikrocontroller SPI und hält Chip Select inaktiv auf High. Ein Reset setzt den MCP2518FD in einen definierten Ausgangszustand. Nach der Konfiguration wird die Gerätekennung gelesen; sie ist ein einfacher Test, ob die SPI-Verbindung und die Registerkommunikation funktionieren.

#code-snippet("../main.c", "can0_spi_setup")

#code-snippet("../main.c", "can0_controller_start")
