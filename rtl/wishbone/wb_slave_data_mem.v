`include "../include/wb_def.vh"
`include "../include/global_def.vh"

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
    localparam integer WORDS = `SIZE_DATA_MEM / 4;
    reg [31:0] memory[0:WORDS-1];

    wire [31:0] word_addr = wb_ADR_I[31:2];
    wire [1:0] byte_off = wb_ADR_I[1:0];

    wire [31:0] read_word = memory[word_addr];

    reg [31:0] write_word;

    always @(posedge wb_CLK_I) begin
        if (wb_ACK_O && wb_WE_I) begin
            memory[word_addr] = write_word;
        end
    end

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
                    // fixme this should use byte offset as well

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

    // localparam integer WORDS = `SIZE_DATA_MEM / 4;
    // reg [31:0] memory[0:WORDS-1];

    // wire [31:0] word_addr = wb_ADR_I[31:2];
    // wire [1:0] byte_off = wb_ADR_I[1:0];

    // wire [31:0] word_addr = wb_ADR_I[31:2];
    // wire [1:0] byte_off = wb_ADR_I[1:0];

    // reg [31:0] write_word;
    // reg [31:0] read_word;

    // always @(*) begin
    //     read_word = memory[word_addr];
    // end

    // always @(*) begin
    //     write_word = memory[word_addr];

    //     case (wb_SEL_I)
    //         4'b0001: begin
    //             case (byte_off)
    //                 2'd0: write_word[7:0] = wb_DAT_I[7:0];
    //                 2'd1: write_word[15:8] = wb_DAT_I[7:0];
    //                 2'd2: write_word[23:16] = wb_DAT_I[7:0];
    //                 2'd3: write_word[31:24] = wb_DAT_I[7:0];
    //             endcase
    //         end

    //         4'b0011: begin
    //             if (byte_off[1] == 1'b0) begin
    //                 write_word[15:0] = wb_DAT_I[15:0];
    //             end else begin
    //                 write_word[31:16] = wb_DAT_I[15:0];
    //             end
    //         end

    //         4'b1111: begin
    //             write_word = wb_DAT_I;
    //         end

    //         default: begin
    //         end
    //     endcase
    // end

    // always @(posedge wb_CLK_I or posedge wb_RST_I) begin
    //     if (wb_RST_I) begin
    //         wb_ACK_O <= 1'b0;
    //         wb_DAT_O <= 32'b0;
    //     end else begin
    //         wb_ACK_O <= 1'b0;

    //         if (wb_STB_I && wb_CYC_I) begin
    //             if (wb_WE_I) begin
    //                 memory[word_addr] <= write_word;
    //                 wb_DAT_O <= 32'b0;
    //             end else begin
    //                 case (wb_SEL_I)
    //                     4'b0001: begin
    //                         case (byte_off)
    //                             2'd0: wb_DAT_O <= wb_TGD_I ? {{24{read_word[7]}}, read_word[7:0]} : {24'b0, read_word[7:0]};
    //                             2'd1: wb_DAT_O <= wb_TGD_I ? {{24{read_word[15]}}, read_word[15:8]} : {24'b0, read_word[15:8]};
    //                             2'd2: wb_DAT_O <= wb_TGD_I ? {{24{read_word[23]}}, read_word[23:16]} : {24'b0, read_word[23:16]};
    //                             2'd3: wb_DAT_O <= wb_TGD_I ? {{24{read_word[31]}}, read_word[31:24]} : {24'b0, read_word[31:24]};
    //                         endcase
    //                     end

    //                     4'b0011: begin
    //                         if (byte_off[1] == 1'b0) begin
    //                             wb_DAT_O <= wb_TGD_I ? {{16{read_word[15]}}, read_word[15:0]} : {16'b0, read_word[15:0]};
    //                         end else begin
    //                             wb_DAT_O <= wb_TGD_I ? {{16{read_word[31]}}, read_word[31:16]} : {16'b0, read_word[31:16]};
    //                         end
    //                     end

    //                     4'b1111: begin
    //                         wb_DAT_O <= read_word;
    //                     end

    //                     default: begin
    //                         wb_DAT_O <= 32'b0;
    //                     end
    //                 endcase
    //             end

    //             wb_ACK_O <= 1'b1;
    //         end
    //     end
    // end
endmodule
