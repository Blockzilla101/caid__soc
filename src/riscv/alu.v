`include "global_params.vh"

`timescale 1ns / 1ps

module alu (
    input [31:0] A,
    input [31:0] B,
    input [3:0] alu_op,
    output reg [31:0] result
);

    always @(*) begin
        result <= 0;
        case (alu_op)
            `ALU_OP_ADD: result <= A + B;
            `ALU_OP_SUB: result <= A - B;
            `ALU_OP_AND: result <= A & B;
            `ALU_OP_OR: result <= A | B;
            `ALU_OP_XOR: result <= A ^ B;
            `ALU_OP_SLT: result <= ($signed(A) < $signed(B)) ? 32'b1 : 32'b0;
            `ALU_OP_SLTU: result <= (A < B) ? 32'b1 : 32'b0;
            `ALU_OP_SLL: result <= A << B;
            `ALU_OP_SRL: result <= A >> B;
            `ALU_OP_SRA: result <= A >>> B;
            default: result <= 0;
        endcase
    end

endmodule
