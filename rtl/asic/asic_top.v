`define IMEM_LOAD_HEX
`define IMEM_HEX_PATH "/home/blockzilla/ic-design/projects/caid__soc/tests/gcc/build/wb_fpga_test.mem"

module asic_top (
`ifdef USE_POWER_PINS
    inout vccd1,
    inout vssd1,
`endif
    input clk,
    input rst,
    output [7:0] gpio
    // output [31:0] gpio
);
    (* keep_hierarchy = "yes" *)
    wb_top wb (
`ifdef USE_POWER_PINS
        .vccd1(vccd1),
        .vssd1(vssd1),
`endif
        .clk  (clk),
        .rst  (rst),

        .gpio_data(gpio)
    );
endmodule
