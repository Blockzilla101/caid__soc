`define IMEM_LOAD_HEX
`define IMEM_HEX_PATH "/home/blockzilla/ic-design/projects/caid__soc/tests/gcc/build/wb_fpga_test.mem"
`define WISHBONE_ENABLE

module fpga_top (
    input clk_i,

    output [5:0] gpio
);
    wire rst_s;

    rst_gen rst_inst (
        .clk_i(clk_i),
        .rst_i(1'b0),
        .rst_o(rst_s)
    );

    wb_top wb (
        .clk(clk_i),
        .rst(rst_s),

        .gpio_data(gpio)
    );

endmodule
