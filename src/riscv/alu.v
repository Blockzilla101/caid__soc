`include "global_params.vh"

`timescale 1ns/1ps

module alu (
    input [31:0] A,
    input [31:0] B,
    input [3:0] alu_op,
    output reg [31:0] result,
    output reg compare
);

    always @(*) begin
        compare <= 0;
        result <= 0;
        case (alu_op)
            `ALU_OP_ADD: result <= A + B;
            `ALU_OP_SUB: begin result <= A - B; compare <= A == B end;
            `ALU_OP_AND: result <= A & B;
            `ALU_OP_OR: result <= A | B;
            `ALU_OP_XOR: result <= A ^ B;
            `ALU_OP_SLT: result <= ($signed(A) < $signed(B)) ? 32'b1 : 32'b0;
            `ALU_OP_SLTU: result <= (A < B) ? 32'b1 : 32'b0;
            `ALU_OP_SLL: result <= A << B;
            `ALU_OP_SRL: result <= A >> B;
            `ALU_OP_SRA: result <= A >>> B;
            `ALU_OP_BNE: compare <= A != B;
            `ALU_OP_BLT: compare <= $signed(A) < $signed(B);
            `ALU_OP_BGE: compare <= $signed(A) > $signed(B);
            `ALU_OP_BLTU: compare <= A < B;
            `ALU_OP_BGEU: compare <= A > B;
        endcase
    end

endmodule