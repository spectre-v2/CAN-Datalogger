#pragma once

typedef enum {
    STATE_SLEEP,
    STATE_INIT,
    STATE_LOGGING,
    STATE_SAVE
}datalogger_state_t;

extern datalogger_state_t datalogger_state;