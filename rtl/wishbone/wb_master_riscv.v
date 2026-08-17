`include "../include/wb_def.vh"
`include "../include/riscv_def.vh"

`timescale 1ns / 1ps

`define WISHBONE_ENABLE

// supports only single tranfers, no block transfers

module wb_master_riscv (
`ifdef USE_POWER_PINS
    inout vccd1,
    inout vssd1,
`endif

    input wb_CLK_I,
    input wb_RST_I,

    input wb_SLV_SEL,

    input  [31:0] wb_DAT_I,
    output [31:0] wb_DAT_O,

    output [`WB_ADDR_SIZE] wb_ADR_O,

    input wb_ACK_I,
    output wb_CYC_O,
    output [`WB_SEL_SIZE] wb_SEL_O,
    output wb_STB_O,
    output wb_WE_O,

    output wb_TGD_O
);
    wire [31:0] instruction;
    wire [`CW_LEN] control_word;
    wire [31:0] cpu_write_data;
    wire [31:0] cpu_read_data;
    wire [31:0] cpu_addr;
    wire cpu_stall;

    riscv_top riscv (
        .clk(wb_CLK_I),
        .rst(wb_RST_I),

        .instruction (instruction),
        .control_word(control_word),

        .cpu_write_data(cpu_write_data),
        .cpu_read_data(cpu_read_data),
        .cpu_addr(cpu_addr),

        .cpu_stall(cpu_stall)
    );

    wb_controller bus_controller (
        // cpu
        .instruction (instruction),
        .control_word(control_word),

        .cpu_write_data(cpu_write_data),
        .cpu_read_data(cpu_read_data),
        .cpu_addr(cpu_addr),

        .cpu_stall(cpu_stall),

        // wishbone
        .wb_SLV_SEL(wb_SLV_SEL),

        .wb_DAT_I(wb_DAT_I),
        .wb_DAT_O(wb_DAT_O),

        .wb_ADR_O(wb_ADR_O),

        .wb_ACK_I(wb_ACK_I),
        .wb_CYC_O(wb_CYC_O),
        .wb_SEL_O(wb_SEL_O),
        .wb_STB_O(wb_STB_O),
        .wb_WE_O (wb_WE_O),

        .wb_TGD_O(wb_TGD_O)
    );
endmodule
