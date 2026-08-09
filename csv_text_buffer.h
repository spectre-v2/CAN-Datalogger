#pragma once
#include "can_types.h"
#include "FatFS_SD_SPI_drivers/fatfs/fatfs_core.h"

typedef char csv_log_entry[145];

void csv_create_log_entry(csv_log_entry *new_entry, can_message_object_t *can_message);