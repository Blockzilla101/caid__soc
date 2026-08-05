`define IMEM_LOAD_HEX
`define IMEM_HEX_PATH "/home/blockzilla/ic-design/projects/caid__soc/tests/gcc/build/wb_fpga_test.mem"
`define WISHBONE_ENABLE

module fpga_top (
    input  clk_i,
    output rgb_led_r,
    output rgb_led_g,
    output rgb_led_b,

    output ext_io_1,
    output ext_io_2,
    output ext_io_3,
    output ext_io_4
);
    wire rst_s;

    wire [7:0] gpio_data;

    assign rgb_led_r = gpio_data[0];
    assign rgb_led_g = gpio_data[1];
    assign rgb_led_b = gpio_data[2];

    assign ext_io_1  = gpio_data[3];
    assign ext_io_2  = gpio_data[4];
    assign ext_io_3  = gpio_data[5];
    assign ext_io_4  = gpio_data[6];

    rst_gen rst_inst (
        .clk_i(clk_i),
        .rst_i(1'b0),
        .rst_o(rst_s)
    );

    wb_top wb (
        .clk(clk_i),
        .rst(rst_s),

        .gpio_data(gpio_data)
    );

endmodule
