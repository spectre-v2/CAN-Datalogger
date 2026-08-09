#include "csv_text_buffer.h"

// C standard library
#include <stdio.h>
#include <string.h>



void csv_create_log_entry(csv_log_entry new_entry, can_message_object_t *can_message_ptr){

    uint8_t written = 0;
    written = snprintf(new_entry, sizeof(csv_log_entry), "%u,", (unsigned int)(*can_message_ptr).can_message.SID);
    new_entry = new_entry + written;

    for (uint8_t payload_index = 0; payload_index<64; payload_index++){
        
        snprintf(new_entry, 3, "%02X", (unsigned int)(*can_message_ptr).can_message.can_payload[payload_index]);

        new_entry = new_entry + 2;
        
    }

    snprintf(new_entry, 2, "\n");

}
