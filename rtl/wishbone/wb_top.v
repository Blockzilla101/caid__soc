`include "../include/wb_def.vh"

module wb_top (
    input clk,
    input rst,

    output [7:0] gpio_data
);
    wire SLV_SEL;

    wire [31:0] m_DAT_I;
    wire [31:0] m_DAT_O;

    wire [`WB_ADDR_SIZE] m_ADR_O;

    wire m_ACK_I;
    wire m_CYC_O;
    wire [`WB_SEL_SIZE] m_SEL_O;
    wire m_STB_O;
    wire m_WE_O;
    wire m_TGD_O;

    wb_master_riscv wb_riscv (
        .wb_CLK_I(clk),
        .wb_RST_I(rst),

        .wb_SLV_SEL(SLV_SEL),

        .wb_DAT_I(m_DAT_I),
        .wb_DAT_O(m_DAT_O),

        .wb_ADR_O(m_ADR_O),
        .wb_ACK_I(m_ACK_I),
        .wb_CYC_O(m_CYC_O),
        .wb_SEL_O(m_SEL_O),
        .wb_STB_O(m_STB_O),
        .wb_WE_O (m_WE_O),

        .wb_TGD_O(m_TGD_O)
    );

    wire [31:0] slv0_DAT_I;
    wire [31:0] slv0_DAT_O;

    wire slv0_ACK_O;

    wire [`WB_ADDR_SIZE] slv0_ADR_I;
    wire slv0_CYC_I;
    wire [`WB_SEL_SIZE] slv0_SEL_I;
    wire slv0_STB_I;
    wire slv0_WE_I;

    wire slv0_TGD_I;

    wb_slave_data_mem wb_data_mem (
        .wb_CLK_I(clk),
        .wb_RST_I(rst),

        .wb_DAT_I(slv0_DAT_I),
        .wb_DAT_O(slv0_DAT_O),

        .wb_TGD_I(slv0_TGD_I),

        .wb_ACK_O(slv0_ACK_O),

        .wb_ADR_I(slv0_ADR_I),
        .wb_CYC_I(slv0_CYC_I),
        .wb_SEL_I(slv0_SEL_I),
        .wb_STB_I(slv0_STB_I),
        .wb_WE_I (slv0_WE_I)
    );

    wire [31:0] slv1_DAT_I;
    wire [31:0] slv1_DAT_O;

    wire slv1_ACK_O;

    wire [`WB_ADDR_SIZE] slv1_ADR_I;
    wire slv1_CYC_I;
    wire [`WB_SEL_SIZE] slv1_SEL_I;
    wire slv1_STB_I;
    wire slv1_WE_I;

    wire slv1_TGD_I;

    wb_slave_gpio wb_gpio (
        .wb_CLK_I(clk),
        .wb_RST_I(rst),

        .wb_DAT_I(slv1_DAT_I),
        .wb_DAT_O(slv1_DAT_O),

        .wb_TGD_I(slv1_TGD_I),

        .wb_ACK_O(slv1_ACK_O),

        .wb_ADR_I(slv1_ADR_I),
        .wb_CYC_I(slv1_CYC_I),
        .wb_SEL_I(slv1_SEL_I),
        .wb_STB_I(slv1_STB_I),
        .wb_WE_I (slv1_WE_I),

        .gpio_data(gpio_data)
    );

    wb_slave_addr wb_addr_decoder (
        .wb_ADR_I  (m_ADR_O),
        .wb_SLV_SEL(SLV_SEL)
    );

    wb_mux wb_mux (
        .wb_SLV_SEL(SLV_SEL),

        .m_DAT_I(m_DAT_I),
        .m_DAT_O(m_DAT_O),

        // master

        .m_ADR_O(m_ADR_O),
        .m_CYC_O(m_CYC_O),
        .m_SEL_O(m_SEL_O),
        .m_STB_O(m_STB_O),
        .m_WE_O (m_WE_O),

        .m_ACK_I(m_ACK_I),

        .m_TGD_O(m_TGD_O),

        // slave 0

        .slv0_DAT_I(slv0_DAT_I),
        .slv0_DAT_O(slv0_DAT_O),

        .slv0_ACK_O(slv0_ACK_O),
        .slv0_ADR_I(slv0_ADR_I),
        .slv0_CYC_I(slv0_CYC_I),
        .slv0_SEL_I(slv0_SEL_I),
        .slv0_STB_I(slv0_STB_I),
        .slv0_WE_I (slv0_WE_I),

        .slv0_TGD_I(slv0_TGD_I),

        // slave 1

        .slv1_DAT_I(slv1_DAT_I),
        .slv1_DAT_O(slv1_DAT_O),

        .slv1_ACK_O(slv1_ACK_O),
        .slv1_ADR_I(slv1_ADR_I),
        .slv1_CYC_I(slv1_CYC_I),
        .slv1_SEL_I(slv1_SEL_I),
        .slv1_STB_I(slv1_STB_I),
        .slv1_WE_I (slv1_WE_I),

        .slv1_TGD_I(slv1_TGD_I)
    );
endmodule
