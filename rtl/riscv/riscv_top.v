`include "riscv_def.vh"
`include "wb_def.vh"

`timescale 1ns / 1ps

module riscv_top (
    input clk,
    input rst
);

`ifdef WISHBONE_ENABLE
    output wb_transfer_enable;
    output wb_write_bus;
    output [31:0] wb_write_data;
    output [`WB_ADDR_SIZE] wb_addr;
    output [`WB_SEL_SIZE] wb_sel;
    input [31:0] wb_read_data;
    input wb_transfer_complet;

    reg wb_stall;
`endif

    wire [`CW_LEN] control_word;

    wire [31:0] pc_val;
    wire [31:0] pc_plus_4 = pc_val + 4;
    wire [31:0] pc_next_val;

    program_counter pc (
        .clk(clk),
        .rst(rst),
        .next_val(pc_next_val),
        .pc_val(pc_val)
    );

    wire [31:0] instruction;

    instruction_memory inst_mem (
        .clk(clk),
        .addr(pc_val),
        .read_data(instruction)
    );

    wire [31:0] reg_rs1_data;  // to op1 mux
    wire [31:0] reg_rs2_data;  // to op2 mux
    wire [31:0] reg_write_data;  // from mux

    register_file reg_file (
        .clk(clk),
        .rs1(instruction[`INST_RS1]),
        .rs2(instruction[`INST_RS2]),
        .rd(instruction[`INST_RD]),
        .write_data(reg_write_data),
`ifdef WISHBONE_ENABLE
        .write_enable(control_word[`CW_REG_WRITE_EN] && !wb_stall),
`else
        .write_enable(control_word[`CW_REG_WRITE_EN]),
`endif
        .rs1_data(reg_rs1_data),
        .rs2_data(reg_rs2_data)
    );

    control_unit cu (
        .opcode(instruction[`INST_OPCODE]),
        .control_word(control_word)
    );

    wire [3:0] alu_op;

    alu_control alu_ctrl (
        .opcode  (instruction[`INST_OPCODE]),
        .alu_ctrl(control_word[`CW_ALU_CTRL]),
        .funct3  (instruction[`INST_FUNCT3]),
        .funct7  (instruction[`INST_FUNCT7]),
        .alu_op  (alu_op)
    );

    wire [31:0] alu_op1;  // from op1 mux
    wire [31:0] alu_op2;  // from op2 mux

    wire [31:0] alu_result;

    alu alu (
        .A(alu_op1),
        .B(alu_op2),
        .alu_op(alu_op),
        .result(alu_result)
    );

    wire [31:0] mem_read_data;  // to write-back mux

`ifndef WISHBONE_ENABLE
    data_memory data_mem (
        .clk(clk),
        .addr(alu_result),
        .write_data(reg_rs2_data),
        .write_enable(control_word[`CW_MEM_WRITE]),
        .funct3(instruction[`INST_FUNCT3]),
        .read_data(mem_read_data)
    );
`endif

    wire [31:0] imm_value;  // to op2 mux

    imm_gen imm (
        .instruction(instruction),
        .imm_value  (imm_value)
    );

    wire branch_taken;

    branch_unit bu (
        .A(reg_rs1_data),
        .B(reg_rs2_data),
        .funct3(instruction[`INST_FUNCT3]),
        .branch(control_word[`CW_BRANCH]),
        .non_conditional_jmp(control_word[`CW_BRANCH_UNCOND]),
        .branch_taken(branch_taken)
    );

    mux3 alu_op1_mux (
        .A  (reg_rs1_data),
        .B  (pc_val),
        .C  (32'h0000_0000),
        .sel(control_word[`CW_ALU_SRC_OP1]),
        .F  (alu_op1)
    );

    assign alu_op2 = control_word[`CW_ALU_SRC_OP2] ? imm_value : reg_rs2_data;

    mux3 write_back (
        .A  (alu_result),
        .B  (mem_read_data),
        .C  (pc_plus_4),
        .sel(control_word[`CW_REG_WRITE_SRC]),
        .F  (reg_write_data)
    );

`ifdef WISHBONE_ENABLE
    mux3 pc_next_val_mux (
        .A  (pc_plus_4),
        .B  (alu_result & ~32'b1),
        .C  (pc_val),
        .sel({wb_stall, wb_stall ? 1'b0 : branch_taken}),
        .F  (pc_next_val)
    );


    assign wb_transfer_enable = control_word[`CW_MEM_WRITE] || control_word[`CW_MEM_READ];
    assign wb_write_bus = control_word[`CW_MEM_WRITE];
    assign wb_write_data = reg_rs2_data;
    assign wb_addr = alu_result;
    assign mem_read_data = wb_read_data;
    assign wb_sel = {1'b0, instruction[`INST_FUNCT3]};

    always @(*) begin
        wb_stall = 0;
        if (wb_transfer_enable) begin
            wb_stall = 1;

            if (wb_transfer_complete) begin
                wb_stall = 0;
            end
        end
    end
`else
    assign pc_next_val = branch_taken ? alu_result & ~32'b1 : pc_plus_4;
`endif

endmodule
