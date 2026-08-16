#pragma once
#include "can_types.h"
#include "FatFS_SD_SPI_drivers/fatfs/fatfs_core.h"

typedef char csv_log_entry_t[145];

void csv_create_log_entry(csv_log_entry_t new_entry, can_frame_t *can_message);