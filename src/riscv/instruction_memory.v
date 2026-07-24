`timescale 1ns/1ps

module instruction_memory (
    input clk,
    input [31:0] addr,
    input [31:0] write_data,
    output reg read_data
);
    reg [31:0] memory [512:0];

    always @(posedge clk) begin
        read_data <= memory[addr];
    end
endmodule