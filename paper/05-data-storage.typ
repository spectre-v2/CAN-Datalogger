#import "header.typ":*

= Speicherung der Daten

Die Zentrale technische Herausforderung bei diesem System ist die zuverlässige Speicherung von Daten und gleichzeitiger vollständiger Aufzeichnung aller neuen eingehenden Daten. 

Eine SD- Karte besteht im Kern aus Sektoren zu je 512 Byte NAND- Flash und einem Mikrocontroller. Dieser verwaltet Sektoren, schaltet defekte Sektoren ab und stellt die übrigen mit logischen Blucknummern nach als logischen linearen Adressraum zur Verfügung.

Um eine Datei in FAT32- Format zu speichern, bedarf es der zuordnung von Clustern.


Deshalb ist es wichtig, eingehende Nachrichten schnell in einem Zwischenspeicher abzulegen, um diese anschließend weiterzuverarbeiten.
Zu diesem Zweck nutzt man ein Array, welches mithilfe von zwei Indizes verwaltet wird, ein schreib und ein Lese- INdex. Schreibt man daten in dieses Array, so erhöht man den schreibindex. Liest man dis geschriebenen Daten anschließend wieder aus, erhöht man den Leseindex. Erreicht einer der Indizes irgendwann das ende des arrays, wird er auf 0 zurückgesetzt. Dadurch ergibt sich ein Speicher, bei dem immer die ältesten einträge zuerst ausgelesen werden, und die neusten EInträge an die freiwerdende Stelle geschrieben werden. 

#code-snippet("../can_ring_buffer.c", "ringbuffer-store")

#code-snippet("../can_ring_buffer.c", "ringbuffer-fetch")

Dies nennt man auf grund der zyklischen wiederkehr der Adressen einen Ringbuffer.

Um die Daten ohne zusatzsoftware möglichst einfach verarbeitbar zu machen, wird die bisher binär gespeichert CAN-FD Nachricht als .csv- Tabelle gespeichert. Die funktion `csv_create_log_entry` übernimmt einen Pointer auf ein member des Ringbuffer- Arrays, und wandelt diese in eine mit Kommma getrennte Zeile aus Chars um, welche ID und Payload der CAN- Nachricht enthalten.

#code-snippet("../csv_text_buffer.c","csv-create-log")

Um die so entstandene CSV auf einer SD karte speichern zu können, sodass diese an jedem PC mountbar und auslesbar ist, wird sie in FAT32 formatiert. Dazu wird die Bibliothek FatFS von ChaN verwendet. Dies stellt eine minimalistische Möglichkeit dar, auf Mikrocontrollern ohne Betriebssystem ein FAT32- Dateisystem zu erzeugen.
@fatfs 

#code-snippet("../FatFS_SD_SPI_drivers/fatfs/fatfs_core.h", "fatfs-interface")




Die Bibliothek bildet allerdings nur die Dateisystemverwaltung ab, nicht die tatsächliche ansteuerung einer SD- Karte.


Glücklicherweise haben moderne SD- Karten eine weitgehend einheitliche Register- und Befehlsarchitektur, weshalb ein generischer SD-SPI-Treiber verwendet werden kann. In diesem fall wird eine abgewandelte version von no-OS-FatFS-SD-SPI-RPi-Pico von Carl John Kugler verwendet. @sd-driver Dieser Treiber wird über ein von FatFS vorgesehenes Interface aufgerufen, darin werden die Funktionen Verknüpft. Beispielsweise:

#code-snippet("../FatFS_SD_SPI_drivers/fatfs/fatfs_sd_adapter.c", "fatfs-adapter")


Anschließend wird `sd_card_write_blocks` ausgeführt und nutzt seinerseits die Pico- SDK funktion `spi_write_read`.




