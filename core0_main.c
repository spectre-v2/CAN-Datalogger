// C standard library
#include <stdio.h>
#include <stdint.h>

// Raspberry Pi Pico SDK
#include <hardware/gpio.h>
#include <hardware/spi.h>
#include "pico/stdlib.h"
#include "pico/multicore.h"

// Project modules
#include "mcu_hardware_config.h"
#include "can_callbacks.h"
#include "core1_main.h"
#include "mcp2518.h"
#include "statemachine.h"

datalogger_state_t datalogger_state = STATE_OFF;



int main()
{
    stdio_init_all(); 

    while (!stdio_usb_connected()) sleep_ms(100);

    while(1){

        external_power_on = gpio_get(pin_power_detect);
        can0_pending = gpio_get(pin_can0_irq);

        switch(datalogger_state){

        case STATE_OFF:
            if(external_power_on) datalogger_state = STATE_STARTING;
            break;

        case STATE_STARTING:

            mcu_hardware_init();
            //docs:start:can0_controller_start
            mcp_reset();
            mcp_init();
            //docs:end:can0_controller_start
            multicore_launch_core1(core1_entry);

            datalogger_state = STATE_RUNNING;

            break;


        case STATE_RUNNING:
            if(can0_pending) can0_callback;
            if(!external_power_on) datalogger_state = STATE_STOPPING;

            break;
            
        case STATE_STOPPING:
            if(can0_pending) can0_callback;
            
            
    }
    }

}
