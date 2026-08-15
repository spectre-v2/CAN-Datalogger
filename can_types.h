#pragma once

#include <stdint.h>


//properties of the entire databus
#define BUS_EXTENDED_ID 0
#define BUS_CAN_FD 1
#define BUS_BITRATE_SWITCH 1
#define BUS_REMOTE_TRANSMISSION 0


typedef struct{
    uint32_t SID;
    uint32_t DLC : 4;
    uint32_t ESI : 1;
    uint32_t unimplemented : 7;
    uint8_t can_payload[64];
}can_frame_t;
