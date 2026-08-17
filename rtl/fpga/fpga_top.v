`define IMEM_LOAD_HEX
`define IMEM_HEX_PATH "/home/blockzilla/ic-design/projects/caid__soc/tests/gcc/build/wb_fpga_test.mem"
`define WISHBONE_ENABLE

module fpga_top (
    input clk_i,

`ifdef TANGNANO9k
    output [5:0] gpio
`else
    output [6:0] gpio
`endif
);
    wire rst_s;

    // rst_gen rst_inst (
    //     .clk_i(clk_i),
    //     .rst_i(1'b0),
    //     .rst_o(rst_s)
    // );

    // wb_top wb (
    //     .clk(clk_i),
    //     .rst(rst_s),

    //     .gpio_data(gpio)
    // );

    sram_1rw1r_32x1024 wb_slave_sram (
`ifdef USE_POWER_PINS
        .vccd1 (),
        .vssd1 (),
`endif
        .clk0  (clk_i),
        .csb0  (1'b0),
        .web0  (1),
        .wmask0(0),
        .addr0 (32'b0),
        .din0  (32'b0),
        .dout0 (gpio),

        .clk1 (clk_i),
        .csb1 (1'b1),
        .addr1(10'b0),
        .dout1()

    );

endmodule
