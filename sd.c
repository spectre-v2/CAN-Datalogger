#include "board.h"

static spi_t sd_spi = {
    .hw_inst = spi_port_sd,
    .sck_gpio = pin_sd_sck,
    .mosi_gpio = pin_sd_gpio,
    .baud_rate = 20*1000*1000 //20Mhz 
}

static sd_spi_if_t spi_if = {
    .spi = &sd_spi,
    .ss_gpio = pin_sd_cs
}

static sd_card_t sd_card = {
    .type = SD_IF_SPI,
    .spi_if_p = &spi_if
}

size_t sd_get_num(void) {
    return 1;
}

sd_card_t *sd_get_by_num(size_t num) {
    if (num == 0) return &sd_card;
    return NULL;
}