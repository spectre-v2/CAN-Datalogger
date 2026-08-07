#pragma once
#include <stdatomic.h>

typedef enum {
    STATE_OFF,
    STATE_STARTING,
    STATE_RUNNING,
    STATE_STOPPING
}datalogger_state_t;

extern datalogger_state_t datalogger_state;

extern _Atomic bool external_power_on;

