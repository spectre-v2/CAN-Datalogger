#pragma once

#include <stdint.h>

#include "can_types.h"

#define CAN_RING_SIZE 3600 //half of rp2350- ram for ringbuffer

extern uint32_t can_ring_count;

void can_ring_save(const can_message_object_t *new_entry);
void can_ring_fetch(can_message_object_t *fetched_entry);
