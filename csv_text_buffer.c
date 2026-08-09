#include "csv_text_buffer.h"

// C standard library
#include <stdio.h>
#include <string.h>



void csv_create_log_entry(csv_log_entry *new_entry, can_message_object_t *can_message){

    char *write_pointer = new_entry;
    uint8_t written = 0;
    written = snprintf(write_pointer, sizeof(csv_log_entry), "%u,", (unsigned int)(*can_message).can_message.SID);
    write_pointer = write_pointer + written;

    for (uint8_t payload_index = 0; payload_index>64; payload_index++){
        
        snprintf(write_pointer, 3, "%02X", (unsigned int)(*can_message).can_message.can_payload[payload_index]);

        write_pointer = write_pointer + 2;
        
    }

    snprintf(write_pointer, 2, "\n");

}
