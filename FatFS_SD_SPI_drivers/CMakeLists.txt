cmake_minimum_required(VERSION 3.13)

project(fatfs_sd_spi_reference C)

add_library(fatfs_sd_spi INTERFACE)

target_compile_definitions(fatfs_sd_spi INTERFACE
    PICO_MAX_SHARED_IRQ_HANDLERS=8u
)
# target_compile_options(no-OS-FatFS-SD-SDIO-SPI-RPi-Pico INTERFACE -ffile-prefix-map=${CMAKE_CURRENT_LIST_DIR}=)

target_sources(fatfs_sd_spi INTERFACE
    ${CMAKE_CURRENT_LIST_DIR}/fatfs/fatfs_core.c
    ${CMAKE_CURRENT_LIST_DIR}/fatfs/fatfs_sd_adapter.c
    ${CMAKE_CURRENT_LIST_DIR}/sd_card/sd_card_timeouts.c
    ${CMAKE_CURRENT_LIST_DIR}/sd_card/sd_card_spi.c
)
target_include_directories(fatfs_sd_spi INTERFACE
    ${CMAKE_CURRENT_LIST_DIR}/fatfs
    ${CMAKE_CURRENT_LIST_DIR}/sd_card
    ${CMAKE_CURRENT_LIST_DIR}/sd_card/spi
)

target_link_libraries(fatfs_sd_spi INTERFACE
    hardware_spi
    pico_stdlib
)
