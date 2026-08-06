#pragma once

#include <stdbool.h>
#include <stdint.h>
#include <stdatomic.h>

#include "can_types.h"
//docs:start:can_ring_size
#define CAN_RING_SIZE 3600 //half of rp2350- ram for ringbuffer
//docs:end:can_ring_size

extern _Atomic uint32_t can_ring_count;

bool can_ring_save(const can_message_object_t *new_entry);
bool can_ring_fetch(can_message_object_t *fetched_entry);
