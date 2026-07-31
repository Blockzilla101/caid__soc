`timescale 1ns / 1ps

module register_file (
    input clk,
    input rst,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input [31:0] write_data,
    input write_enable,
    output [31:0] rs1_data,
    output [31:0] rs2_data
);
    reg [31:0] registers[32];

    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 32'b0;
            end
        end else begin
            if (write_enable && rd != 0) registers[rd] = write_data;
        end
    end

    assign rs1_data = rs1 == 0 ? 0 : registers[rs1];
    assign rs2_data = rs2 == 0 ? 0 : registers[rs2];
endmodule
