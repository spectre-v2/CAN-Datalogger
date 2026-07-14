#pragma once

#include <stdint.h>
#include <stddef.h>
#include "pico/stdlib.h"
#include "hardware/spi.h"

// MCP command bits
#define MCP_COMMAND_WRITE 0b00100000
#define MCP_COMMAND_READ 0b00110000
#define MCP_COMMAND_RESET 0b00000000

// MCP2518FD register addresses 

#define MCP_REG_C1CON       0b000000000000  // 0x000 - CAN Control Register
#define MCP_REG_C1NBTCFG    0b000000000100  // 0x004 - Nominal Bit Time Configuration Register
#define MCP_REG_C1DBTCFG    0b000000001000  // 0x008 - Data Bit Time Configuration Register
#define MCP_REG_C1TDC       0b000000001100  // 0x00C - Transmitter Delay Compensation Register
#define MCP_REG_C1INT       0b000000011100  // 0x01C - Interrupt Register
#define MCP_REG_C1RXIF      0b000000100000  // 0x020 - Receive Interrupt Flag Register
#define MCP_REG_C1TXIF      0b000000100100  // 0x024 - Transmit Interrupt Flag Register
#define MCP_REG_C1TXREQ     0b000000110000  // 0x030 - Transmit Request Register
#define MCP_REG_C1TREC      0b000000110100  // 0x034 - Transmit/Receive Error Count Register

#define MCP_REG_C1FIFOCON1  0b000001011100  // 0x05C - FIFO 1 Control Register
#define MCP_REG_C1FIFOSTA1  0b000001100000  // 0x060 - FIFO 1 Status Register
#define MCP_REG_C1FIFOUA1   0b000001100100  // 0x064 - FIFO 1 User Address Register

#define MCP_REG_C1FLTCON0   0b000111010000  // 0x1D0 - Filter Control Register 0
#define MCP_REG_C1FLTOBJ0   0b000111110000  // 0x1F0 - Filter Object Register 0
#define MCP_REG_C1MASK0     0b000111110100  // 0x1F4 - Mask Register 0

#define MCP_REG_OSC         0b111000000000  // 0xE00 - Oscillator Control Register
#define MCP_REG_IOCON       0b111000000100  // 0xE04 - I/O Control Register
#define MCP_REG_DEVID       0b111000010100  // 0xE14 - Device ID Register


//Register manipulation on the mcp2518 works by writing and reading 32- bit arrays using SPI.
//SPI can only work with arrays, that is why unions are used to sort the data into bit fields for easy manipulation.
typedef union {
    uint8_t data_array[4];

    struct __attribute__((packed)) {
        uint32_t DNCNT : 5;              // DeviceNet Filter Bit Number bits
        uint32_t ISOCRCEN : 1;           // Enable ISO CRC in CAN FD Frames bit
        uint32_t PXEDIS : 1;             // Protocol Exception Event Detection Disable bit
        uint32_t unimplemented1 : 1;
        uint32_t WAKFIL : 1;             // Enable CAN Bus Line Wake-up Filter bit
        uint32_t WFT : 2;                // Selectable Wake-up Filter Time bits
        uint32_t BUSY : 1;               // CAN Module Busy bit
        uint32_t BRSDIS : 1;             // Bit Rate Switching Disable bit
        uint32_t unimplemented2 : 3;
        uint32_t RTXAT : 1;              // Restrict Retransmission Attempts bit
        uint32_t ESIGM : 1;              // Transmit ESI in Gateway Mode bit
        uint32_t SERR2LOM : 1;           // Transition to Listen Only Mode on System Error bit
        uint32_t STEF : 1;               // Store in Transmit Event FIFO bit
        uint32_t TXQEN : 1;              // Enable Transmit Queue bit
        uint32_t OPMOD : 3;              // Operation Mode Status bits
        uint32_t REQOP : 3;              // Request Operation Mode bits
        uint32_t ABAT : 1;               // Abort All Pending Transmissions bit
        uint32_t TXBWS : 4;              // Transmit Bandwidth Sharing bits
    } bits;

} MCP_C1CON_t;                       // CAN Control Register

typedef union {
    uint8_t data_array[4];
    struct __attribute__((packed)) {
    uint32_t SJW : 7;                // Synchronization Jump Width bits
    uint32_t unimplemented1 : 1;
    uint32_t TSEG2 : 7;              // Time Segment 2 bits
    uint32_t unimplemented2 : 1;
    uint32_t TSEG1 : 8;              // Time Segment 1 bits
    uint32_t BRP : 8;                // Baud Rate Prescaler bits
    } bits;
} MCP_C1NBTCFG_t;

