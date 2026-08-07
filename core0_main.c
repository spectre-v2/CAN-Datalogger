// C standard library
#include <stdio.h>
#include <stdint.h>

// Raspberry Pi Pico SDK
#include <hardware/gpio.h>
#include <hardware/spi.h>
#include "pico/stdlib.h"
#include "pico/multicore.h"

// Project modules
#include "board.h"
#include "can_callbacks.h"
#include "core1_main.h"
#include "mcp2518.h"


//docs:start:can0_irq
void can0_irq(uint gpio, uint32_t event_mask){
    can0_pending= 1;
}
//docs:end:can0_irq


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
    mcp_init();
    //docs:end:can0_controller_start

    //docs:start:can0_irq_setup
    //interrupt from can0 controller
    gpio_set_function(pin_can0_irq, GPIO_FUNC_SIO);
    gpio_set_dir(pin_can0_irq, GPIO_IN);
    gpio_pull_up(pin_can0_irq);
    gpio_set_irq_enabled_with_callback(pin_can0_irq, GPIO_IRQ_EDGE_FALL, true, can0_irq);
    //docs:end:can0_irq_setup


    gpio_set_function(pin_power_detect, GPIO_FUNC_SIO);
    gpio_set_dir(pin_power_detect, GPIO_IN);
    gpio_pull_down(pin_power_detect);
    gpio_set_input_hysteresis_enabled(pin_power_detect, true);


    while(gpio_get(pin_power_detect)){
        if(can0_pending) {
            can0_callback();
        }
    }
}
