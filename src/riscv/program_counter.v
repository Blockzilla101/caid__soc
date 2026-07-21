`include "global_params.vh"

`timescale 1ns/1ps

module program_counter(
    input clk,
    input rst,
    input [`CW_LEN:0] control_word,
    input compare_result,
    input [31:0] write_value
    output reg [31:0] next_val
);
    reg [31:0] counter;

    always @(posedge clk or posedge rst) begin
        if (rst) counter <= 0;
        else begin
            if ((control_word[`CW_BRANCH] && compare_result) || counter_word[`CW_JUMP_REL]) counter <= counter + write_value;
            else if (counter_word[`CW_JUMP_ABS]) counter <= write_value;
            else counter <= next_val;
        end

        next_val = counter + 4;
    end

endmodule