#include "mcp2518.h"

//C Standard
#include <string.h>

// Raspberry Pi Pico SDK
#include "hardware/gpio.h"
#include "hardware/spi.h"
#include "pico/stdlib.h"

// Project modules
#include "mcu_hardware_config.h"
#include "can_types.h"
#include "can_ring_buffer.h"



//docs:start:mcp_reset
void mcp_reset(void){
    uint8_t command[2];
    command[0]= 0b00000000;
    command[1]= 0b00000000;
    gpio_put(pin_can0_cs,0);
        sleep_us(1);
    spi_write_blocking(spi_port_can0,command, 2);
        sleep_us(1);
    gpio_put(pin_can0_cs,1); 
}
//docs:end:mcp_reset

//docs:start:mcp_write
void mcp_write(uint16_t address, const void *tx_buffer, size_t length){
    uint8_t command[2];
    command[0]=MCP_COMMAND_WRITE | (address >>8);
    command[1]=address & 0b000011111111;
    gpio_put(pin_can0_cs, 0);
    sleep_us(1);
    spi_write_blocking(spi_port_can0, command, 2);
    spi_write_blocking(spi_port_can0, tx_buffer, length);
    sleep_us(1);
    gpio_put(pin_can0_cs, 1);

}
//docs:end:mcp_write

//docs:start:mcp_read
void mcp_read(uint16_t address, void *rx_buffer, size_t length){
    uint8_t command[2];

    command[0]= MCP_COMMAND_READ | (address>>8);    //4 command bits + first 4 address bits according to datasheet
    command[1]= address & 0b000011111111;   //filtering lower 8 address bits

    gpio_put(pin_can0_cs, 0);
    spi_write_blocking(spi_port_can0, command, 2); 
    spi_read_blocking(spi_port_can0, 0b00000000, rx_buffer, length); //sending empty bytes and write recieved data in buffer
    gpio_put(pin_can0_cs, 1);

}
//docs:end:mcp_read


void mcp_init(void){
    
    mcp_reset();


    //docs:start:mcp_bit_timing
    //nominal data rate: 500kbit/s
    //sample point: 87%, weil der Candlelight FD auch auf dieser Sample rate arbeitet
    //system clock: 20Mhz
    MCP_REG_C1NBTCFG_t mcp_c1nbtcfg = {
        .bits = {
            .SJW= 4,    //5 TQ allowed sample point adjustment to synchronize bus
            .TSEG2= 4, // 5 time quantums after sample
            .TSEG1= 33,  //34 time quantums before sample
            .BRP= 0     //system clock prescaler for can-controller
        },
    };

    //data phase rate to 2Mbit/s
    MCP_REG_C1DBTCFG_t mcp_c1dbtcfg = {
        .bits = {
            .SJW= 1,
            .TSEG2= 1,
            .TSEG1= 6,
            .BRP= 0
        },
    };
    //docs:end:mcp_bit_timing

    //docs:start:mcp_receive_path_configuration
    MCP_REG_C1FIFOCON_t mcp_c1fifocon1 = { //recieve fifo
        .bits = {
            
            .PLSIZE= 7, //64 byte payload (MCP2518FD PLSIZE encoding)
            .FSIZE= 15, //16 Messages fifo-depth
            .TFNRFNIE= 1, // Recieve-Fifo not empty Interrupt enabled.
        },
    };


    MCP_REG_C1FIFOCON_t mcp_c1fifocon2 = { //transmit fifo
        .bits = {

            .PLSIZE= 7, //64 byte payload (MCP2518FD PLSIZE encoding)
            .FSIZE= 7, //8 Messages fifo-depth
        }
    };

    MCP_REG_C1INT_t mcp_c1int = {
        .bits = {
            .RXIE = 1, //recieve message interrupt enable
        }
    };

    
    MCP_REG_C1FLTCON_t mcp_c1fltcon = {
        .bits = {
            .FLTEN0= 1, //enable filter 0
            .F0BP=  1 //save hits in fifo 1
        }
    };
    //docs:end:mcp_receive_path_configuration

    MCP_REG_C1CON_t mcp_c1con = {
        .bits = {
            .ISOCRCEN = 1, //use ISO-CAN-FD
            .REQOP = 0  //request normal can-FD mode
        }
    };
    
    //docs:start:mcp_apply_configuration
    mcp_write(MCP_REG_ADR_C1NBTCFG, mcp_c1nbtcfg.data_array, sizeof mcp_c1nbtcfg.data_array);
    mcp_write(MCP_REG_ADR_C1DBTCFG, mcp_c1dbtcfg.data_array, sizeof mcp_c1dbtcfg.data_array);
    mcp_write(MCP_REG_ADR_C1FIFOCON1, mcp_c1fifocon1.data_array, sizeof mcp_c1fifocon1.data_array);
    mcp_write(MCP_REG_ADR_C1FIFOCON2, mcp_c1fifocon2.data_array, sizeof mcp_c1fifocon2.data_array);
    mcp_write(MCP_REG_ADR_C1INT, mcp_c1int.data_array, sizeof mcp_c1int.data_array);
    mcp_write(MCP_REG_ADR_C1FLTCON0, mcp_c1fltcon.data_array, sizeof mcp_c1fltcon.data_array);
    mcp_write(MCP_REG_ADR_C1CON, mcp_c1con.data_array, sizeof mcp_c1con.data_array);
    //docs:end:mcp_apply_configuration

}

