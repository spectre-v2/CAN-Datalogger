#include "can_ring_buffer.h"

// Ring buffer for CAN messages.
static can_message_object_t can_ring[CAN_RING_SIZE];
static uint32_t can_ring_read_index = 0;
static uint32_t can_ring_write_index = 0;
uint32_t can_ring_count = 0;

void can_ring_save(const can_message_object_t *new_entry){
    can_ring[can_ring_write_index]= *new_entry;
    can_ring_write_index ++;
    if(can_ring_write_index >= CAN_RING_SIZE) can_ring_write_index = 0;
    can_ring_count ++;
}

void can_ring_fetch(can_message_object_t *get_entry){
    *get_entry = can_ring[can_ring_read_index];
    can_ring_read_index ++;
    if(can_ring_read_index >= CAN_RING_SIZE) can_ring_read_index = 0;
    can_ring_count --;
}
