#include "core1_main.h"

// Raspberry Pi Pico SDK
#include <hardware/gpio.h>

// Project modules

#include "statemachine.h"
#include "sd_card_interface.h"
#include "debug.h"


//docs:start:core1-loop
void core1_entry(){
    while(1){
        switch(datalogger_state.system_state){

            case SYSTEM_OFF_S:
            break;

            case SYSTEM_STARTING_S:

                if(datalogger_state.sd_state == SD_MOUNTING_S){
                    sd_mount();
                    datalogger_state.sd_state = SD_READY_S;
                }     
            break;

            case SYSTEM_RUNNING_S:
                sd_save_continuous();
            break;

            case SYSTEM_STOPPING_S:
                if(datalogger_state.sd_state == SD_READY_S){
                    sd_save_unmount();
                    datalogger_state.sd_state = SD_IDLE_S;
                }
            break;

        }
    }
}
//docs:end:core1-loop
