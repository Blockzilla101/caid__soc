`timescale 1ns/1ps

module data_memory (
    input clk,
    input [31:0] addr,
    input [31:0] write_data,
    input write_enable,
    output reg read_data
);
    reg [31:0] memory [512:0];

    always @(posedge clk) begin
        if (write_enable) memory[rd] = write_data;
        read_data <= memory[addr];
    end
endmodule