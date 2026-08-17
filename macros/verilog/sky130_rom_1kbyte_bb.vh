// OpenROM ROM model
// Words: 204
// Word size: 8
// Word per Row: 8
// Data Type: bin
// Data File: /home/blockzilla/ic-design/projects/caid__soc/tests/gcc/build/wb_fpga_test.bin

(* blackbox *)
module sky130_rom_1kbyte (
`ifdef USE_POWER_PINS
    vccd1,
    vssd1,
`endif
    // Port 0: R
    clk0,
    cs0,
    addr0,
    dout0
);

    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 8;

`ifdef USE_POWER_PINS
    inout vccd1;
    inout vssd1;
`endif
    input clk0;  // clock
    input cs0;  // active high chip select
    input [ADDR_WIDTH-1:0] addr0;
    output [DATA_WIDTH-1:0] dout0;

endmodule
