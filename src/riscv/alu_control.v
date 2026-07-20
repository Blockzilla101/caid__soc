`timescale 1ns/1ps

`include "global_params.vh"

module alu_control(
    input [1:0] alu_ctrl,
    input [2:0] funct3,
    input [6:0] funct7,
    output reg [3:0] alu_op
);

    wire [9:0] funct = {funct7, funct3};

    always @(*) begin
        alu_op <= 0;

        case(alu_ctrl)
            `ALU_CTRL_ADD: alu_op <= `ALU_OP_ADD;
            `ALU_CTRL_SUB: alu_op <= `ALU_OP_SUB;
            `ALU_CTRL_FUNCT: begin
                casez (funct) // ? => funct7 is used for immediate
                    10'b???????_000: alu_op <= `ALU_OP_ADD;
                    10'b0100000_000: alu_op <= `ALU_OP_SUB;
                    10'b0000000_001: alu_op <= `ALU_OP_SLL;
                    10'b???????_010: alu_op <= `ALU_OP_SLT;
                    10'b???????_011: alu_op <= `ALU_OP_SLTU;
                    10'b???????_100: alu_op <= `ALU_OP_XOR;
                    10'b0000000_101: alu_op <= `ALU_OP_SRL;
                    10'b0100000_101: alu_op <= `ALU_OP_SRA;
                    10'b???????_110: alu_op <= `ALU_OP_OR;
                    10'b???????_111: alu_op <= `ALU_OP_AND;
                endcase
            end
            default: alu_op <= 0;
        endcase
    end

endmodule