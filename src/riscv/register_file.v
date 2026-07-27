`timescale 1ns / 1ps

module register_file (
    input clk,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input [31:0] write_data,
    input write_enable,
    output reg [31:0] rs1_data,
    output reg [31:0] rs2_data
);
    reg [31:0] registers[32];

    always @(posedge clk) begin
        if (write_enable && rd != 0) registers[rd] = write_data;
    end

    always @(*) begin
        rs1_data <= rs1 == 0 ? 0 : registers[rs1];
        rs2_data <= rs2 == 0 ? 0 : registers[rs2];
    end
endmodule
