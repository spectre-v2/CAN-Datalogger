#import "header.typ":*


== Senden von CAN- FD Nachrichten
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

== Experiment 1: Vollständigkeit eines Datensatzes

Um sicherzustellen, ab welcher übertragungsgeschwindigkeit Informationen verloren gehen, wird ein skript verwendet, welches eine fortlaufende Zahl als Inhalt der Nachricht setzt.

#code-snippet("../canutils_send.sh", "canutils-send")


In der Logdatei wird anschließend der Dezimalwert der Payload über die Nummer dargestellt, die die Nachricht in der Tabelle der empfangenen Nachrichten einnimmt.

== Experiment 2: Bestimmung der Speicherlatenzen

Um feststellen zu können, wie lange der Mikrocontroller benötigt, um eine vom Can Controller empfangene Nachricht zu speichern, wird eine gemeinsame Zeitbasis des Senders und des empfängers benötigt. Aus diesem Grund wird der Logic Analyzer verwendet, um den die zeitliche Differenz des can-recieve interrupts und einer vom mikrocontroller erzeugkten zeitmarke exakt zu bestimmen.
Es werden zwei zeitliche differenzen berechnet, welche für die systemarchitektur entscheident sind:

- Zwischen MCP-Nachrichtenempfang und Abgeschlossener Speicherung im Ringbuffer $Delta t_"can->buf"$
- Zwischen Nachrichtenempfang und speicherung auf SD- Karte: $Delta t_("can->sd")$

Es wird ein GPIO konfiguriert, welcher nach erfolgreichem abschluss eines schreibvorgangees die flanke wechselt. Somit besitzt der Logische Zustand dieses Bits keien aussagekraft, sondern jediglich der wechsel seiner Flanke. 