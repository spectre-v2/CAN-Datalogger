#include "can_callbacks.h"

// C standard library
#include <stdio.h>
#include <stdint.h>

// Raspberry Pi Pico SDK
#include <hardware/gpio.h>

// Project modules
#include "mcu_hardware_config.h"
#include "mcp2518.h"
#include "can_ring_buffer.h"
#include "statemachine.h"

//docs:start:can0_receive_callback
bool can0_mcp_fetch_data(){
    printf("Entering CAN-0 recieve callback... \n");

    

    uint32_t tmp_offset;
    can_message_object_t tmp_can_message_buffer;

    do {
        //Retrieve the address offset of the recieved CAN-Message stored in message ram from C1FIFOUA1
        mcp_read(MCP_REG_ADR_C1FIFOUA1, &tmp_offset, sizeof tmp_offset);

        //Read this message address and write into temp. message buffer.
        mcp_read(tmp_offset + MCP_RAM_BASE, tmp_can_message_buffer.data_array, sizeof tmp_can_message_buffer.data_array);

        //save message in ringbuffer
        can_ring_save(&tmp_can_message_buffer);

        //set UINC bit in C1FIFOCON1 to prompt load operation of next message offset into C1FIFOUA1
        MCP_REG_C1FIFOCON_t tmp_c1fifocon;
        mcp_read(MCP_REG_ADR_C1FIFOCON1, tmp_c1fifocon.data_array, sizeof tmp_c1fifocon.data_array);
        tmp_c1fifocon.bits.UINC= 1;
        mcp_write(MCP_REG_ADR_C1FIFOCON1, tmp_c1fifocon.data_array, sizeof tmp_c1fifocon.data_array);


    }while(gpio_get(pin_can0_irq));
    
    printf("done.\n");
}
//docs:end:can0_receive_callback
