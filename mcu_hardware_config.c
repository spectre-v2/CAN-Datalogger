  // Raspberry Pi Pico SDK
#include <hardware/gpio.h>
#include <hardware/spi.h>
#include "pico/stdlib.h"
#include "pico/multicore.h"

#include "mcu_hardware_config.h"
#include "can_callbacks.h"
  
void mcu_hardware_init(){

  //docs:start:can0_spi_setup
    // SPI initialisation
    spi_init(spi_port_can0, spi_port_can0_speed);
    spi_set_format(spi_port_can0, 8, SPI_CPOL_0, SPI_CPHA_0, SPI_MSB_FIRST);
    gpio_set_function(pin_can0_sck, GPIO_FUNC_SPI);
    gpio_set_function(pin_can0_tx, GPIO_FUNC_SPI);
    gpio_set_function(pin_can0_rx, GPIO_FUNC_SPI);
    gpio_set_function(pin_can0_cs, GPIO_FUNC_SIO);
    //chip select as active-low
    gpio_set_dir(pin_can0_cs, GPIO_OUT);
    gpio_put(pin_can0_cs, 1);
    //docs:end:can0_spi_setup

    gpio_set_function(pin_pico2_led, GPIO_FUNC_SIO);
    gpio_set_dir(pin_pico2_led, GPIO_OUT);
    
    //docs:start:can0_irq_setup
    //interrupt request from can0 controller
    gpio_set_function(pin_can0_irq, GPIO_FUNC_SIO);
    gpio_set_dir(pin_can0_irq, GPIO_IN);
    gpio_pull_up(pin_can0_irq);
    //docs:end:can0_irq_setup


    gpio_set_function(pin_power_detect, GPIO_FUNC_SIO);
    gpio_set_dir(pin_power_detect, GPIO_IN);
    gpio_pull_down(pin_power_detect);
    gpio_set_input_hysteresis_enabled(pin_power_detect, true);
}

