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

void mcp_write(uint16_t address, uint8_t *tx_buffer, size_t length){
    uint8_t command[2];
    command[0]=MCP_COMMAND_WRITE | (address >>8);
    command[1]=address & 0b000011111111;
    gpio_put(PIN_CS, 0);
    spi_write_blocking(SPI_PORT, command, 2);
    gpio_put(PIN_CS, 1);
}

void mcp_read(uint16_t address,uint8_t *rx_buffer,size_t length){

    uint8_t command[2];

    command[0]= MCP_COMMAND_READ | (address>>8);    //4 command bits + first 4 address bits
    command[1]= address & 0b000011111111;   //last 8 adress bits

    gpio_put(PIN_CS, 0);
    spi_write_blocking(SPI_PORT, command, 2);   //send 2 entries of command array
    spi_read_blocking(SPI_PORT, 0b00000000, rx_buffer, length); //send empty bytes and write recieved data in buffer
    gpio_put(PIN_CS, 1);
}