# FatFs SD SPI reference

This directory is a pruned reference copy of `no-OS-FatFS-SD-SDIO-SPI-RPi-Pico`.
It keeps only the C path needed for a Pico/Pico2 writing to a FAT-formatted SD
card over SPI.

Kept layers:

- `fatfs`: ChaN FatFs core and the FatFs-to-SD-card disk I/O adapter.
- `sd_card`: generic SD-card state, configuration, timeouts, CRC, and register helpers.
- `sd_card/spi`: SD-card SPI protocol, SD-specific SPI bus helpers, and Pico SPI/DMA transport.
- `examples/simple`: minimal mount/open/write/close example and hardware config.

Important files:

- `fatfs/fatfs_core.c`: FatFs filesystem implementation.
- `fatfs/fatfs_core.h`: FatFs public API.
- `fatfs/fatfs_config_minimal.h`: minimal FatFs feature configuration.
- `fatfs/fatfs_diskio.h`: block-device API expected by FatFs.
- `fatfs/fatfs_sd_card_diskio_adapter.c`: implementation of FatFs disk I/O using `sd_card_t`.
- `sd_card/sd_card_manager.c`: generic SD-card setup, status, card-detect, and locking.
- `sd_card/spi/sd_card_spi_protocol.c`: SD-card command and block protocol over SPI.
- `sd_card/spi/sd_card_spi_bus.c`: SD-specific SPI select/deselect and clock helpers.
- `sd_card/spi/pico_spi_dma_transport.c`: Pico SDK SPI/DMA transport.

Removed:

- SDIO/PIO driver code.
- USB mass-storage examples.
- PlatformIO and C++ wrapper code.
- Extra test and command-line examples.
- Git history and bundled unrelated upstream notes.
- FatFs optional OS glue, RTC timestamps, debug output, crash capture, `f_printf`,
  `f_mkfs`, exFAT, long file names, and directory traversal helpers.

The important application calls are:

```c
FATFS fs;
FIL file;
UINT bytes_written;
char line[96];

f_mount(&fs, "", 1);
f_open(&file, "CANLOG.CSV", FA_OPEN_APPEND | FA_WRITE);
int len = snprintf(line, sizeof line, "%lu,%lu,%u,%u,%u,%u,%u,%u,%u,%u,%u,%u\n",
                   timestamp_us, id, dlc,
                   data[0], data[1], data[2], data[3],
                   data[4], data[5], data[6], data[7]);
f_write(&file, line, (UINT)len, &bytes_written);
f_sync(&file);
f_close(&file);
f_unmount("");
```

Hardware pins live in `examples/simple/example_sd_card_hardware_config.c`.
The CMake target is `fatfs_sd_spi`; your application still needs to compile one
hardware config C file that provides `sd_get_num()` and `sd_get_by_num()`.

This reference expects the card to already be formatted as FAT/FAT32. exFAT is
disabled to keep the code small.
Long file names are disabled, so use 8.3 filenames such as `CANLOG.CSV`.
