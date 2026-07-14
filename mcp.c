#include <stdio.h>
#include "pico/stdlib.h"
#include "hardware/spi.h"
#include "mcp.h"
#include "main.h"

void mcp_reset(){
    uint8_t command[2];
    command[0]= 0b00000000;
    command[1]= 0b00000000;
    gpio_put(PIN_CS,0);
    spi_write_blocking(SPI_PORT,command, 2);
    gpio_put(PIN_CS,1); 
}

void mcp_write_reg(uint16_t address, uint8_t *tx_buffer){
    uint8_t command[2];
    command[0]=MCP_COMMAND_WRITE | (address >>8);
    command[1]=address & 0b000011111111;
    gpio_put(PIN_CS, 0);
    spi_write_blocking(SPI_PORT, command, 2);
    spi_write_blocking(SPI_PORT, tx_buffer, sizeof tx_buffer);
    gpio_put(PIN_CS, 1);
}

void mcp_read_reg(uint16_t address,uint8_t *rx_buffer){

    uint8_t command[2];

    command[0]= MCP_COMMAND_READ | (address>>8);    //4 command bits + first 4 address bits
    command[1]= address & 0b000011111111;   //last 8 address bits

    gpio_put(PIN_CS, 0);
    spi_write_blocking(SPI_PORT, command, 2);   //send 2 entries of command array
    spi_read_blocking(SPI_PORT, 0b00000000, rx_buffer, sizeof rx_buffer); //send empty bytes and write recieved data in buffer
    gpio_put(PIN_CS, 1);
}

void mcp_init(){


    MCP_C1NBTCFG_t mcp_c1nbtcfg = { //nominal data rate to 500kbit/s
        .bits = {
            .SJW=0b0001111,     //allowed sample point adjustment to synchronize bus
            .TSEG2=0b0001111,   //time quantums after sample
            .TSEG1=0b00111110,  //time quantums before sample
            .BRP=0b00000000     //system clock prescaler for can-controller
        },
    };

    MCP_C1DBTCFG_t mcp_c1dbtcfg = { //data phase rate to 2Mbit/s
        .bits = {
            .SJW= 0b0011,
            .TSEG2= 0b0011,
            .TSEG1= 0b01110,
            .BRP= 0b00000000
        },
    };


    MCP_C1FIFOCON_t mcp_c1fifocon1 = {
        .bits = {
            .PLSIZE= 0b111, //64 byte payload
            .FSIZE= 0b00000, //one message only
            .TXAT= 0b00, //rx only
            .TXPRI= 0b00000, //rx only
            .FRESET= 0,
            .TXREQ= 0,
            .UINC = 0,
            .TXEN= 0,
            .RTREN= 0,
            .RXTSEN= 0,
            .TXATIE= 0,
            .RXOVIE= 0,
            .TFERFFIE= 0,
            .TFHRFHIE= 0,
            .TFNRFNIE= 0

        },
    };

    MCP_C1FLTCON_t mcp_c1fltcon = {
        .bits = {
            .FLTEN0= 0b1, //enable filter 0
            .F0BP=0b00001 //save hits in fifo 1
        }
    };

    MCP_C1CON_t mcp_c1con = {
        .bits = {
            .REQOP = 0b000  //request normal can-FD mode
        },
    };
    
    
    mcp_write_reg(MCP_REG_C1NBTCFG, mcp_c1nbtcfg.data_array);
    mcp_write_reg(MCP_REG_C1DBTCFG, mcp_c1dbtcfg.data_array);
    mcp_write_reg(MCP_REG_C1FIFOCON1, mcp_c1fifocon1.data_array);
    mcp_write_reg(MCP_REG_C1FLTCON0, mcp_c1fltcon.data_array);
    mcp_write_reg(MCP_REG_C1CON, mcp_c1con.data_array);

}