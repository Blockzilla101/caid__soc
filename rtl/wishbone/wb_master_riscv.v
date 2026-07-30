`include "wb_def.vh"

`timescale 1ns / 1ps

// supports only single tranfers, no block transfers

module wb_master_riscv (
    input wb_CLK_I,
    input wb_RST_I,

    input [31:0] wb_DAT_I,
    output reg [31:0] wb_DAT_O,

    output reg [`WB_ADDR_SIZE] wb_ADR_O,

    input wb_ACK_I,
    output reg wb_CYC_O,
    output reg [`WB_SEL_SIZE] wb_SEL_O,
    output reg wb_STB_O,
    output reg wb_WE_O
);
    wire cpu_transfer_enable;
    wire cpu_write_bus;
    wire [31:0] cpu_write_data;
    wire [`WB_ADDR_SIZE] cpu_addr;
    wire [`WB_SEL_SIZE] cpu_sel;
    reg [31:0] cpu_read_data;
    reg cpu_transfer_complete;

    riscv_top riscv (
        .clk(wb_CLK_I),
        .rst(wb_RST_I),

        .wb_transfer_enable(cpu_transfer_enable),
        .wb_write_bus(cpu_write_bus),
        .wb_write_data(cpu_write_data),
        .wb_addr(cpu_addr),
        .wb_sel(cpu_sel),
        .wb_read_data(cpu_read_data),
        .wb_transfer_complete(cpu_transfer_complete)
    );

    reg [1:0] state;

    always @(*) begin
        if (wb_RST_I) begin
            state = `WB_STATE_INACTIVE;
            cpu_transfer_complete = 0;
            cpu_read_data = 0;
            wb_WE_O = 0;
            wb_CYC_O = 0;
            wb_STB_O = 0;
            wb_ADR_O = 0;
        end

        case (state)
            `WB_STATE_INACTIVE: begin
                if (cpu_transfer_enable) begin
                    state = cpu_write_bus ? `WB_STATE_WRITE_SINGLE : `WB_STATE_READ_SINGLE;
                    if (cpu_write_bus) wb_DAT_O = cpu_write_data;
                    wb_WE_O = cpu_write_bus;
                    wb_CYC_O = 1;
                    wb_STB_O = 1;
                    wb_SEL_O = cpu_sel;
                    wb_ADR_O = cpu_addr;
                    cpu_transfer_complete = 0;
                end
            end

            `WB_STATE_READ_SINGLE: begin
                if (wb_ACK_I) begin
                    state = `WB_STATE_INACTIVE;
                    cpu_read_data = wb_DAT_I;
                    cpu_read_data = 0;
                    wb_WE_O = 0;
                    wb_CYC_O = 0;
                    wb_STB_O = 0;
                    cpu_transfer_complete = 1;
                end
            end

            `WB_STATE_WRITE_SINGLE: begin
                if (wb_ACK_I) begin
                    state = `WB_STATE_INACTIVE;
                    cpu_read_data = 0;
                    wb_WE_O = 0;
                    wb_CYC_O = 0;
                    wb_STB_O = 0;
                    cpu_transfer_complete = 1;
                end
            end
        endcase
    end
endmodule
