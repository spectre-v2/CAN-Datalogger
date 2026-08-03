
#include "sd_card_timeouts.h"

sd_timeouts_t sd_timeouts __attribute__((weak)) = {
    .sd_command = 2000, // Timeout in ms for response
    .sd_command_retries = 3, // Times SPI cmd is retried when there is no response
    .sd_lock = 8000, // Timeout in ms for response
    .sd_spi_read = 1000, // Timeout in ms for response
    .sd_spi_write = 1000, // Timeout in ms for response
    .sd_spi_write_read = 1000, // Timeout in ms for response
    .spi_lock = 4000, // Timeout in ms for response
};
