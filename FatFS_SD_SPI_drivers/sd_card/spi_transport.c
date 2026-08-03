#include "hardware/gpio.h"

#include "spi_transport.h"

void spi_transfer_start(spi_t *spi_p, const uint8_t *tx, uint8_t *rx, size_t length) {
    if (tx && rx) {
        spi_write_read_blocking(spi_p->hw_inst, tx, rx, length);
    } else if (tx) {
        spi_write_blocking(spi_p->hw_inst, tx, length);
    } else if (rx) {
        spi_read_blocking(spi_p->hw_inst, SPI_FILL_CHAR, rx, length);
    }
}

bool spi_transfer_wait_complete(spi_t *spi_p, uint32_t timeout_ms) {
    (void)spi_p;
    (void)timeout_ms;
    return true;
}

bool spi_transfer(spi_t *spi_p, const uint8_t *tx, uint8_t *rx, size_t length) {
    spi_transfer_start(spi_p, tx, rx, length);
    return true;
}

uint32_t calculate_transfer_time_ms(spi_t *spi_p, uint32_t bytes) {
    (void)spi_p;
    (void)bytes;
    return 0;
}

bool my_spi_init(spi_t *spi_p) {
    if (spi_p->initialized) return true;

    if (!spi_p->hw_inst) spi_p->hw_inst = spi0;
    if (!spi_p->baud_rate) spi_p->baud_rate = 20 * 1000 * 1000;

    spi_init(spi_p->hw_inst, 400 * 1000);
    spi_set_format(spi_p->hw_inst, 8, SPI_CPOL_0, SPI_CPHA_0, SPI_MSB_FIRST);
    gpio_set_function(spi_p->miso_gpio, GPIO_FUNC_SPI);
    gpio_set_function(spi_p->mosi_gpio, GPIO_FUNC_SPI);
    gpio_set_function(spi_p->sck_gpio, GPIO_FUNC_SPI);
    gpio_pull_up(spi_p->miso_gpio);
    spi_p->initialized = true;
    return true;
}
