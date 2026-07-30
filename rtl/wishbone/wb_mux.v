`include "wb_def.vh"

`timescale 1ns / 1ps


module wb_mux (
    input wb_SLV_SEL,

    // input CLK_I,
    // input RST_I,

    output reg [31:0] m_DAT_I,
    input [31:0] m_DAT_O,

    // master

    input [`WB_ADDR_SIZE] m_ADR_O,
    input m_CYC_O,
    input [`WB_SEL_SIZE] m_SEL_O,
    input m_STB_O,
    input m_WE_O,

    output reg m_ACK_I,

    // slave 0

    output reg [31:0] slv0_DAT_I,
    input [31:0] slv0_DAT_O,

    input slv0_ACK_O,
    output [`WB_ADDR_SIZE] slv0_ADR_I,
    output slv0_CYC_I,
    output [`WB_SEL_SIZE] slv0_SEL_I,
    output reg slv0_STB_I,
    output slv0_WE_I,

    // slave 1

    output reg [31:0] slv1_DAT_I,
    input [31:0] slv1_DAT_O,

    input slv1_ACK_O,
    output [`WB_ADDR_SIZE] slv1_ADR_I,
    output slv1_CYC_I,
    output [`WB_SEL_SIZE] slv1_SEL_I,
    output reg slv1_STB_I,
    output slv1_WE_I
);

    assign slv0_ADR_I = m_ADR_O;
    assign slv1_ADR_I = m_ADR_O;

    assign slv0_CYC_I = m_CYC_O;
    assign slv1_CYC_I = m_CYC_O;

    assign slv0_SEL_I = m_SEL_O;
    assign slv1_SEL_I = m_SEL_O;

    assign slv0_WE_I  = m_WE_O;
    assign slv1_WE_I  = m_WE_O;

    always @(*) begin
        case (wb_SLV_SEL)
            0: begin
                m_DAT_I = slv0_DAT_O;
                m_ACK_I = slv0_ACK_O;
                slv0_DAT_I = m_DAT_O;
                slv0_STB_I = m_STB_O;
            end

            1: begin
                m_DAT_I = slv1_DAT_O;
                m_ACK_I = slv1_ACK_O;
                slv1_DAT_I = m_DAT_O;
                slv1_STB_I = m_STB_O;
            end
        endcase
    end
endmodule
