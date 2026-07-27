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
        if (write_enable) begin
            case (width)
                `MEM_WIDTH_HALF: begin
                    memory[addr+32'h1] <= write_data[15:8];
                    memory[addr] <= write_data[7:0];
                end
                `MEM_WIDTH_BYTE: begin
                    memory[addr] <= write_data[7:0];
                end
                default: begin  // word
                    memory[addr+32'h3] <= write_data[31:24];
                    memory[addr+32'h2] <= write_data[23:16];
                    memory[addr+32'h1] <= write_data[15:8];
                    memory[addr] <= write_data[7:0];
                end
            endcase
        end
    end

    always @(*) begin
        case (width)
            `MEM_WIDTH_HALF: begin
                read_data <= {read_unsigned ? 16'h0000 : {16{memory[addr+32'h1][7]}}, memory[addr+32'h1], memory[addr]};
            end
            `MEM_WIDTH_BYTE: begin
                read_data <= {read_unsigned ? 24'h0 : {24{memory[addr][7]}}, memory[addr]};
            end
            default: begin  // word
                read_data <= {memory[addr+32'h3], memory[addr+32'h2], memory[addr+32'h1], memory[addr]};
            end
        endcase
    end
endmodule
