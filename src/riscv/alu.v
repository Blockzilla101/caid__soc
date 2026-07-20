`timescale 1ns/1ps

module alu (
    input [31:0] A,
    input [31:0] B,
    input op_sel,
    output reg [31:0] result,
    output zero
);

    always @(*) begin
        case (op_sel)

        endcase
    end

    assign zero = result == 0;

endmodule