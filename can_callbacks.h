#pragma once

#include <stdbool.h>

extern volatile bool can0_pending;

void can0_irq();

bool can0_callback();
