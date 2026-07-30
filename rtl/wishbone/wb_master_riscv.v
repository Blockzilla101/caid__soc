`include "wb_def.vh"

`timescale 1ns / 1ps

// supports only single tranfers, no block transfers

module wb_master_riscv (
    input cpu_transfer_enable,
    input cpu_write_bus,
    input [31:0] cpu_write_data,
    input [`WB_SEL_SIZE] cpu_sel,
    output [31:0] cpu_read_data,
    output cpu_transfer_complete,

    input wb_CLK_I,
    input wb_RST_I,

    input  [31:0] wb_DAT_I,
    output [31:0] wb_DAT_O,

    input [`WB_ADDR_SIZE] wb_ADR_O,

    input wb_ACK_I,
    output reg wb_CYC_O,
    output reg [`WB_SEL_SIZE] wb_SEL_O,
    output reg wb_STB_O,
    output reg wb_WE_O
);
    reg [1:0] state;

    always @(posedge wb_CLK_I or posedge wb_RST_I) begin
        if (wb_RST_I) begin
            state <= `WB_STATE_INACTIVE;
            cpu_read_data <= 0;
            wb_WE_O <= 0;
            wb_CYC_O <= 0;
            wb_STB_O <= 0;
        end else begin
            case (state)
                `WB_STATE_INACTIVE: begin
                    if (cpu_transfer_enable) begin
                        state <= cpu_write_bus ? `WB_STATE_WRITE_SINGLE : `WB_STATE_READ_SINGLE;
                        wb_WE_O <= cpu_write_bus;
                        wb_CYC_O <= 1;
                        wb_SEL_O <= cpu_sel;
                        if (cpu_write_bus) wb_DAT_O <= cpu_write_data;
                    end
                end

                `WB_STATE_READ_SINGLE: begin
                    if (wb_ACK_I) begin
                        state <= `WB_STATE_TRANSFER_COMPLETE;
                        cpu_read_data <= wb_DAT_I;
                    end
                end

                `WB_STATE_WRITE_SINGLE: begin
                    if (wb_ACK_I) begin
                        state <= `WB_STATE_TRANSFER_COMPLETE;
                    end
                end

                `WB_STATE_TRANSFER_COMPLETE: begin  // potentially makes this module unusable for one cycle
                    state <= `WB_STATE_INACTIVE;
                    cpu_read_data <= 0;
                    wb_WE_O <= 0;
                    wb_CYC_O <= 0;
                    wb_STB_O <= 0;
                end
            endcase
        end
    end

    assign cpu_transfer_complete = state == `WB_STATE_TRANSFER_COMPLETE;

endmodule
