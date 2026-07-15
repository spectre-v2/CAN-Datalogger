#include <stdio.h>
#include "pico/stdlib.h"
#include "hardware/spi.h"
#include "mcp.h"
#include "main.h"

MCP_DEVID_t mcp_devid = {0};




void can0_callback(uint gpio, uint32_t event_mask){
    printf("Entering CAN-0 interrupt service routine");

    
}


int main()
{
    stdio_init_all(); //starting USB controller

    while (!stdio_usb_connected()) { //wait for usb terminal connection
        sleep_ms(10);
    }

    //docs:start:can0_spi_setup
    // SPI initialisation
    spi_init(spi_port_can0, 1000 * 1000);
    gpio_set_function(pin_can0_sck, GPIO_FUNC_SPI);
    gpio_set_function(pin_can0_tx, GPIO_FUNC_SPI);
    gpio_set_function(pin_can0_rx, GPIO_FUNC_SPI);
    gpio_set_function(pin_can0_cs, GPIO_FUNC_SIO);
    //chip select as active-low
    gpio_set_dir(pin_can0_cs, GPIO_OUT);
    gpio_put(pin_can0_cs, 1);
    //docs:end:can0_spi_setup

    //pico2 led for debugging
    gpio_set_function(pin_pico2_led, GPIO_FUNC_SIO);
    gpio_set_dir(pin_pico2_led, GPIO_OUT);
    
   //interrupt from can0 controller
    gpio_set_function(pin_can0_irq, GPIO_FUNC_SIO);
    gpio_set_dir(pin_can0_irq, GPIO_IN);
    gpio_pull_up(pin_can0_irq);
    gpio_set_irq_callback(can0_callback);
    gpio_set_irq_enabled(pin_can0_irq, GPIO_IRQ_LEVEL_LOW, 1);
    
    //docs:start:can0_controller_start
    mcp_reset();
    sleep_ms(10);
    mcp_init();
    mcp_read_reg(MCP_REG_DEVID, mcp_devid.data_array, sizeof mcp_devid.data_array);
    //docs:end:can0_controller_start


    
    while (true) {
            

        printf("MCP DEVICE ID: 0x%02X\n", mcp_devid.bits.ID);
        gpio_put(pin_pico2_led, 1);

        sleep_ms(1000);
        gpio_put(pin_pico2_led, 0);
        sleep_ms(1000);
        
        
    }
}
