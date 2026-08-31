#include <stdint.h>

// Raspberry Pi Pico SDK
#include <hardware/gpio.h>
#include <hardware/spi.h>
#include "pico/stdlib.h"
#include "pico/multicore.h"
#include "pico/low_power.h"

// Project modules
#include "mcu_hardware_config.h"
#include "core1_main.h"
#include "mcp2518.h"
#include "statemachine.h"




//docs:start:start-states
datalogger_state_t datalogger_state = {
    .system_state   = SYSTEM_OFF_S,
    .sd_state       = SD_IDLE_S,
    .mcp_state      = MCP_IDLE_S,
    .ext_power_state= EXT_POWER_OFF_S
};
//docs:end:start-states

//docs:start:update-statemachine
void update_statemachine_inputs(){
        //updating system state with external signals.
        if (gpio_get(pin_power_detect)) datalogger_state.ext_power_state = EXT_POWER_ON_S;
        else datalogger_state.ext_power_state = EXT_POWER_OFF_S;

        if (!gpio_get(pin_can0_irq)) datalogger_state.mcp_state = MCP_PENDING_S;
        else datalogger_state.mcp_state = MCP_IDLE_S;
}
//docs:end:update-statemachine

int main()
{
    stdio_init_all(); 
    mcu_hardware_init();

    //while (!stdio_usb_connected()) sleep_ms(100);
    //docs:start:core0-loop
    while(1){

        update_statemachine_inputs();

        switch(datalogger_state.system_state){

        case SYSTEM_OFF_S:

           // low_power_dormant_until_gpio_pin_state(pin_power_detect, true, true, DORMANT_CLOCK_SOURCE_ROSC,NULL);

            if(datalogger_state.ext_power_state == EXT_POWER_ON_S){ 
            datalogger_state.system_state = SYSTEM_STARTING_S;
            }

            break;

        case SYSTEM_STARTING_S:

            if(datalogger_state.sd_state == SD_IDLE_S){ 
                mcu_hardware_init();
                mcp_init();
                multicore_launch_core1(core1_entry);
                datalogger_state.sd_state = SD_MOUNTING_S;
            }
            //waiting for core1 to start up the SD.
            if(datalogger_state.sd_state == SD_READY_S) {
            datalogger_state.system_state = SYSTEM_RUNNING_S;
            }

            break;

        case SYSTEM_RUNNING_S:

            if(datalogger_state.mcp_state==MCP_PENDING_S) {
                mcp_fetch_data();
                datalogger_state.mcp_state= MCP_IDLE_S;
            }
   
            if(datalogger_state.ext_power_state == EXT_POWER_OFF_S) {
                datalogger_state.system_state = SYSTEM_STOPPING_S;
            }

        break;
            
        case SYSTEM_STOPPING_S:

            if(datalogger_state.mcp_state==MCP_PENDING_S) {
                mcp_fetch_data();
            }

            if (datalogger_state.sd_state == SD_IDLE_S && datalogger_state.mcp_state != MCP_PENDING_S) {
                multicore_reset_core1();
                datalogger_state.system_state= SYSTEM_OFF_S;
            } ;
        break;
            
        }

    }
//docs:end:core0-loop
}
