#include <hardware/gpio.h>
#include <stdio.h>
#include "pico/stdlib.h"
#include "hardware/spi.h"
#include "hardware/dma.h"

#include "mcp.h"
#include "main.h"

volatile bool mcp0_pending = false;

//docs:start:can0_irq_handler
void can0_irq(uint gpio, uint32_t event_mask){
        printf("Entering CAN-0 interrupt service routine...\n");
    mcp0_pending= 1;
}
//docs:end:can0_irq_handler

//docs:start:can0_receive_callback
void can0_callback(){
    printf("Entering CAN-0 recieve callback... \n");

    //Retrieve the address offset of the recieved CAN-Message stored in message ram from C1FIFOUA1
    uint32_t offset_tmp = 0;
    mcp_read_reg(MCP_REG_C1FIFOUA1, &offset_tmp, sizeof offset_tmp);

    //Read this message address and write into CAN-FD message buffer.
    can_message_object_t can_rx_buffer;
    mcp_read_reg(offset_tmp + MCP_RAM_BASE, can_rx_buffer.data_array, sizeof can_rx_buffer.data_array);

    //set UINC bit in C1FIFOCON1 to prompt load operation of next message offset into C1FIFOUA1
    MCP_C1FIFOCON_t c1fifcon1_tmp;
    mcp_read_reg(MCP_REG_C1FIFOCON1, c1fifcon1_tmp.data_array, sizeof c1fifcon1_tmp.data_array);
    c1fifcon1_tmp.bits.UINC= 1;
    mcp_write_reg(MCP_REG_C1FIFOCON1, c1fifcon1_tmp.data_array, sizeof c1fifcon1_tmp.data_array);

    //reset pending flag
    mcp0_pending = 0;
    printf("done.\n");

    printf("Recieved message ID: %X\n", can_rx_buffer.can_message.SID);
    printf("Recieved message payload byte 0: %X\n", can_rx_buffer.can_message.can_payload[0]);
    printf("Recieved message payload byte 1: %X\n", can_rx_buffer.can_message.can_payload[1]);
    printf("Recieved message payload byte 2: %X\n", can_rx_buffer.can_message.can_payload[2]);
    printf("Recieved message payload byte 3: %X\n", can_rx_buffer.can_message.can_payload[3]);
}
//docs:end:can0_receive_callback

int main()
{
    stdio_init_all(); //starting USB controller

    while (!stdio_usb_connected()) { //wait for usb terminal connection
        sleep_ms(10);
    }

    //docs:start:can0_spi_setup
    // SPI initialisation
    spi_init(spi_port_can0, 1000*1000);
    spi_set_format(spi_port_can0, 8, SPI_CPOL_0, SPI_CPHA_0, SPI_MSB_FIRST);
    gpio_set_function(pin_can0_sck, GPIO_FUNC_SPI);
    gpio_set_function(pin_can0_tx, GPIO_FUNC_SPI);
    gpio_set_function(pin_can0_rx, GPIO_FUNC_SPI);
    gpio_set_function(pin_can0_cs, GPIO_FUNC_SIO);
    //chip select as active-low
    gpio_set_dir(pin_can0_cs, GPIO_OUT);
    gpio_put(pin_can0_cs, 1);
    //docs:end:can0_spi_setup

    uint dma_channel_spi_rx = dma_claim_unused_channel(true);
    uint dma_channel_spi_tx = dma_claim_unused_channel(true);

    //pico2 led for debugging
    gpio_set_function(pin_pico2_led, GPIO_FUNC_SIO);
    gpio_set_dir(pin_pico2_led, GPIO_OUT);
    

    //docs:start:can0_controller_start
    mcp_reset();
    sleep_ms(5);
    mcp_init();
    sleep_ms(5);

        
        
    //docs:end:can0_controller_start

    //docs:start:can0_irq_setup
    //interrupt from can0 controller
    gpio_set_function(pin_can0_irq, GPIO_FUNC_SIO);
    gpio_set_dir(pin_can0_irq, GPIO_IN);
    gpio_pull_up(pin_can0_irq);
    gpio_set_irq_enabled_with_callback(pin_can0_irq, GPIO_IRQ_EDGE_FALL, true, can0_irq);
    //docs:end:can0_irq_setup
    
    //task scheduler
    //docs:start:can0_scheduler
    while(1){
        if(mcp0_pending) can0_callback();
    }
    
    //docs:end:can0_scheduler
        
    
}
