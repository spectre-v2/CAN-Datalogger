#import "header.typ":*

= Speicherung der Daten

Die Zentrale technische Herausforderung bei diesem System ist die zuverlässige Speicherung von Daten und gleichzeitiger vollständiger Aufzeichnung aller neuen eingehenden Daten. 

Eine SD- Karte besteht im Kern aus Sektoren zu je 512 Byte NAND- Flash und einem Mikrocontroller. Dieser verwaltet Sektoren, schaltet defekte Sektoren ab und stellt die übrigen mit Blucknummern nach als logischen linearen Adressraum zur Verfügung. Ein Sektor ist die kleinste les- oder schreibbare Einheit.

Um eine Datei in FAT32- Format zu speichern, bedarf es der Zuordnung von Sektoren zu größeren Gruppen, den Clustern. Ein Cluster umfasst immer eine feste Menge an Sektoren. Anschließend müssen die zu speichernden Daten diesen Clustern zugeordnet werden. 

In einem Bestimmten Speicherbereich des Speichermedium liegt die Partitionstabelle. Diese gibt auskunft darüber, welche in welche Partitionen das Speichermedium aufgeteilt ist, welche Formate in den Partitionen zu erwarten sind und in welchem Sektor die Partitionen beginnen.

In der FAT32- Partition liegen dann zuerst diverse wichtige Metadaten im sogenannten Bootsektor. Hier wird festgehalten, wie viele Sektoren zu einem Cluster zusammengefasst wurden, wie viele Cluster existieren, und wie viele davon für Metadaten reserviert sind. Daraus wird die Adresse der Dateizuordnungstabelle, der File Allocation Table (FAT) berechnet. Es können auch mehrere FATs existieren, ihre Anzahl ist im Bootsektor vermerkt. In dieser Tabelle wird festgehalten, in welchen Clustern eine gespeicherte Datei tatsächlich liegt, wo die Datei beginnt und wo sie endet. Jeder für eine Datei Markierte cluster enthält entweder eine Startmarkierung, die nummer des folgenden Clusters, oder eine Endmarkierung. Eine Datei ist somit als Reihe von Clustern definiert. Cluster müssen nicht direkt aufeinander folgen, da die FAT auch Nummern von besetzten oder defekten Clustern überspringen kann.

Ebenso wird aus der FAT ersichtlich, welche Cluster ungenutzt oder Defekt sind.

Wenn eine Datei Gespeichert, gelesen oder Modifiziert werden soll, muss zuerst ein passendes cluster und der darin enthaltene passende Sektor berechnet werden. Ist der verbleibende Platz in einem CLuster zu klein, muss ein freier Cluster gefunden und in der FAT vermerkt werden. Dann kann der Sektor oder die Sektoren gelesen, modifiziert, und zurückgeschrieben werden. Dazu nutzt man im Prozessor in regel einen sogenannten Sector Cache.
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




