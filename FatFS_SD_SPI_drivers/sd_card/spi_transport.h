#pragma once

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#include "hardware/spi.h"

#define SPI_FILL_CHAR 0xff

typedef struct {
    spi_inst_t *hw_inst;
    uint miso_gpio;
    uint mosi_gpio;
    uint sck_gpio;
    uint baud_rate;
    bool initialized;
} spi_t;

void spi_transfer_start(spi_t *spi_p, const uint8_t *tx, uint8_t *rx, size_t length);
bool spi_transfer_wait_complete(spi_t *spi_p, uint32_t timeout_ms);
bool spi_transfer(spi_t *spi_p, const uint8_t *tx, uint8_t *rx, size_t length);
uint32_t calculate_transfer_time_ms(spi_t *spi_p, uint32_t bytes);
bool my_spi_init(spi_t *spi_p);
