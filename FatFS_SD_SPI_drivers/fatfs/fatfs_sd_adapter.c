/*-----------------------------------------------------------------------*/
/* Low level disk I/O module SKELETON for FatFs     (C)ChaN, 2019        */
/*-----------------------------------------------------------------------*/
/* If a working storage control module is available, it should be        */
/* attached to the FatFs via a glue function rather than modifying it.   */
/* This is an example of glue functions to attach various exsisting      */
/* storage control modules to the FatFs module with a defined API.       */
/*-----------------------------------------------------------------------*/
//
//
#include "sd_card_noop_debug.h"
#include "sd_card_spi.h"
//
#include "fatfs_sd_adapter.h" /* Declarations of disk functions */

#define TRACE_PRINTF(fmt, args...)
//#define TRACE_PRINTF printf  // task_printf

/*-----------------------------------------------------------------------*/
/* Get Drive Status                                                      */
/*-----------------------------------------------------------------------*/

DSTATUS disk_status(BYTE pdrv /* Physical drive number to identify the drive */
) {
    TRACE_PRINTF(">>> %s\n", __FUNCTION__);
    return pdrv == 0 ? sd_card_status() : STA_NOINIT;
}

/*-----------------------------------------------------------------------*/
/* Inidialize a Drive                                                    */
/*-----------------------------------------------------------------------*/

DSTATUS disk_initialize(
    BYTE pdrv /* Physical drive number to identify the drive */
) {
    TRACE_PRINTF(">>> %s\n", __FUNCTION__);

    return pdrv == 0 ? sd_card_init() : STA_NOINIT;
}

/*-----------------------------------------------------------------------*/
/* Read Sector(s)                                                        */
/*-----------------------------------------------------------------------*/

DRESULT disk_read(BYTE pdrv,  /* Physical drive number to identify the drive */
                  BYTE *buff, /* Data buffer to store read data */
                  LBA_t sector, /* Start sector in LBA */
                  UINT count    /* Number of sectors to read */
) {
    TRACE_PRINTF(">>> %s\n", __FUNCTION__);
    if (pdrv != 0) return RES_PARERR;
    return sd_card_read_blocks(buff, sector, count) ? RES_OK : RES_ERROR;
}

/*-----------------------------------------------------------------------*/
/* Write Sector(s)                                                       */
/*-----------------------------------------------------------------------*/

#if FF_FS_READONLY == 0

DRESULT disk_write(BYTE pdrv, /* Physical drive number to identify the drive */
                   const BYTE *buff, /* Data to be written */
                   LBA_t sector,     /* Start sector in LBA */
                   UINT count        /* Number of sectors to write */
) {
    TRACE_PRINTF(">>> %s\n", __FUNCTION__);
    if (pdrv != 0) return RES_PARERR;
    return sd_card_write_blocks(buff, sector, count) ? RES_OK : RES_ERROR;
}

#endif

/*-----------------------------------------------------------------------*/
/* Miscellaneous Functions                                               */
/*-----------------------------------------------------------------------*/

DRESULT disk_ioctl(BYTE pdrv, /* Physical drive number (0..) */
                   BYTE cmd,  /* Control code */
                   void *buff /* Buffer to send/receive control data */
) {
    TRACE_PRINTF(">>> %s\n", __FUNCTION__);
    if (pdrv != 0) return RES_PARERR;
    switch (cmd) {
        case GET_SECTOR_COUNT: {  // Retrieves number of available sectors, the
                                  // largest allowable LBA + 1, on the drive
                                  // into the LBA_t variable pointed by buff.
                                  // This command is used by f_mkfs and f_fdisk
                                  // function to determine the size of
                                  // volume/partition to be created. It is
                                  // required when FF_USE_MKFS == 1.
            static LBA_t n;
            n = sd_card_sector_count();
            *(LBA_t *)buff = n;
            if (!n) return RES_ERROR;
            return RES_OK;
        }
        case GET_BLOCK_SIZE: {  // Retrieves erase block size of the flash
                                // memory media in unit of sector into the DWORD
                                // variable pointed by buff. The allowable value
                                // is 1 to 32768 in power of 2. Return 1 if the
                                // erase block size is unknown or non flash
                                // memory media. This command is used by only
                                // f_mkfs function and it attempts to align data
                                // area on the erase block boundary. It is
                                // required when FF_USE_MKFS == 1.
            static DWORD bs = 1;
            *(DWORD *)buff = bs;
            return RES_OK;
        }
        case CTRL_SYNC:
            return sd_card_sync() ? RES_OK : RES_ERROR;
        default:
            return RES_PARERR;
    }
}
