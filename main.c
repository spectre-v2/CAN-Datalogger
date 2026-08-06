#include <hardware/gpio.h>
#include <stdio.h>
#include <stdbool.h>
#include "pico/stdlib.h"
#include "pico/multicore.h"
#include "hardware/spi.h"

#include "mcp2518.h"
#include "board.h"
#include "can_types.h"
#include "can_ring_buffer.h"
#include "fatfs_core.h"

volatile bool can0_pending = false;



void core1_entry(){

}

//docs:start:can0_irq
void can0_irq(uint gpio, uint32_t event_mask){
    can0_pending= 1;
}
//docs:end:can0_irq




//docs:start:can0_receive_callback
bool can0_callback(){
    printf("Entering CAN-0 recieve callback... \n");

    can0_pending = 0;

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


    }while(!gpio_get(pin_can0_irq));
    


    printf("done.\n");
}
//docs:end:can0_receive_callback


int main()
{
    stdio_init_all(); //starting USB controller
    multicore_launch_core1(core1_entry);

    while (!stdio_usb_connected()) { //wait for usb terminal connection
        sleep_ms(10);
    }

    //docs:start:can0_spi_setup
    // SPI initialisation
    spi_init(spi_port_can0, 20*1000*1000);
    spi_set_format(spi_port_can0, 8, SPI_CPOL_0, SPI_CPHA_0, SPI_MSB_FIRST);
    gpio_set_function(pin_can0_sck, GPIO_FUNC_SPI);
    gpio_set_function(pin_can0_tx, GPIO_FUNC_SPI);
    gpio_set_function(pin_can0_rx, GPIO_FUNC_SPI);
    gpio_set_function(pin_can0_cs, GPIO_FUNC_SIO);
    //chip select as active-low
    gpio_set_dir(pin_can0_cs, GPIO_OUT);
    gpio_put(pin_can0_cs, 1);
    //docs:end:can0_spi_setup

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


    // Initialize filesystem
    FATFS sd_card_file_system;
    FIL sd_card_logfile;
    UINT number_of_bytes_written;
    char sd_card_volume[] = "0:";
    char sd_card_logfile_path[] = "0:/log.csv";
    char sd_card_logfile_header[] = "timestamp, identifier, payload\r\n" ;

    // Connect FatFs to the SD card.
    f_mount(&sd_card_file_system, sd_card_volume, 1);

    // Open log.csv for writing
    f_open(&sd_card_logfile, sd_card_logfile_path, FA_OPEN_APPEND | FA_WRITE);
    f_write(&sd_card_logfile, sd_card_logfile_header, sizeof sd_card_logfile_header -1, &number_of_bytes_written);

    uint8_t i = 0;
    while(i<1000){
        if(can0_pending) {
            can0_callback();
            i++;
        }
    }


    /* Finish the file operation and detach the filesystem from the SD card. */
    f_close(&sd_card_logfile);
    f_unmount(sd_card_volume);

}
