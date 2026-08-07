#pragma once

#include <stdbool.h>

extern volatile bool can0_pending;

bool can0_callback();
