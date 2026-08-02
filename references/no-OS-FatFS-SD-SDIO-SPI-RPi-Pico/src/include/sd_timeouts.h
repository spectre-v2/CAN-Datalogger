
#pragma once

#include <stdint.h>

typedef struct {
    uint32_t sd_command;
    unsigned sd_command_retries;
    unsigned sd_lock;
    unsigned sd_spi_read;
    unsigned sd_spi_write;
    unsigned sd_spi_write_read;
    unsigned spi_lock;
} sd_timeouts_t;

extern sd_timeouts_t sd_timeouts;
