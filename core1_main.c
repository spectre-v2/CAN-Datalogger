#include "core1_main.h"

// Raspberry Pi Pico SDK
#include <hardware/gpio.h>

// Project modules
#include "mcu_hardware_config.h"
#include "can_ring_buffer.h"
#include "csv_text_buffer.h"
#include "fatfs_core.h"
#include "statemachine.h"

void core1_entry(){

    // Initialize filesystem
    FATFS sd_card_file_system;
    FIL sd_card_logfile;
    UINT bytes_written;
    char sd_card_volume[] = "0:";
    char sd_card_logfile_path[] = "0:/log.csv";
    char sd_card_logfile_header[] = "identifier, payload\r\n" ;


    can_message_object_t save_buffer;


    while(1){

        switch(datalogger_state.system_state){


            case SYSTEM_OFF_S:
            
            break;

            case SYSTEM_STARTING_S:
                // Connect FatFs to the SD card.
                f_mount(&sd_card_file_system, sd_card_volume, 1);

                // Open log.csv for writing
                f_open(&sd_card_logfile, sd_card_logfile_path, FA_OPEN_APPEND | FA_WRITE);
                f_write(&sd_card_logfile, sd_card_logfile_header, sizeof sd_card_logfile_header -1, &bytes_written);
                datalogger_state.sd_state = SD_ACTIVE_S;
            break;


            case SYSTEM_RUNNING_S:
                while(can_ring_fetch(&save_buffer)) csv_save_entry(&sd_card_logfile, &save_buffer);
            break;

            case SYSTEM_STOPPING_S:
                /* Finish the file operation and detach the filesystem from the SD card. */
                while(can_ring_fetch(&save_buffer)) csv_save_entry(&sd_card_logfile, &save_buffer);

                f_sync(&sd_card_logfile);
                f_close(&sd_card_logfile);
                f_unmount(sd_card_volume);
                datalogger_state.sd_state = SD_IDLE_S;


            break;

        }

        
    }
}
