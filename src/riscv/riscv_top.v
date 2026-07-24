`include "global_params.vh"

`timescale 1ns/1ps

module riscv_top(
    input clk,
    input rst
);
    wire [`CW_LEN] control_word;
    wire [31:0] instruction;
    wire [3:0] alu_op;

    wire [31:0] alu_result;
    wire alu_compare_result;

    wire [31:0] reg_data1;
    wire [31:0] reg_data2;

    wire [31:0] data_mem_read_data;

    wire [31:0] imm_value;

    wire [31:0] pc_val;
    wire [31:0] pc_val_4 = pc_val + 4;

    wire [31:0] alu_op1 = control_word[`CW_ALU_SRC_OP1] ? pc_val : reg_data1;
    wire [31:0] alu_op2 = control_word[`CW_ALU_SRC_OP2] ? imm_value : reg_data2;
    wire [31:0] reg_write_val;
    wire [31:0] pc_next_val;

    mux3 write_back(
        .A(alu_result),
        .B(data_mem_read_data),
        .C(pc_val_4),
        .sel(control_word[`CW_REG_WRITE_SRC]),
        .F(reg_write_val)
    );

    data_memory data_mem(
        .clk(clk),
        .addr(alu_result),
        .write_data(reg_data2),
        .write_enable(control_word[`CW_MEM_WRITE]),
        .read_data(data_mem_read_data)
    );

    instruction_memory inst_mem(
        .clk(clk),
        .addr(pc_val),
        .read_data(instruction)
    );

    register_file reg_file(
        .clk(clk),
        .rs1(instruction[`INST_RS1]),
        .rs2(instruction[`INST_RS2]),
        .write_data(reg_write_val),
        .write_enable(instruction[`CW_REG_WRITE_EN]),
        .rs1_data(reg_data1),
        .rs2_data(reg_data1)
    );

    program_counter pc(
        .clk(clk),
        .rst(rst),
        .next_val(pc_next_val),
        .pc_val(pc_val)
    );

    imm_gen imm(
        .instruction(instruction),
        .imm_value(imm_value)
    );

    alu_control alu_ctrl(
        .opcode(instruction[`INST_OPCODE]),
        .alu_ctrl(control_word[`CW_ALU_CTRL]),
        .funct3(instruction[`INST_FUNCT3]),
        .funct7(instruction[`INST_FUNCT7]),
        .alu_op(alu_op)
    );

    alu alu_unit(
        .A(alu_op1),
        .B(alu_op2),
        .alu_op(alu_op),
        .result(alu_result),
        .compare(alu_compare_result)
    );

    control_unit cu(
        .opcode(instruction[`INST_OPCODE]),
        .control_word(control_word)
    );
    
endmodule