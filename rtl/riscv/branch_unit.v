`include "../include/riscv_def.vh"

`timescale 1ns / 1ps

module branch_unit (
    input [31:0] A,
    input [31:0] B,
    input [2:0] funct3,
    input branch,
    input non_conditional_jmp,
    output branch_taken
);
    reg compare_result;

    always @(*) begin
        compare_result <= 0;
        case (funct3)
            `BRANCH_OP_BEQ: compare_result <= A == B;
            `BRANCH_OP_BNE: compare_result <= A != B;
            `BRANCH_OP_BLT: compare_result <= $signed(A) < $signed(B);
            `BRANCH_OP_BGE: compare_result <= $signed(A) >= $signed(B);
            `BRANCH_OP_BLTU: compare_result <= A < B;
            `BRANCH_OP_BGEU: compare_result <= A >= B;
            default: compare_result <= 0;
        endcase
    end

    assign branch_taken = non_conditional_jmp || (branch && compare_result);

endmodule
