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


datalogger_state_t datalogger_state {
    .system_state   = SYSTEM_OFF_S,
    .sd_state       = SD_IDLE_S,
    .mcp_state      = MCP_IDLE_S,
    .ext_power_state= EXT_POWER_OFF_S
};


int main()
{
    stdio_init_all(); 

    while (!stdio_usb_connected()) sleep_ms(100);


    while(1){

        //updating system state with external signals.
        if (gpio_get(pin_power_detect)) datalogger_state.ext_power_state = EXT_POWER_ON_S else datalogger_state.ext_power_state = EXT_POWER_OFF_S;
        if (gpio_get(pin_can0_irq)) datalogger_state.mcp_state = MCP_PENDING_S else datalogger_state.mcp_state = MCP_IDLE_S;

        switch(datalogger_state.system_state){

        case SYSTEM_OFF_S:
            //todo: low power functionality
            datalogger_state.system_state = SYSTEM_ON_S;
            break;

        case SYSTEM_STARTING_S:

            mcu_hardware_init();
            //docs:start:can0_controller_start
            mcp_reset();
            mcp_init();
            //docs:end:can0_controller_start
            multicore_launch_core1(core1_entry);

            datalogger_state.system_state = SYSTEM_RUNNING_S;

            break;

        case SYSTEM_RUNNING_S:
            if(datalogger_state.mcp_state==MCP_PENDING_S) can0_callback;
            if(datalogger_state.ext_power_state == EXT_POWER_OFF_S) datalogger_state.system_state = SYSTEM_STOPPING_S;

            break;
            
        case SYSTEM_STOPPING_S:
            while(datalogger_state.mcp_state==MCP_PENDING_S) can0_callback;
            if (datalogger_state.sd_state == SD_IDLE ) datalogger_state.system_state = SYSTEM_OFF_S;

            break;
            
        }
    }

}
