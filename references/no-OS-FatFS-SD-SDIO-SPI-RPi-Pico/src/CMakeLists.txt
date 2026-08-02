add_library(fatfs_sd_spi INTERFACE)

target_compile_definitions(fatfs_sd_spi INTERFACE
    PICO_MAX_SHARED_IRQ_HANDLERS=8u
)
# target_compile_options(no-OS-FatFS-SD-SDIO-SPI-RPi-Pico INTERFACE -ffile-prefix-map=${CMAKE_CURRENT_LIST_DIR}=)

target_sources(fatfs_sd_spi INTERFACE
    ${CMAKE_CURRENT_LIST_DIR}/ff15/source/ff.c
    ${CMAKE_CURRENT_LIST_DIR}/sd_driver/sd_card.c
    ${CMAKE_CURRENT_LIST_DIR}/sd_driver/sd_timeouts.c
    ${CMAKE_CURRENT_LIST_DIR}/sd_driver/SPI/my_spi.c
    ${CMAKE_CURRENT_LIST_DIR}/sd_driver/SPI/sd_card_spi.c
    ${CMAKE_CURRENT_LIST_DIR}/sd_driver/SPI/sd_spi.c
    ${CMAKE_CURRENT_LIST_DIR}/src/crc.c
    ${CMAKE_CURRENT_LIST_DIR}/src/glue.c
)
target_include_directories(fatfs_sd_spi INTERFACE
    ff15/source
    sd_driver
    include
)

target_link_libraries(fatfs_sd_spi INTERFACE
    hardware_dma
    hardware_spi
    hardware_sync
    pico_stdlib
)
