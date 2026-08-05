`timescale 1ns / 1ps

module register_file (
    input clk,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input [31:0] write_data,
    input write_enable,
    output [31:0] rs1_data,
    output [31:0] rs2_data
);
    reg [31:0] registers[0:31];

    // initial begin
    //     integer i;
    //     for (i = 1; i < 32; i = i + 1) begin
    //         registers[i] = 32'b0;
    //     end
    // end

    always @(posedge clk) begin
        if (write_enable && rd != 5'd0) registers[rd] <= write_data;
    end

    assign rs1_data = rs1 == 5'd0 ? 32'b0 : registers[rs1];
    assign rs2_data = rs2 == 5'd0 ? 32'b0 : registers[rs2];
endmodule
