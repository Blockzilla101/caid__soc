`include "global_def.vh"

`timescale 1ns / 1ps

module instruction_memory (
    input clk,
    input [31:0] addr,
    output [31:0] read_data
);
    reg [7:0] memory[`SIZE_INST_MEM];

    initial begin
        integer i;
        for (i = 0; i < `SIZE_INST_MEM; i = i + 4) begin
            memory[i+0] = 8'h13;
            memory[i+1] = 8'h00;
            memory[i+2] = 8'h00;
            memory[i+3] = 8'h00;
        end
`ifdef IMEM_LOAD_HEX
        $readmemh(`IMEM_HEX_PATH, memory, 0);
`endif
    end

    assign read_data = {memory[addr+32'h3], memory[addr+32'h2], memory[addr+32'h1], memory[addr+32'h0]};

endmodule
