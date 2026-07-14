#include <stdio.h>
#include "pico/stdlib.h"
#include "hardware/spi.h"
#include "mcp.h"
#include "main.h"

MCP_DEVID_t mcp_devid = {0};

int main()
{
    stdio_init_all();

    // SPI initialisation
    spi_init(SPI_PORT, 1000*1000);
    gpio_set_function(PIN_MISO, GPIO_FUNC_SPI);
    gpio_set_function(PIN_CS,   GPIO_FUNC_SIO);
    gpio_set_function(PIN_SCK,  GPIO_FUNC_SPI);
    gpio_set_function(PIN_MOSI, GPIO_FUNC_SPI);
    
    //chip select is active-low
    gpio_set_dir(PIN_CS, GPIO_OUT);
    gpio_put(PIN_CS, 1);


    while (true) {
        mcp_reset();
        sleep_ms(10);
        mcp_read_reg(MCP_REG_DEVID, mcp_devid.data_array, sizeof mcp_devid.data_array);
        printf("MCP DEVICE ID: 0x%02X\n", mcp_devid.bits.ID);
        sleep_ms(1000);
    }
}
