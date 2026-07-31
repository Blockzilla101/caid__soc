`include "riscv_def.vh"

`timescale 1ns / 1ps

module program_counter (
    input clk,
    input rst,
    input [31:0] next_val,
    output [31:0] pc_val
);
    reg [31:0] counter;

    always @(posedge clk or posedge rst) begin
        if (rst) counter <= 0;
        else counter <= next_val;
    end

    assign pc_val = counter;

endmodule
