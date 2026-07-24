`include "global_params.vh"

`timescale 1ns/1ps

module riscv_top(
    input clk,
    input rst
);
    wire [`CW_LEN] control_word;
    wire [31:0] instruction;

    data_memory data_mem();
    instruction_memory inst_mem();

    register_file reg_file();

    program_counter pc();

    imm_gen imm();

    alu_control alu_ctrl();
    alu alu_unit();

    control_unit cu();
endmodule