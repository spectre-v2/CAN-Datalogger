#pragma once
#include <stdatomic.h>

typedef struct{
    system_state_t system_state;
    sd_state_t sd_card_state;
    mcp_state_t mcp_state;
    ext_power_state_t ext_power_state;
}datalogger_state_t;


typedef enum {
    SYSTEM_OFF_S,
    SYSTEM_STARTING_S,
    SYSEM_RUNNING_S,
    SYSTEM_STOPPING_S
}system_state_t;

typedef enum {
    SD_ACTIVE_S = 1,
    SD_IDLE_S = 0
}sd_state_t;

typedef enum{
    MCP_PENDING_S = 1,
    MCP_IDLE_S = 0
}mcp_state_t;

typedef enum{
    EXT_POWER_ON_S = 1,
    EXT_POWER_OFF_S = 0
}ext_power_state_t





extern datalogger_state_t datalogger_state;
