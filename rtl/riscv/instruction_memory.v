`include "../include/riscv_def.vh"
`include "../include/global_def.vh"

`timescale 1ns / 1ps

module instruction_memory (
    input clk,
    input [31:0] addr,
    output [31:0] read_data
);
    localparam integer WORDS = `SIZE_INST_MEM / 4;
    reg [31:0] memory[0:WORDS-1];

    initial begin
        // integer i;
        // for (i = 0; i < WORDS; i = i + 1) begin
        // memory[i] = 32'h0000_0013;
        // end
`ifdef IMEM_LOAD_HEX
        $readmemh(`IMEM_HEX_PATH, memory);
`endif
    end

    assign read_data = {memory[addr[31:2]]};

endmodule
