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
    input wb_WE_I,

    input wb_TGD_I
);
    reg [7:0] memory[`SIZE_DATA_MEM];

    always @(posedge wb_CLK_I or posedge wb_RST_I) begin
        if (wb_RST_I) begin
            wb_ACK_O <= 0;
            wb_DAT_O <= 0;
        end else begin
            wb_ACK_O <= 0;

            if (wb_STB_I && wb_CYC_I && !wb_ACK_O) begin

                wb_DAT_O <= 0;
                if (wb_WE_I) begin
                    if (wb_SEL_I[0]) memory[wb_ADR_I+0] <= wb_DAT_I[7:0];
                    if (wb_SEL_I[1]) memory[wb_ADR_I+1] <= wb_DAT_I[15:8];
                    if (wb_SEL_I[2]) memory[wb_ADR_I+2] <= wb_DAT_I[23:16];
                    if (wb_SEL_I[3]) memory[wb_ADR_I+3] <= wb_DAT_I[31:24];
                end else begin
                    case (wb_SEL_I)
                        4'b0001: wb_DAT_O <= {wb_TGD_I ? 24'h0 : {24{memory[wb_ADR_I][7]}}, memory[wb_ADR_I]};
                        4'b0011: wb_DAT_O <= {wb_TGD_I ? 16'h0 : {16{memory[wb_ADR_I+32'h1][7]}}, memory[wb_ADR_I+32'h1], memory[wb_ADR_I]};
                        4'b1111: wb_DAT_O <= {memory[wb_ADR_I+32'h3], memory[wb_ADR_I+32'h2], memory[wb_ADR_I+32'h1], memory[wb_ADR_I]};
                        default: wb_DAT_O <= 32'b0;
                    endcase
                end

                wb_ACK_O <= 1;
            end
        end
    end

endmodule
