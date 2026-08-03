`include "../include/riscv_def.vh"
`include "../include/wb_def.vh"

module wb_controller (
    // cpu

    input [31:0] instruction,
    input [`CW_LEN] control_word,

    input  [31:0] cpu_write_data,
    output [31:0] cpu_read_data,
    input  [31:0] cpu_addr,

    output cpu_stall,

    // wishbone
    input wb_SLV_SEL,

    input  [31:0] wb_DAT_I,
    output [31:0] wb_DAT_O,

    output [`WB_ADDR_SIZE] wb_ADR_O,

    input wb_ACK_I,
    output wb_CYC_O,
    output reg [`WB_SEL_SIZE] wb_SEL_O,
    output wb_STB_O,
    output wb_WE_O,

    output reg wb_TGD_O
);
    wire wb_access = (control_word[`CW_MEM_WRITE] || control_word[`CW_MEM_READ]);

    assign wb_STB_O = wb_access;
    assign wb_CYC_O = wb_access;

    assign wb_WE_O = wb_access ? control_word[`CW_MEM_WRITE] : 1'b0;
    assign wb_DAT_O = wb_access ? cpu_write_data : 32'b0;
    assign wb_ADR_O = wb_access ? cpu_addr : 32'b0;

    assign cpu_read_data = (wb_ACK_I && !wb_WE_O) ? wb_DAT_I : 32'b0;

    // todo: possible avoid stalling if the instruction isn't dependent on current one
    assign cpu_stall = wb_access && !wb_ACK_I;

    always @(*) begin
        wb_TGD_O = 0;
        wb_SEL_O = 0;
        case (wb_SLV_SEL)
            0: begin
                if (wb_access) begin
                    wb_TGD_O = instruction[14];
                    case (instruction[13:12])
                        `MEM_WIDTH_BYTE: wb_SEL_O = 4'b0001;
                        `MEM_WIDTH_HALF: wb_SEL_O = 4'b0011;
                        default: wb_SEL_O = 4'b1111;
                    endcase
                end
            end

            1: begin
                if (wb_access) begin
                    wb_SEL_O = 4'b0001;
                end
            end
        endcase
    end
endmodule
