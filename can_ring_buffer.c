#include "can_ring_buffer.h"
#include "debug.h"

//docs:start:can_ring
// Ring buffer for CAN messages.
can_frame_t can_ring[CAN_RING_SIZE];
_Atomic uint32_t can_ring_read_index = 0;
_Atomic uint32_t can_ring_write_index = 0;
_Atomic uint32_t can_ring_count = 0;

//docs:start:ringbuffer-store
bool can_ring_store(const can_frame_t *new_entry){
    debugmsg("can-ring", "Saving message to ring buffer...");

    uint32_t read_index = atomic_load(&can_ring_read_index);
    uint32_t write_index = atomic_load(&can_ring_write_index);
    uint32_t next_write_index = write_index + 1;
    
    if(next_write_index == CAN_RING_SIZE) next_write_index = 0; 

    if(next_write_index == read_index) return false;    
   
    can_ring[write_index]= *new_entry;

    atomic_store(&can_ring_write_index, next_write_index);

    atomic_fetch_add(&can_ring_count, 1);
    return true;
}
//docs:end:ringbuffer-store

//docs:start:ringbuffer-fetch
bool can_ring_fetch(can_frame_t *fetched_entry){
    debugmsg("can-ring", "Fetching message from ring buffer...");

    uint32_t read_index = atomic_load(&can_ring_read_index);
    uint32_t write_index = atomic_load(&can_ring_write_index);
    uint32_t next_read_index = read_index + 1;

    if(read_index == write_index) return false; //buffer empty

    *fetched_entry = can_ring[read_index];

    if(next_read_index == CAN_RING_SIZE) next_read_index = 0;

    atomic_store(&can_ring_read_index, next_read_index);

   atomic_fetch_sub(&can_ring_count,1);

   return true;
}
//docs:end:ringbuffer-fetch
