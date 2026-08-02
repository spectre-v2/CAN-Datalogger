#pragma once

#include <stdint.h>

// Datatype for CAN-FD messages stored in MCP2518FD message RAM.
typedef union {
    uint8_t data_array[72];
    struct __attribute__((packed)) {
        uint32_t SID : 11;             // Standard Identifier
        uint32_t EID : 18;             // Extended Identifier
        uint32_t SID12 : 1;            // optional 12. bit of SID
        uint32_t unimplemented_0 : 2;
        uint32_t DLC : 4;              // Data Length Code
        uint32_t IDE : 1;              // Identifier Extension
        uint32_t RTR : 1;              // Remote Transmission Request
        uint32_t BRS : 1;              // Bit Rate Switch
        uint32_t ESI : 1;              // Error Status Indicator
        uint32_t unimplemented_1 : 2;
        uint32_t FILHIT : 5;           // Acceptance filter that accepted this message
        uint32_t unimplemented_2 : 16;
        uint8_t can_payload[64];
    } can_message;
} can_message_object_t;
