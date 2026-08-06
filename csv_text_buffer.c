#include "csv_text_buffer.h"
#include "can_ring_buffer.h"
#include "can_types.h"
#include "FatFS_SD_SPI_drivers/fatfs/fatfs_core.h"
#include <stdio.h>


void csv_entry_create(can_message_object_t *can_message, csv_log_entry_t *new_csv_entry){

    snprintf(
        (*new_csv_entry).can_id, 
        sizeof((*new_csv_entry).can_id),
        "%u",
        (unsigned int)(*can_message).can_message.SID
    );
    char *char_write_pos = (*new_csv_entry).payload;
    for(uint8_t payload_index=0; payload_index<64; payload_index++){
        snprintf(
            char_write_pos,
            3,  //zwei stellen hex plus delimiter
            "%02X",
            (unsigned int)(*can_message).can_message.can_payload[payload_index]
        );
        char_write_pos = char_write_pos +2;
   }
}

void csv_entry_save(FIL *fatfs_file, csv_log_entry_t *csv_log_entry){
        uint8_t bytes_written;
        char log_entry[142];

        snprintf(
            &log_entry,
            sizeof(log_entry),
            "%s,%s\n",
            csv_log_entry->can_id,
            csv_log_entry->payload
        );
        f_write(&fatfs_file, log_entry, strlen(log_entry), &bytes_written);

}



