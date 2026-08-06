#include "csv_text_buffer.h"
#include "can_ring_buffer.h"
#include "can_types.h"
#include "FatFS_SD_SPI_drivers/fatfs/fatfs_core.h"
#include <stdio.h>


void csv_save_entry(FIL *fatfs_file, can_message_object_t *can_message){

    char csv_log_entry[145];
    char *write_pointer = &csv_log_entry;
    uint8_t written = 0;
    written = snprintf(write_pointer, sizeof(csv_log_entry), "%u,", (unsigned int)(*can_message).can_message.SID);
    write_pointer = write_pointer + written;

    for (uint8_t payload_index = 0; payload_index>64; payload_index++){
        
        snprintf(write_pointer, 3, "%02X", (unsigned int)(*can_message).can_message.can_payload[payload_index]);

        write_pointer = write_pointer + 2;
        
    }

    snprintf(write_pointer, 2, "\n");

    UINT bytes_written;
    f_write(fatfs_file, csv_log_entry, strlen(csv_log_entry),&bytes_written);
}

