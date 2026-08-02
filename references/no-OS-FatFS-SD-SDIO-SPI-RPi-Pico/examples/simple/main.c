/* main.c
Copyright 2021 Carl John Kugler III

Licensed under the Apache License, Version 2.0 (the License); you may not use
this file except in compliance with the License. You may obtain a copy of the
License at

   http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an AS IS BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied. See the License for the
specific language governing permissions and limitations under the License.
*/

#include <stdio.h>
//
#include "pico/stdlib.h"
//
#include "hw_config.h"
#include "ff.h"

/**
 * @file main.c
 * @brief Minimal example of writing to a file on SD card
 * @details
 * This program demonstrates the following:
 * - Initialization of the stdio
 * - Mounting and unmounting the SD card
 * - Opening a file and writing to it
 * - Closing a file and unmounting the SD card
 */

int main() {
    // Initialize stdio
    stdio_init_all();

    puts("Hello, world!");

    // See FatFs - Generic FAT Filesystem Module, "Application Interface",
    // http://elm-chan.org/fsw/ff/00index_e.html
    FATFS fs;
    FRESULT fr = f_mount(&fs, "", 1);
    if (FR_OK != fr) {
        panic("f_mount error: %d\n", fr);
    }

    // Open a file and write to it
    FIL fil;
    const char* const filename = "filename.txt";
    fr = f_open(&fil, filename, FA_OPEN_APPEND | FA_WRITE);
    if (FR_OK != fr && FR_EXIST != fr) {
        panic("f_open(%s) error: %d\n", filename, fr);
    }
    const char message[] = "Hello, world!\n";
    UINT written = 0;
    fr = f_write(&fil, message, sizeof message - 1, &written);
    if (FR_OK != fr || written != sizeof message - 1) panic("f_write error: %d\n", fr);

    // Close the file
    fr = f_close(&fil);
    if (FR_OK != fr) {
        printf("f_close error: %d\n", fr);
    }

    // Unmount the SD card
    f_unmount("");

    puts("Goodbye, world!");
    for (;;);
}
