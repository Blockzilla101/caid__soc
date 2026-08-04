module fpga_top (
    input      clk_i,
    output reg rgb_led_r,
    output reg rgb_led_g,
    output reg rgb_led_b
);
    wire rst_s;

    rst_gen rst_inst (
        .clk_i(clk_i),
        .rst_i(1'b0),
        .rst_o(rst_s)
    );

    wb_top wb (
        .clk(clk_i),
        .rst(rst_s)
    );

endmodule
