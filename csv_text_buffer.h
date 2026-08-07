#pragma once
#include "can_types.h"
#include "FatFS_SD_SPI_drivers/fatfs/fatfs_core.h"


void csv_save_entry(FIL *fatfs_file, can_message_object_t *can_message);