typedef union {
    uint8_t data_array[4];
    struct __attribute__((packed)) {
    uint32_t SJW : 4;                // Synchronization Jump Width bits
    uint32_t unimplemented1 : 4;
    uint32_t TSEG2 : 4;              // Time Segment 2 bits
    uint32_t unimplemented2 : 4;
    uint32_t TSEG1 : 5;              // Time Segment 1 bits
    uint32_t unimplemented3 : 3;
    uint32_t BRP : 8;                // Baud Rate Prescaler bits
    } bits;
} MCP_C1DBTCFG_t;


typedef union {
    uint8_t data_array[4];
    struct __attribute__((packed)) {
    uint32_t TDCV : 6;               // Transmitter Delay Compensation Value bits
    uint32_t unimplemented1 : 2;
    uint32_t TDCO : 7;               // Transmitter Delay Compensation Offset bits
    uint32_t unimplemented2 : 1;
    uint32_t TDCMOD : 2;             // Transmitter Delay Compensation Mode bits
    uint32_t unimplemented3 : 6;
    uint32_t SID11EN : 1;            // Enable 12-Bit SID in CAN FD Base Format Messages bit
    uint32_t EDGFLTEN : 1;           // Enable Edge Filtering during Bus Integration bit
    uint32_t unimplemented4 : 6;
    } bits;
} MCP_C1TDC_t;

typedef union {
    uint8_t data_array[4];
    struct __attribute__((packed)) {
    uint32_t TXIF : 1;               // Transmit Interrupt Flag bit
    uint32_t RXIF : 1;               // Receive Interrupt Flag bit
    uint32_t TBCIF : 1;              // Time Base Counter Interrupt Flag bit
    uint32_t MODIF : 1;              // CAN Mode Change Interrupt Flag bit
    uint32_t TEFIF : 1;              // Transmit Event FIFO Interrupt Flag bit
    uint32_t unimplemented1 : 3;
    uint32_t ECCIF : 1;              // ECC Error Interrupt Flag bit
    uint32_t SPICRCIF : 1;           // SPI CRC Error Interrupt Flag bit
    uint32_t TXATIF : 1;             // Transmit Attempt Interrupt Flag bit
    uint32_t RXOVIF : 1;             // Receive FIFO Overflow Interrupt Flag bit
    uint32_t SERRIF : 1;             // System Error Interrupt Flag bit
    uint32_t CERRIF : 1;             // CAN Bus Error Interrupt Flag bit
    uint32_t WAKIF : 1;              // Bus Wake-up Interrupt Flag bit
    uint32_t IVMIF : 1;              // Invalid Message Interrupt Flag bit
    uint32_t TXIE : 1;               // Transmit Interrupt Enable bit
    uint32_t RXIE : 1;               // Receive Interrupt Enable bit
    uint32_t TBCIE : 1;              // Time Base Counter Interrupt Enable bit
    uint32_t MODIE : 1;              // CAN Mode Change Interrupt Enable bit
    uint32_t TEFIE : 1;              // Transmit Event FIFO Interrupt Enable bit
    uint32_t unimplemented2 : 3;
    uint32_t ECCIE : 1;              // ECC Error Interrupt Enable bit
    uint32_t SPICRCIE : 1;           // SPI CRC Error Interrupt Enable bit
    uint32_t TXATIE : 1;             // Transmit Attempt Interrupt Enable bit
    uint32_t RXOVIE : 1;             // Receive FIFO Overflow Interrupt Enable bit
    uint32_t SERRIE : 1;             // System Error Interrupt Enable bit
    uint32_t CERRIE : 1;             // CAN Bus Error Interrupt Enable bit
    uint32_t WAKIE : 1;              // Bus Wake-up Interrupt Enable bit
    uint32_t IVMIE : 1;              // Invalid Message Interrupt Enable bit
    } bits;
} MCP_C1INT_t;

typedef union {
    uint8_t data_array[4];
    struct __attribute__((packed)) {
    uint32_t unimplemented1 : 1;
    uint32_t RFIF : 31;              // Receive FIFO Interrupt Pending bits
    } bits;
} MCP_C1RXIF_t;

