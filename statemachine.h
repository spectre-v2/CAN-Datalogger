#pragma once
#include <stdatomic.h>

typedef enum {
    SYSTEM_OFF_S,
    SYSTEM_STARTING_S,
    SYSTEM_RUNNING_S,
    SYSTEM_STOPPING_S
}system_state_t;

typedef enum { //owned by core 1!
    SD_IDLE_S,
    SD_MOUNTING_S,
    SD_READY_S

}sd_state_t;

typedef enum{
    MCP_IDLE_S = 0,
    MCP_PENDING_S = 1
}mcp_state_t;

typedef enum{
    EXT_POWER_OFF_S = 0,
    EXT_POWER_ON_S = 1
}ext_power_state_t;

typedef struct{
    _Atomic system_state_t system_state;
    _Atomic sd_state_t sd_state;
    _Atomic mcp_state_t mcp_state;
    _Atomic ext_power_state_t ext_power_state;
}datalogger_state_t;




extern datalogger_state_t datalogger_state;