//docs:start:can0_drain_receive_fifo
void mcp_fetch_data(){
    
    uint32_t tmp_offset;
    mcp_rx_object_t tmp_rx_obj;
    can_frame_t tmp_can_frame;

        //Retrieve the address offset of the recieved CAN-Message stored in message ram from C1FIFOUA1
        mcp_read(MCP_REG_ADR_C1FIFOUA1, &tmp_offset, sizeof tmp_offset);

        //Read this message address and write into temp. message buffer.
        mcp_read(tmp_offset + MCP_RAM_BASE, tmp_rx_obj.data_array, sizeof tmp_rx_obj.data_array);

        //save message in ringbuffer
        mcp_convert_rx_obj_to_can(&tmp_rx_obj, &tmp_can_frame);
        can_ring_store(&tmp_can_frame);

        //set UINC bit in C1FIFOCON1 to prompt load operation of next message offset into C1FIFOUA1
        MCP_REG_C1FIFOCON_t tmp_c1fifocon;
        mcp_read(MCP_REG_ADR_C1FIFOCON1, tmp_c1fifocon.data_array, sizeof tmp_c1fifocon.data_array);
        tmp_c1fifocon.bits.UINC= 1;
        mcp_write(MCP_REG_ADR_C1FIFOCON1, tmp_c1fifocon.data_array, sizeof tmp_c1fifocon.data_array);

        //time marker for end of transmission
        time_mes_pin_toggle(pin_pico2_t_can_recieved);

}
//docs:end:can0_drain_receive_fifo

bool mcp_send_data(mcp_tx_object_t mcp_tx_object){
    if(!mcp_check_txfifo_ready()) return false;
    uint32_t tmp_offset;
    mcp_read(MCP_REG_ADR_C1FIFOUA2, &tmp_offset, sizeof tmp_offset);
    mcp_write(MCP_RAM_BASE + tmp_offset, mcp_tx_object.data_array, sizeof mcp_tx_object.data_array);

    MCP_REG_C1FIFOCON_t tmp_c1fifocon;
    mcp_read(MCP_REG_ADR_C1FIFOCON2, tmp_c1fifocon.data_array, sizeof tmp_c1fifocon.data_array);
    tmp_c1fifocon.bits.UINC= 1;
    tmp_c1fifocon.bits.TXREQ= 1;
    mcp_write(MCP_REG_ADR_C1FIFOCON2, tmp_c1fifocon.data_array, sizeof tmp_c1fifocon.data_array);
    return true;
}

bool mcp_check_rxfifo_ready(){
    MCP_REG_C1FIFOSTA_t tmp_c1fifosta;
    mcp_read(MCP_REG_ADR_C1FIFOSTA1, tmp_c1fifosta.data_array, sizeof tmp_c1fifosta.data_array);
    return (bool)tmp_c1fifosta.bits.TFNRFNIF;
}

bool mcp_check_txfifo_ready(){
    MCP_REG_C1FIFOSTA_t tmp_c1fifosta;
    mcp_read(MCP_REG_ADR_C1IFIOSTA2, tmp_c1fifosta.data_array, sizeof tmp_c1fifosta.data_array);
    return (bool)tmp_c1fifosta.bits.TFNRFNIF;
}




void mcp_convert_can_to_tx_obj(const can_frame_t *can_frame, mcp_tx_object_t *tx_obj){

    memset(tx_obj,0,sizeof(*tx_obj));

    tx_obj -> datafields.SID = can_frame -> SID;
    tx_obj -> datafields.DLC = can_frame -> DLC;
    tx_obj -> datafields.BRS = BUS_BITRATE_SWITCH;
    tx_obj -> datafields.FDF = BUS_CAN_FD;
}

void mcp_convert_rx_obj_to_can(const mcp_rx_object_t *rx_obj, can_frame_t *can_frame){

    can_frame -> SID = rx_obj -> datafields.SID;
    can_frame -> DLC = rx_obj -> datafields.DLC;
    can_frame -> ESI = rx_obj -> datafields.ESI;
    
    memcpy(can_frame->can_payload,
           rx_obj->datafields.can_payload,
           sizeof can_frame->can_payload);
}