typedef union {
    uint8_t data_array[4];
    struct __attribute__((packed)) {
    uint32_t TFIF : 32;              // Transmit FIFO/TXQ Interrupt Pending bits
    } bits;
} MCP_C1TXIF_t;

typedef union {
    uint8_t data_array[4];
    struct __attribute__((packed)) {
    uint32_t TXREQ : 32;             // Message Send Request bits
    } bits;
} MCP_C1TXREQ_t;

typedef union {
    uint8_t data_array[4];
    struct __attribute__((packed)) {
    uint32_t REC : 8;                // Receive Error Counter bits
    uint32_t TEC : 8;                // Transmit Error Counter bits
    uint32_t EWARN : 1;              // Error Warning State bit
    uint32_t RXWARN : 1;             // Receiver Error Warning State bit
    uint32_t TXWARN : 1;             // Transmitter Error Warning State bit
    uint32_t RXBP : 1;               // Receiver Error Passive State bit
    uint32_t TXBP : 1;               // Transmitter Error Passive State bit
    uint32_t TXBO : 1;               // Transmitter Bus Off State bit
    uint32_t unimplemented1 : 10;
    } bits;
} MCP_C1TREC_t;

typedef union {
    uint8_t data_array[4];
    struct __attribute__((packed)) {
    uint32_t TFNRFNIE : 1;           // Transmit/Receive FIFO Not Full/Not Empty Interrupt Enable bit
    uint32_t TFHRFHIE : 1;           // Transmit/Receive FIFO Half Empty/Half Full Interrupt Enable bit
    uint32_t TFERFFIE : 1;           // Transmit/Receive FIFO Empty/Full Interrupt Enable bit
    uint32_t RXOVIE : 1;             // Receive FIFO Overflow Interrupt Enable bit
    uint32_t TXATIE : 1;             // Transmit Attempt Interrupt Enable bit
    uint32_t RXTSEN : 1;             // Receive Time Stamp Enable bit
    uint32_t RTREN : 1;              // Retransmission Enable bit
    uint32_t TXEN : 1;               // Transmit Enable bit
    uint32_t UINC : 1;               // Increment Head/Tail bit
    uint32_t TXREQ : 1;              // Message Send Request bit
    uint32_t FRESET : 1;             // FIFO Reset bit
    uint32_t unimplemented1 : 5;
    uint32_t TXPRI : 5;              // Message Transmit Priority bits
    uint32_t TXAT : 2;               // Retransmission Attempts bits
    uint32_t unimplemented2 : 1;
    uint32_t FSIZE : 5;              // FIFO Size bits
    uint32_t PLSIZE : 3;             // Payload Size bits
    } bits;
} MCP_C1FIFOCON_t;

typedef union {
    uint8_t data_array[4];
    struct __attribute__((packed)) {
    uint32_t TFNRFNIF : 1;           // Transmit/Receive FIFO Not Full/Not Empty Interrupt Flag bit
    uint32_t TFHRFHIF : 1;           // Transmit/Receive FIFO Half Empty/Half Full Interrupt Flag bit
    uint32_t TFERFFIF : 1;           // Transmit/Receive FIFO Empty/Full Interrupt Flag bit
    uint32_t RXOVIF : 1;             // Receive FIFO Overflow Interrupt Flag bit
    uint32_t TXATIF : 1;             // Transmit Attempts Exhausted Interrupt Flag bit
    uint32_t TXERR : 1;              // Error Detected During Transmission bit
    uint32_t TXLARB : 1;             // Message Lost Arbitration Status bit
    uint32_t TXABT : 1;              // Message Aborted Status bit
    uint32_t FIFOCI : 5;             // FIFO Message Index bits
    uint32_t unimplemented1 : 19;
    } bits;
} MCP_C1FIFOSTA_t;

typedef union {
    uint8_t data_array[4];
    struct __attribute__((packed)) {
    uint32_t FIFOUA : 32;            // FIFO User Address bits
    } bits;
} MCP_C1FIFOUA_t;

