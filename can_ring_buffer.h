#pragma once

#include <stdint.h>

#include "can_types.h"

#define CAN_RING_SIZE 3600 //half of rp2350- ram for ringbuffer

void can_ring_save(const can_message_object_t *message);
void can_ring_fetch(can_message_object_t *message);
uint32_t can_ring_get_count(void);
