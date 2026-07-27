#pragma once
// SPI Defines

#define spi_port_can0 spi0

#define pin_can0_cs 1   //blue
#define pin_can0_sck 2  //white
#define pin_can0_tx 3   //yellow
#define pin_can0_rx 4   //green
#define pin_can0_irq 5  //orange

#define pin_pico2_led 25

//Datatype for CAN-FD Messages
typedef union{
    uint8_t data_array[72];
    struct __attribute__((packed)){
        uint32_t SID : 11;    //Standard Identifier
        uint32_t EID : 18;      //Extended Identifier
        uint32_t SID12 : 1;     // optional 12. Bit of SID
        uint32_t unimplemented_0 : 2;
        uint32_t DLC : 4;       //Data Length Code
        uint32_t IDE : 1;       //Identifier Extension
        uint32_t RTR : 1;       //Remote Transmission Request
        uint32_t BRS : 1;       //Bit Rate Switch
        uint32_t ESI :1; //Error Status Indicator
        uint32_t unimplemented_1 : 2;
        uint32_t FILHIT : 5; // Number of acceptance filter that accepted this Message
        uint32_t unimplemented_2 : 16;
        uint8_t can_payload[64];
    } can_message;
} can_message_object_t;

