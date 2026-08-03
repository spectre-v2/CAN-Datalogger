#pragma once

#include <stdint.h>
//
#include "pico.h"
#include "pico/stdlib.h"

static inline uint32_t millis() {
    __compiler_memory_barrier();
    return time_us_64() / 1000;
    __compiler_memory_barrier();
}

static inline uint64_t micros() {
    __compiler_memory_barrier();
    return to_us_since_boot(get_absolute_time());
    __compiler_memory_barrier();
}
