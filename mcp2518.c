#include "mcp2518.h"

// C standard library
#include <stdio.h>

// Raspberry Pi Pico SDK
#include "hardware/gpio.h"
#include "hardware/spi.h"
#include "pico/stdlib.h"

// Project modules
#include "board.h"


//docs:start:mcp_reset
void mcp_reset(void){
    printf("Resetting MCP2518... ");
    uint8_t command[2];
    command[0]= 0b00000000;
    command[1]= 0b00000000;
    gpio_put(pin_can0_cs,0);
        sleep_us(1);
    spi_write_blocking(spi_port_can0,command, 2);
        sleep_us(1);
    gpio_put(pin_can0_cs,1); 
    printf("done.\n");
}
//docs:end:mcp_reset

//docs:start:mcp_write_register
void mcp_write(uint16_t address, const void *tx_buffer, size_t length){
    printf("Attempting MCP2518 Register modification... ");

    uint8_t command[2];
    command[0]=MCP_COMMAND_WRITE | (address >>8);
    command[1]=address & 0b000011111111;
    gpio_put(pin_can0_cs, 0);
    sleep_us(1);
    spi_write_blocking(spi_port_can0, command, 2);
    spi_write_blocking(spi_port_can0, tx_buffer, length);
    sleep_us(1);
    gpio_put(pin_can0_cs, 1);

    printf("done.\n");
}
//docs:end:mcp_write_register

//docs:start:mcp_read_register
void mcp_read(uint16_t address, void *rx_buffer, size_t length){
    printf("Attempting MCP2518 Register retrieve... ");
    
    uint8_t command[2];

    command[0]= MCP_COMMAND_READ | (address>>8);    //4 command bits + first 4 address bits according to datasheet
    command[1]= address & 0b000011111111;   //filtering lower 8 address bits

    gpio_put(pin_can0_cs, 0);
    spi_write_blocking(spi_port_can0, command, 2); 
    spi_read_blocking(spi_port_can0, 0b00000000, rx_buffer, length); //sending empty bytes and write recieved data in buffer
    gpio_put(pin_can0_cs, 1);

    printf("done.\n");
}
//docs:end:mcp_read_register


void mcp_init(void){

    printf("Initializing MCP2518... ");


    //nominal data rate: 500kbit/s
    //sample point: 87%, weil der Candlelight FD auch auf dieser Sample rate arbeitet
    //system clock: 20Mhz
    MCP_REG_C1NBTCFG_t mcp_c1nbtcfg = {
        .bits = {
            .SJW= 4,    //5 TQ allowed sample point adjustment to synchronize bus
            .TSEG2= 4, // 5 time quantums after sample
            .TSEG1= 33,  //34 time quantums before sample
            .BRP= 0     //system clock prescaler for can-controller
        },
    };

    //data phase rate to 2Mbit/s
    MCP_REG_C1DBTCFG_t mcp_c1dbtcfg = {
        .bits = {
            .SJW= 1,
            .TSEG2= 1,
            .TSEG1= 6,
            .BRP= 0
        },
    };
    //docs:end:mcp_bit_timing

    //docs:start:mcp_receive_fifo
    MCP_REG_C1FIFOCON_t mcp_c1fifocon1 = {
        .bits = {
            
            .PLSIZE= 0b111, //64 byte payload
            .FSIZE= 0b11001, //26 Messages fifo-depth
            .TFNRFNIE= 1, // Recieve-Fifo not empty Interrupt enabled.
        },
    };
    //docs:end:mcp_receive_fifo

    //docs:start:mcp_receive_interrupt
    MCP_REG_C1INT_t mcp_c1int = {
        .bits = {
            .RXIE = 1, //recieve message interrupt enable
        }
    };
    //docs:end:mcp_receive_interrupt

    
    //docs:start:mcp_receive_filter
    MCP_REG_C1FLTCON_t mcp_c1fltcon = {
        .bits = {
            .FLTEN0= 1, //enable filter 0
            .F0BP=  1 //save hits in fifo 1
        }
    };
    //docs:end:mcp_receive_filter

    MCP_REG_C1CON_t mcp_c1con = {
        .bits = {
            .ISOCRCEN = 1, //use ISO-CAN-FD
            .REQOP = 0  //request normal can-FD mode
        }
    };
    
    
    //docs:start:mcp_apply_configuration
    mcp_write(MCP_REG_ADR_C1NBTCFG, mcp_c1nbtcfg.data_array, sizeof mcp_c1nbtcfg.data_array);
    mcp_write(MCP_REG_ADR_C1DBTCFG, mcp_c1dbtcfg.data_array, sizeof mcp_c1dbtcfg.data_array);
    mcp_write(MCP_REG_ADR_C1FIFOCON1, mcp_c1fifocon1.data_array, sizeof mcp_c1fifocon1.data_array);
    mcp_write(MCP_REG_ADR_C1INT, mcp_c1int.data_array, sizeof mcp_c1int.data_array);
    mcp_write(MCP_REG_ADR_C1FLTCON0, mcp_c1fltcon.data_array, sizeof mcp_c1fltcon.data_array);
    mcp_write(MCP_REG_ADR_C1CON, mcp_c1con.data_array, sizeof mcp_c1con.data_array);
    //docs:end:mcp_apply_configuration

    printf("done.\n");

}
