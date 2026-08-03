#pragma once

#include <stdbool.h>
#include <stdint.h>

uint8_t sd_card_status(void);
uint8_t sd_card_init(void);
bool sd_card_read_blocks(uint8_t *buffer, uint32_t sector, uint32_t count);
bool sd_card_write_blocks(const uint8_t *buffer, uint32_t sector, uint32_t count);
bool sd_card_sync(void);
uint32_t sd_card_sector_count(void);
