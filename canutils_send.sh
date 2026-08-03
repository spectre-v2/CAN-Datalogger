
#!/usr/bin/env bash

set -e

CAN_INTERFACE="can0"
CAN_MESSAGE="123##1DEADBEEF"

echo "Available network interfaces:"
ip link show

echo
echo "Configuring ${CAN_INTERFACE}..."

sudo ip link set "$CAN_INTERFACE" down
sudo ip link set "$CAN_INTERFACE" type can bitrate 500000 dbitrate 2000000 fd on
sudo ip link set "$CAN_INTERFACE" up

echo
echo "${CAN_INTERFACE} properties:"
ip -details -statistics link show "$CAN_INTERFACE"

echo
echo "Sending CAN FD test message ${CAN_MESSAGE}..."
cansend "$CAN_INTERFACE" "$CAN_MESSAGE"

