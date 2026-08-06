#pragma once
#include "can_types.h"


typedef struct {
    char can_id[11];
    char payload[129];

}csv_log_entry_t;

void csv_entry_create(can_message_object_t *can_message, csv_log_entry_t *csv_entry);


