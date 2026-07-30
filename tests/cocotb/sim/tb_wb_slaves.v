`include "wb_def.vh"

module tb_wb_slaves ();
    reg wb_CLK_I;
    reg wb_RST_I;

    reg [31:0] wb_DAT_I;

    reg [`WB_ADDR_SIZE] wb_ADR_I;
    reg wb_CYC_I;
    reg [`WB_SEL_SIZE] wb_SEL_I;
    reg wb_STB_I;
    reg wb_WE_I;

    wire [31:0] wb_DAT_O;
    wire wb_ACK_O;

    wb_slave_data_mem wb_data_mem (
        .wb_CLK_I(wb_CLK_I),
        .wb_RST_I(wb_RST_I),

        .wb_DAT_I(wb_DAT_I),
        .wb_DAT_O(wb_DAT_O),

        .wb_ACK_O(wb_ACK_O),

        .wb_ADR_I(wb_ADR_I),
        .wb_CYC_I(wb_CYC_I),
        .wb_SEL_I(wb_SEL_I),
        .wb_STB_I(wb_STB_I),
        .wb_WE_I (wb_WE_I)
    );

    initial wb_CLK_I = 0;
    always #5 wb_CLK_I = ~wb_CLK_I;

    initial begin
        wb_DAT_I = 0;
        wb_ADR_I = 0;
        wb_CYC_I = 0;
        wb_SEL_I = 0;
        wb_STB_I = 0;
        wb_WE_I  = 0;

        repeat (2) @(posedge wb_CLK_I);

        wb_RST_I = 1;
        @(posedge wb_CLK_I);

        wb_RST_I = 0;
        @(posedge wb_CLK_I);

        wb_DAT_I = 32'hA0B0C0D0;
        wb_ADR_I = 0;
        wb_CYC_I = 1;
        wb_SEL_I = 4'b1001;
        wb_STB_I = 1;
        wb_WE_I  = 1;

        repeat (2) @(posedge wb_CLK_I);

        wb_DAT_I = 0;
        wb_ADR_I = 0;
        wb_CYC_I = 0;
        wb_SEL_I = 0;
        wb_STB_I = 0;
        wb_WE_I  = 0;

        repeat (3) @(posedge wb_CLK_I);

        wb_ADR_I = 0;
        wb_CYC_I = 1;
        wb_SEL_I = 4'b1001;
        wb_STB_I = 1;
        wb_WE_I  = 0;

        repeat (2) @(posedge wb_CLK_I);

        wb_DAT_I = 0;
        wb_ADR_I = 0;
        wb_CYC_I = 0;
        wb_SEL_I = 0;
        wb_STB_I = 0;
        wb_WE_I  = 0;

        repeat (3) @(posedge wb_CLK_I);
    end

endmodule
