`include "global_params.vh"

module tb_functional_units (
    input clk,
    input rst,
    input [31:0] A,
    input [31:0] B,
    input [31:0] instruction
);
    wire [`CW_LEN] control_word;
    wire [3:0] alu_op;
    wire [31:0] imm_value;
    wire [31:0] alu_result;

    reg [31:0] pc_next_val;
    wire [31:0] pc_val;

    control_unit cu (
        .opcode(instruction[`INST_OPCODE]),
        .control_word(control_word)
    );

    alu_control alu_ctrl_unit (
        .opcode  (instruction[`INST_OPCODE]),
        .alu_ctrl(control_word[`CW_ALU_CTRL]),
        .funct3  (instruction[`INST_FUNCT3]),
        .funct7  (instruction[`INST_FUNCT7]),
        .alu_op  (alu_op)
    );

    alu alu_unit (
        .A(A),
        .B(B),
        .alu_op(alu_op),
        .result(alu_result)
    );

    imm_gen imm (
        .instruction(instruction),
        .imm_value  (imm_value)
    );

    branch_unit bu (
        .A(A),
        .B(B),
        .funct3(instruction[`INST_FUNCT3]),
        .branch(control_word[`CW_BRANCH]),
        .non_conditional_jmp(control_word[`CW_BRANCH_UNCOND]),
        .branch_taken(branch_taken)
    );

    program_counter pc (
        .clk(clk),
        .rst(rst),
        .next_val(pc_next_val),
        .pc_val(pc_val)
    );

    reg [4:0] reg_rs1;
    reg [4:0] reg_rs2;
    reg [4:0] reg_rd;
    reg [31:0] reg_write_data;
    reg reg_write_enable;
    wire [31:0] reg_rs1_data;
    wire [31:0] reg_rs2_data;

    register_file reg_file (
        .clk(clk),
        .rs1(reg_rs1),
        .rs2(reg_rs2),
        .rd(reg_rd),
        .write_data(reg_write_data),
        .write_enable(reg_write_enable),
        .rs1_data(reg_rs1_data),
        .rs2_data(reg_rs2_data)
    );

    reg  [31:0] inst_addr;
    wire [31:0] inst_read_data;

    instruction_memory inst_mem (
        .clk(clk),
        .addr(inst_addr),
        .read_data(inst_read_data)
    );

    reg [31:0] mem_addr;
    reg [31:0] mem_write_data;
    reg mem_write_enable;
    reg [31:0] mem_read_data;

    data_memory data_mem (
        .clk(clk),
        .addr(mem_addr),
        .write_data(mem_write_data),
        .write_enable(mem_write_enable),
        .funct3(instruction[`INST_FUNCT3]),
        .read_data(mem_read_data)
    );

endmodule
