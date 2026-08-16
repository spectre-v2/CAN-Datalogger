// C standard library
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

#include <hardware/gpio.h>

#include "fatfs_core.h"
#include "mcu_hardware_config.h"
#include "can_ring_buffer.h"
#include "csv_converter.h"
#include "debug.h"


// Initialize filesystem
FATFS sd_card_filesystem;
FIL sd_card_logfile;
UINT fatfs_bytes_written;

csv_log_entry_t new_csv_entry_buffer;
can_frame_t can_message_buffer;


char sd_card_volume[] = "0:";
char sd_card_logfile_path[] = "0:/log.csv";
char sd_card_logfile_header[] = "identifier, payload\r\n" ;

void sd_mount(){
    debugmsg("sd-interface", "Mounting SD card...");
    // Connect FatFs to the SD card.
    FRESULT mount = f_mount(&sd_card_filesystem, sd_card_volume, 1);
    gpio_put(pin_pico2_led, 1);  // nur: f_mount ist zurückgekehrt

    debugmsg("sd-interface", "mounted: %d", (int)mount);
    // Open log.csv for writing
    FRESULT open = f_open(&sd_card_logfile, sd_card_logfile_path, FA_OPEN_APPEND | FA_WRITE);
    debugmsg("sd-interface%d", "mounted: %d",(int)open);
    // write header
    FRESULT write_header = f_write(&sd_card_logfile, sd_card_logfile_header, sizeof sd_card_logfile_header -1, &fatfs_bytes_written);
    debugmsg("sd-interface%d", "mounted: %d", (int)write_header);
}

void sd_save_unmount(){
    debugmsg("sd-interface", "Unmounting SD card...");
    // Finish the file operation and detach the filesystem from the SD card.

    while(can_ring_fetch(&can_message_buffer)){

        csv_create_log_entry(new_csv_entry_buffer, &can_message_buffer);
        f_write(&sd_card_logfile, new_csv_entry_buffer, strlen(new_csv_entry_buffer),&fatfs_bytes_written);
    } 

    f_sync(&sd_card_logfile);
    f_close(&sd_card_logfile);
    f_unmount(sd_card_volume);
}

void sd_save_continuous(){
    debugmsg("sd-interface", "Saving data to SD card...");
    
    while(can_ring_fetch(&can_message_buffer)) {
        csv_create_log_entry(new_csv_entry_buffer, &can_message_buffer);

        f_write(&sd_card_logfile, new_csv_entry_buffer, strlen(new_csv_entry_buffer),&fatfs_bytes_written);
    }
}
