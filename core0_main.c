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

datalogger_state_t datalogger_state = STATE_INIT;

int main()
{
    stdio_init_all(); 

    while (!stdio_usb_connected()) sleep_ms(10);

    while(1){
        switch(datalogger_state){


        case STATE_SLEEP:
            while(!gpio_get(pin_power_detect)) sleep_ms(100);
            datalogger_state = STATE_INIT;
            break;

        case STATE_INIT:
            mcu_hardware_init();

            //docs:start:can0_controller_start
            mcp_reset();
            mcp_init();
            //docs:end:can0_controller_start

            multicore_launch_core1(core1_entry);

            datalogger_state = STATE_LOGGING;

            break;


        case STATE_LOGGING:
            while(can0_pending) can0_callback;
            break;
            
        case STATE_SAVE:
            
    }
    }

}
