`include "wb_def.vh"

`timescale 1ns / 1ps

module wb_slave_data_mem (
    input wb_CLK_I,
    input wb_RST_I,

    input [31:0] wb_DAT_I,
    output reg [31:0] wb_DAT_O,

    output reg wb_ACK_O,

    input [`WB_ADDR_SIZE] wb_ADR_I,
    input wb_CYC_I,
    input [`WB_SEL_SIZE] wb_SEL_I,
    input wb_STB_I,
    input wb_WE_I
);
    reg [`WB_STATE_SIZE] state;

    reg mem_write_enable;
    reg [31:0] mem_write_data;
    wire [31:0] mem_read_data;

    data_memory data_mem (
        .clk(wb_CLK_I),
        .addr(wb_ADR_I & 32'h0000_FFFF),
        .write_data(mem_write_data),
        .write_enable(mem_write_enable),
        .funct3(wb_SEL_I[2:0]),  // fixme this is out of spec, should use tags
        .read_data(mem_read_data)
    );

    always @(posedge wb_CLK_I or posedge wb_RST_I) begin
        if (wb_RST_I) begin
            state <= `WB_STATE_INACTIVE;
            mem_write_enable <= 0;
            wb_ACK_O <= 0;
        end else if (wb_CYC_I && wb_STB_I) begin
            if (wb_WE_I) begin
                mem_write_data <= wb_DAT_I;
                mem_write_enable <= 1;
                wb_ACK_O <= 1;
            end else begin
                mem_write_enable <= 0;
                wb_DAT_O <= mem_read_data;
                wb_ACK_O <= 1;
            end
        end else begin
            mem_write_enable <= 0;
            wb_ACK_O <= 0;
        end
    end

endmodule
