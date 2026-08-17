// SRAM22 SRAM model
// Words: 1024
// Word size: 32
// Write size: 8

(* blackbox *)
module sram22_1024x32m8w8 (
`ifdef USE_POWER_PINS
    vdd,
    vss,
`endif
    clk,
    rstb,
    ce,
    we,
    wmask,
    addr,
    din,
    dout
);

    localparam DATA_WIDTH = 32;
    localparam ADDR_WIDTH = 10;
    localparam WMASK_WIDTH = 4;

`ifdef USE_POWER_PINS
    inout vdd;  // power
    inout vss;  // ground
`endif
    input clk;  // clock
    input rstb;  // reset bar (active low reset)
    input ce;  // chip enable
    input we;  // write enable
    input [WMASK_WIDTH-1:0] wmask;  // write mask
    input [ADDR_WIDTH-1:0] addr;  // address
    input [DATA_WIDTH-1:0] din;  // data in
    output reg [DATA_WIDTH-1:0] dout;  // data out
endmodule

