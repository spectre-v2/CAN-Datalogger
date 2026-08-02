# FatFs SD SPI reference

This directory is a pruned reference copy of `no-OS-FatFS-SD-SDIO-SPI-RPi-Pico`.
It keeps only the C path needed for a Pico/Pico2 writing to a FAT-formatted SD
card over SPI.

Kept layers:

- `src/ff15/source`: ChaN FatFs core.
- `src/src/glue.c`: FatFs `diskio` glue to the SD-card block driver.
- `src/sd_driver`: SD-card block driver, pruned to SPI only.
- `src/sd_driver/SPI`: Pico SPI transport for SD cards.
- `src/include`: minimal configuration and headers needed by the retained C code.
- `examples/simple`: minimal mount/open/write/close example and hardware config.

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

Hardware pins live in `examples/simple/hw_config.c`.
The CMake target is `fatfs_sd_spi`; your application still needs to compile one
`hw_config.c` that provides `sd_get_num()` and `sd_get_by_num()`.

This reference expects the card to already be formatted as FAT/FAT32. exFAT is
disabled to keep the code small.
Long file names are disabled, so use 8.3 filenames such as `CANLOG.CSV`.
