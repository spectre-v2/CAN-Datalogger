#pragma once

#include "hardware/spi.h"

#define spi_port_can0 spi0

#define spi_port_sd spi1

#define spi_port_can0_speed (2 * 1000 * 1000)
#define spi_port_sd_speed (2 * 1000* 1000) 

#define pin_power_detect 22

#define pin_can0_cs 1   //blue
#define pin_can0_sck 2  //white
#define pin_can0_tx 3   //yellow
#define pin_can0_rx 4   //green
#define pin_can0_irq 5  //orange

#define pin_sd_cs 13    //blue
#define pin_sd_sck  10  //white
#define pin_sd_tx 11    //yellow
#define pin_sd_rx 12    //green


#define pin_pico2_led 25


void mcu_hardware_init();

