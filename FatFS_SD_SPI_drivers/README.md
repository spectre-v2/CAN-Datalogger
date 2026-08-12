# FatFs SD SPI reference

This directory is a pruned reference copy of `no-OS-FatFS-SD-SDIO-SPI-RPi-Pico`.
It keeps only the C path needed for a Pico/Pico2 writing to a FAT-formatted SD
card over SPI.

Kept layers:

- `fatfs`: ChaN FatFs core and the FatFs-to-SD-card disk I/O adapter.
- `sd_card`: a single-card SD-over-SPI driver and small blocking SPI transport.
- `examples/simple`: minimal mount/open/write/close example and hardware config.

Important files:

- `fatfs/fatfs_core.c`: FatFs filesystem implementation.
- `fatfs/fatfs_core.h`: FatFs public API.
- `fatfs/fatfs_config_minimal.h`: minimal FatFs feature configuration.
- `fatfs/fatfs_sd_adapter.h`: block-device API expected by FatFs.
- `fatfs/fatfs_sd_adapter.c`: implementation of FatFs disk I/O using `sd_card_t`.
- `sd_card/sd_card_spi.h`: the one public SD-card configuration and access API.
- `sd_card/sd_card_spi.c`: SD-card setup, commands, and block read/write protocol.

SD-card diagnostics use the project-wide `debugmsg("sd-spi", ...)` channel. Enable
`DEBUGMSG` (or `DEBUG`) for the application to print them on its configured stdio output.

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

Hardware pins are configured directly in `board.h` and `sd_card/sd_card_spi.c`.
The CMake target is `fatfs_sd_spi`; no application-side SD configuration is needed.

This reference expects the card to already be formatted as FAT/FAT32. exFAT is
disabled to keep the code small.
Long file names are disabled, so use 8.3 filenames such as `CANLOG.CSV`.
