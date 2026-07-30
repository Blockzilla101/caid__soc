`include "wb_def.vh"

module wb_slave_addr (
    input [`WB_SEL_ADDR_SIZE] wb_ADR_I,
    output reg wb_SLV_SEL
);
    always @(*) begin
        case (wb_ADR_I)
            0: wb_SLV_SEL <= 0;
            1: wb_SLV_SEL <= 1;
        endcase
    end
endmodule
