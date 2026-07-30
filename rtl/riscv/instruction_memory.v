`include "global_def.vh"

`timescale 1ns / 1ps

module instruction_memory (
    input clk,
    input [31:0] addr,
    output [31:0] read_data
);
    reg [7:0] memory[`SIZE_INST_MEM];

`ifdef IMEM_LOAD_HEX
    initial begin
        $readmemh(`IMEM_HEX_PATH, memory);
    end
`endif

    assign read_data = {memory[addr+32'h3], memory[addr+32'h2], memory[addr+32'h1], memory[addr+32'h0]};

endmodule
