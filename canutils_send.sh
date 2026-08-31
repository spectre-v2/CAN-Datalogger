
#!/usr/bin/env bash

set -e

#docs:start:canutils-send
CAN_INTERFACE="can0"
CAN_MESSAGE_COUNT=10000
CAN_TX_QUEUE_LENGTH=12000

# Desired number of messages per second. Example: 1000 Hz = 0.001 s pause.
CAN_SEND_FREQUENCY_HZ=10000
# Pause in seconds = 1 / frequency.
SEND_INTERVAL_SECONDS=$(LC_NUMERIC=C awk "BEGIN { print 1 / $CAN_SEND_FREQUENCY_HZ }")

echo "Configuring ${CAN_INTERFACE}..."

sudo ip link set "$CAN_INTERFACE" down
sudo ip link set "$CAN_INTERFACE" type can bitrate 500000 dbitrate 2000000 fd on
sudo ip link set "$CAN_INTERFACE" up
#sudo ip link set "$CAN_INTERFACE" txqueuelen "$CAN_TX_QUEUE_LENGTH"
echo
echo "Sending CAN FD data..."


# A full CAN FD payload is 64 bytes (128 hexadecimal characters).  Reserve the
# final four bytes for the sequence number and initialise all preceding bytes.
printf -v zero_padding '%0120d' 0

for ((count=0; count < CAN_MESSAGE_COUNT; count++)); do
    # Final four data bytes: monotonically increasing sequence number (big-endian).
    printf -v sequence_hex '%08x' "$count"
    cansend "$CAN_INTERFACE" "001##1${zero_padding}${sequence_hex}"
    sleep "$SEND_INTERVAL_SECONDS"
done

echo "Done."

echo
ip -details -statistics link show dev "$CAN_INTERFACE"


#docs:end:canutils-send
