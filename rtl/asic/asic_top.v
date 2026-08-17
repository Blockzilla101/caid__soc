module asic_top (
`ifdef USE_POWER_PINS
    inout vccd1,
    inout vssd1,
`endif
    input clk,
    input rst,
    // output [7:0] gpio
    output [31:0] gpio
);
    sram_1rw1r_32x1024 wb_slave_sram (
`ifdef USE_POWER_PINS
        .vccd1 (vccd1),
        .vssd1 (vssd1),
`endif
        .clk0  (clk),
        .csb0  (1'b0),
        .web0  (1),
        .wmask0(0),
        .addr0 (10'b0),
        .din0  (32'b0),
        .dout0 (gpio),

        .clk1 (clk),
        .csb1 (1'b1),
        .addr1(10'b0),
        .dout1()

    );

endmodule
