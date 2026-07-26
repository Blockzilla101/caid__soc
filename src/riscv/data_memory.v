`include "global_params.vh"

`timescale 1ns / 1ps

module data_memory (
    input clk,
    input [31:0] addr,
    input [31:0] write_data,
    input write_enable,
    input [2:0] funct3,
    output reg [31:0] read_data
);
    reg [7:0] memory[1024];

    wire [2:0] width = funct3[1:0];
    wire read_unsigned = funct3[2];

    always @(posedge clk) begin
        case (width)
            `MEM_WIDTH_HALF: begin
                if (write_enable) begin
                    memory[addr] <= write_data[15:8];
                    memory[addr+32'h1] <= write_data[7:0];
                end
                read_data <= read_unsigned ? {16'h0000, memory[addr], memory[addr+32'h1]} : $signed({memory[addr], memory[addr+32'h1]});
            end
            `MEM_WIDTH_BYTE: begin
                if (write_enable) begin
                    memory[addr] <= write_data[7:0];
                end
                read_data <= read_unsigned ? {24'h0000_00, memory[addr]} : $signed(memory[addr]);
            end
            default: begin  // word
                if (write_enable) begin
                    memory[addr] <= write_data[31:24];
                    memory[addr+32'h1] <= write_data[23:16];
                    memory[addr+32'h2] <= write_data[15:8];
                    memory[addr+32'h3] <= write_data[7:0];
                end
                read_data <= {memory[addr], memory[addr+32'h1], memory[addr+32'h2], memory[addr+32'h3]};
            end
        endcase
    end
endmodule
