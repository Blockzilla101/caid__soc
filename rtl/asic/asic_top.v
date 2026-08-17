`define IMEM_LOAD_HEX
`define IMEM_HEX_PATH "/home/blockzilla/ic-design/projects/caid__soc/tests/gcc/build/wb_fpga_test.mem"

module asic_top (
`ifdef USE_POWER_PINS
    inout vdd,
    inout vss,
`endif
    input clk,
    input rst,
    output [7:0] gpio
    // output [31:0] gpio
);
    (* keep_hierarchy = "yes" *)
    wb_top wb (
`ifdef USE_POWER_PINS
        .vdd(vdd),
        .vss(vss),
`endif
        .clk(clk),
        .rst(rst),

        .gpio_data(gpio)
    );

    //     sky130_sram_4kbyte_1rw1r_32x1024_8 wb_slave_sram (
    // `ifdef USE_POWER_PINS
    //         .vdd (vdd),
    //         .vss (vss),
    // `endif
    //         .clk0  (clk),
    //         .csb0  (1'b0),
    //         .web0  (1),
    //         .wmask0(0),
    //         .addr0 (10'b0),
    //         .din0  (32'b0),
    //         .dout0 (gpio),

    //         .clk1 (clk),
    //         .csb1 (1'b1),
    //         .addr1(10'b0),
    //         .dout1()

    //     );

endmodule
