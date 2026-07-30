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
    reg [1:0] state;

    reg [7:0] memory[`SIZE_DATA_MEM];

    reg [`WB_ADDR_SIZE] m_addr;
    reg [31:0] m_write_data;
    reg m_write_enable;
    reg [`WB_SEL_SIZE] m_write_sel;

    localparam IDLE = 2'b00;
    localparam PROCESS = 2'b01;
    localparam WAIT_CYCLE = 2'b10;

    always @(posedge wb_CLK_I or posedge wb_RST_I) begin
        if (wb_RST_I) begin
            state <= IDLE;
            wb_ACK_O <= 0;
            wb_DAT_O <= 0;
            m_write_data <= 0;
            m_write_enable <= 0;
        end else begin
            if (!wb_CYC_I || !wb_STB_I) begin
                wb_ACK_O <= 0;
            end

            case (state)
                IDLE: begin
                    wb_DAT_O <= 0;
                    if (wb_STB_I) begin
                        state <= PROCESS;
                        if (wb_WE_I) m_write_data <= wb_DAT_I;
                        m_write_enable <= wb_WE_I;
                        m_write_sel <= wb_SEL_I;
                        m_addr <= wb_ADR_I;
                    end
                end
                PROCESS: begin
                    if (m_write_enable) begin
                        if (m_write_sel[0]) memory[m_addr+0] <= m_write_data[7:0];
                        if (m_write_sel[1]) memory[m_addr+1] <= m_write_data[15:8];
                        if (m_write_sel[2]) memory[m_addr+2] <= m_write_data[23:16];
                        if (m_write_sel[3]) memory[m_addr+3] <= m_write_data[31:24];
                    end else begin
                        wb_DAT_O <= 0;
                        if (m_write_sel[0]) wb_DAT_O[7:0] <= memory[m_addr+0];
                        if (m_write_sel[1]) wb_DAT_O[15:8] <= memory[m_addr+1];
                        if (m_write_sel[2]) wb_DAT_O[23:16] <= memory[m_addr+2];
                        if (m_write_sel[3]) wb_DAT_O[31:24] <= memory[m_addr+3];
                    end

                    wb_ACK_O <= 1;
                    m_write_enable <= 0;
                    m_write_sel <= 0;
                    m_write_data <= 0;
                    state <= IDLE;
                end
            endcase
        end

    end

endmodule
