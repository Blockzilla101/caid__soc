`timescale 1ns / 1ps

`include "../include/riscv_def.vh"

module alu_control (
    input [`INST_OPCODE] opcode,
    input [1:0] alu_ctrl,
    input [`INST_FUNCT3] funct3,
    input [`INST_FUNCT7] funct7,
    output reg [3:0] alu_op
);
    always @(*) begin
        alu_op <= 0;

        case (alu_ctrl)
            `ALU_CTRL_ADD: alu_op <= `ALU_OP_ADD;
            `ALU_CTRL_SUB: alu_op <= `ALU_OP_SUB;
            `ALU_CTRL_FUNCT: begin
                casez ({
                    funct7, funct3, opcode[5]
                })  // ? => funct7 is used for immediate
                    11'b0100000_000_1: alu_op <= `ALU_OP_SUB;
                    11'b???????_000_?: alu_op <= `ALU_OP_ADD;
                    11'b0000000_001_?: alu_op <= `ALU_OP_SLL;
                    11'b???????_010_?: alu_op <= `ALU_OP_SLT;
                    11'b???????_011_?: alu_op <= `ALU_OP_SLTU;
                    11'b???????_100_?: alu_op <= `ALU_OP_XOR;
                    11'b0000000_101_?: alu_op <= `ALU_OP_SRL;
                    11'b0100000_101_?: alu_op <= `ALU_OP_SRA;
                    11'b???????_110_?: alu_op <= `ALU_OP_OR;
                    11'b???????_111_?: alu_op <= `ALU_OP_AND;
                    default: alu_op <= 0;
                endcase
            end
            default: alu_op <= 0;
        endcase
    end

endmodule
