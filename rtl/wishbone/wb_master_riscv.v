`include "wb_def.vh"

`timescale 1ns / 1ps

`define WISHBONE_ENABLE

// supports only single tranfers, no block transfers

module wb_master_riscv (
    input wb_CLK_I,
    input wb_RST_I,

    input  [31:0] wb_DAT_I,
    output [31:0] wb_DAT_O,

    output [`WB_ADDR_SIZE] wb_ADR_O,

    input wb_ACK_I,
    output wb_CYC_O,
    output [`WB_SEL_SIZE] wb_SEL_O,
    output wb_STB_O,
    output wb_WE_O
);
    wire cpu_wb_access;
    wire cpu_wb_we;
    wire [31:0] cpu_wb_dat_o;
    wire [`WB_ADDR_SIZE] cpu_wb_addr;
    wire [`WB_SEL_SIZE] cpu_wb_sel;
    wire [31:0] cpu_wb_dat_i;
    wire cpu_wb_ack;

    assign cpu_wb_dat_i = wb_DAT_I;
    assign wb_WE_O = cpu_wb_we;
    assign wb_CYC_O = cpu_wb_access;
    assign wb_STB_O = cpu_wb_access;
    assign wb_SEL_O = cpu_wb_sel;
    assign cpu_wb_ack = wb_ACK_I;
    assign wb_DAT_O = cpu_wb_dat_o;
    assign wb_ADR_O = cpu_wb_addr;

    riscv_top riscv (
        .clk(wb_CLK_I),
        .rst(wb_RST_I),

        .wb_access(cpu_wb_access),
        .wb_we(cpu_wb_we),
        .wb_dat_o(cpu_wb_dat_o),
        .wb_addr(cpu_wb_addr),
        .wb_sel(cpu_wb_sel),
        .wb_dat_i(cpu_wb_dat_i),
        .wb_ack(cpu_wb_ack)
    );



endmodule