typedef union {
    uint8_t data_array[4];
    struct __attribute__((packed)) {
    uint32_t F0BP : 5;               // Filter 0 Buffer Pointer bits
    uint32_t unimplemented1 : 2;
    uint32_t FLTEN0 : 1;             // Enable Filter 0 to Accept Messages bit
    uint32_t F1BP : 5;               // Filter 1 Buffer Pointer bits
    uint32_t unimplemented2 : 2;
    uint32_t FLTEN1 : 1;             // Enable Filter 1 to Accept Messages bit
    uint32_t F2BP : 5;               // Filter 2 Buffer Pointer bits
    uint32_t unimplemented3 : 2;
    uint32_t FLTEN2 : 1;             // Enable Filter 2 to Accept Messages bit
    uint32_t F3BP : 5;               // Filter 3 Buffer Pointer bits
    uint32_t unimplemented4 : 2;
    uint32_t FLTEN3 : 1;             // Enable Filter 3 to Accept Messages bit
    } bits;
} MCP_C1FLTCON_t;

typedef union {
    uint8_t data_array[4];
    struct __attribute__((packed)) {
    uint32_t SID : 11;               // Standard Identifier Filter bits
    uint32_t EID : 18;               // Extended Identifier Filter bits
    uint32_t SID11 : 1;              // Standard Identifier Filter bit 11
    uint32_t EXIDE : 1;              // Extended Identifier Enable bit
    uint32_t unimplemented1 : 1;
    } bits;
} MCP_C1FLTOBJ_t;

typedef union {
    uint8_t data_array[4];
    struct __attribute__((packed)) {
    uint32_t MSID : 11;              // Standard Identifier Mask bits
    uint32_t MEID : 18;              // Extended Identifier Mask bits
    uint32_t MSID11 : 1;             // Standard Identifier Mask bit 11
    uint32_t MIDE : 1;               // Identifier Receive Mode bit
    uint32_t unimplemented1 : 1;
    } bits;
} MCP_C1MASK_t;

typedef union {
    uint8_t data_array[4];
    struct __attribute__((packed)) {
    uint32_t PLLEN : 1;              // PLL Enable bit
    uint32_t unimplemented1 : 1;
    uint32_t OSCDIS : 1;             // Clock (Oscillator) Disable bit
    uint32_t LPMEN : 1;              // Low Power Mode Enable bit
    uint32_t SCLKDIV : 1;            // System Clock Divisor bit
    uint32_t CLKODIV : 2;            // Clock Output Divisor bits
    uint32_t unimplemented2 : 1;
    uint32_t PLLRDY : 1;             // PLL Ready bit
    uint32_t unimplemented3 : 1;
    uint32_t OSCRDY : 1;             // Oscillator Clock Ready bit
    uint32_t unimplemented4 : 1;
    uint32_t SCLKRDY : 1;            // Synchronized System Clock Divisor bit
    uint32_t unimplemented5 : 19;
    } bits;
} MCP_OSC_t;

typedef union {
    uint8_t data_array[4];
    struct __attribute__((packed)) {
    uint32_t TRIS0 : 1;              // GPIO0 Data Direction bit
    uint32_t TRIS1 : 1;              // GPIO1 Data Direction bit
    uint32_t unimplemented1 : 4;
    uint32_t XSTBYEN : 1;            // Enable Transceiver Standby Pin Control bit
    uint32_t unimplemented2 : 1;
    uint32_t LAT0 : 1;               // GPIO0 Latch bit
    uint32_t LAT1 : 1;               // GPIO1 Latch bit
    uint32_t unimplemented3 : 6;
    uint32_t GPIO0 : 1;              // GPIO0 Status bit
    uint32_t GPIO1 : 1;              // GPIO1 Status bit
    uint32_t unimplemented4 : 6;
    uint32_t PM0 : 1;                // GPIO0 Pin Mode bit
    uint32_t PM1 : 1;                // GPIO1 Pin Mode bit
    uint32_t unimplemented5 : 2;
    uint32_t TXCANOD : 1;            // TXCAN Open Drain Mode bit
    uint32_t SOF : 1;                // Start-of-Frame Signal bit
    uint32_t INTOD : 1;              // Interrupt Pins Open Drain Mode bit
    uint32_t unimplemented6 : 1;
    } bits;
} MCP_IOCON_t;



// nur zm testen, später wieder löschen wenn spi funktioniert, weil braucht keiner
typedef union {
    uint8_t data_array[4];
    struct __attribute__((packed)) {
    uint32_t REV : 4;                // Device Revision bits
    uint32_t ID : 4;                 // Device Identifier bits
    uint32_t unimplemented1 : 24;
    } bits;
} MCP_DEVID_t;

void mcp_reset();

void mcp_write_reg(uint16_t address, uint8_t *tx_buffer, size_t length);

void mcp_read_reg(uint16_t address,uint8_t *rx_buffer, size_t length);

void mcp_init();


