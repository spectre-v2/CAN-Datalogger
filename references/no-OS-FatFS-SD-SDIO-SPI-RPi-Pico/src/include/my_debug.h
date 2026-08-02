#pragma once

#include <stddef.h>
#include <stdint.h>

#define EMSG_PRINTF(...) ((void)0)
#define DBG_PRINTF(...) ((void)0)
#define IMSG_PRINTF(...) ((void)0)

#define myASSERT(__e) ((void)0)
#define ASSERT_ALWAYS(__e) ((void)0)
#define ASSERT_CASE_IS(__v, __e) ((void)0)
#define ASSERT_CASE_NOT(__v) ((void)0)
#define DBG_ASSERT_CASE_NOT(__v) ((void)0)

static inline void dump_bytes(size_t num, uint8_t bytes[]) {
    (void)num;
    (void)bytes;
}
