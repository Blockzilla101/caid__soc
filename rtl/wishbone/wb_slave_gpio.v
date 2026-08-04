`include "../include/wb_def.vh"

module wb_slave_gpio (
    input wb_CLK_I,
    input wb_RST_I,

    input [31:0] wb_DAT_I,
    output reg [31:0] wb_DAT_O,

    output reg wb_ACK_O,

    input [`WB_ADDR_SIZE] wb_ADR_I,
    input wb_CYC_I,
    input [`WB_SEL_SIZE] wb_SEL_I,
    input wb_STB_I,
    input wb_WE_I,

    input wb_TGD_I,

    inout gpio_data
);
    reg [7:0] gpio_reg;

    always @(posedge wb_CLK_I or posedge wb_RST_I) begin
        if (wb_RST_I) begin
            wb_ACK_O <= 0;
            wb_DAT_O <= 0;

            gpio_reg <= 0;
        end else begin
            wb_ACK_O <= 0;

            if (wb_STB_I && wb_CYC_I && !wb_ACK_O) begin

                wb_DAT_O <= 0;
                if (wb_WE_I) begin
                    if (wb_SEL_I[0]) gpio_reg <= wb_DAT_I[7:0];
                end else begin
                    wb_DAT_O <= wb_SEL_I[0] ? {24'b0, gpio_reg} : 32'b0;
                end

                wb_ACK_O <= 1;
            end
        end
    end

    assign gpio_data = gpio_reg;

endmodule
