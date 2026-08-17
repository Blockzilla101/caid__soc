`timescale 1ns / 1ps
`include "../include/wb_def.vh"
`include "../include/global_def.vh"

module wb_slave_data_mem_asic (
`ifdef USE_POWER_PINS
    inout vdd,
    inout vss,
`endif
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
    wire [31:0] word_addr = wb_ADR_I[31:2];
    wire [ 1:0] byte_off = wb_ADR_I[1:0];

    (* keep_hierarchy = "yes" *)
    sram22_1024x32m8w8 wb_slave_sram (
`ifdef USE_POWER_PINS
        .vdd(vdd),
        .vss(vss),
`endif
        .clk(wb_CLK_I),
        .rstb(1'b1),
        .ce(1'b1),
        .we(~wb_WE_I & wb_ACK_O),
        .wmask(4'b1111),
        .addr({word_addr, 2'b0}),
        .din(write_word),
        .dout(read_word)
    );

    wire [31:0] read_word;
    reg  [31:0] write_word;

    always @(posedge wb_CLK_I or posedge wb_RST_I) begin
        if (wb_RST_I) begin
            wb_ACK_O <= 0;
            wb_DAT_O <= 0;
        end else begin
            wb_ACK_O <= 0;
            wb_DAT_O <= 0;

            if (wb_STB_I && wb_CYC_I && !wb_ACK_O) begin
                wb_DAT_O <= 0;
                if (wb_WE_I) begin
                    write_word <= read_word;

                    if (wb_SEL_I[0]) write_word[7:0] <= wb_DAT_I[7:0];
                    if (wb_SEL_I[1]) write_word[15:8] <= wb_DAT_I[15:8];
                    if (wb_SEL_I[2]) write_word[23:16] <= wb_DAT_I[23:16];
                    if (wb_SEL_I[3]) write_word[31:24] <= wb_DAT_I[31:24];

                end else begin
                    case (wb_SEL_I)
                        4'b0001: begin
                            case (byte_off)
                                0: wb_DAT_O <= {wb_TGD_I ? 24'h0 : {24{read_word[7]}}, read_word[7:0]};
                                1: wb_DAT_O <= {wb_TGD_I ? 24'h0 : {24{read_word[15]}}, read_word[15:8]};
                                2: wb_DAT_O <= {wb_TGD_I ? 24'h0 : {24{read_word[23]}}, read_word[23:16]};
                                3: wb_DAT_O <= {wb_TGD_I ? 24'h0 : {24{read_word[31]}}, read_word[31:24]};
                                default: wb_DAT_O <= 0;
                            endcase
                        end
                        4'b0011: begin
                            case (byte_off)
                                0: wb_DAT_O <= wb_DAT_O <= {wb_TGD_I ? 16'h0 : {16{read_word[15]}}, read_word[15:0]};
                                1: wb_DAT_O <= wb_DAT_O <= {wb_TGD_I ? 16'h0 : {16{read_word[31]}}, read_word[31:16]};
                                default: wb_DAT_O <= 0;
                            endcase
                        end
                        4'b1111: wb_DAT_O <= read_word;
                        default: wb_DAT_O <= 32'b0;
                    endcase
                end

                wb_ACK_O <= 1;
            end
        end
    end
endmodule
