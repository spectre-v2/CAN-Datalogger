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