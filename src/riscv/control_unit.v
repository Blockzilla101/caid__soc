`include "global_params.vh"

`timescale 1ns/1ps

module control_unit(
    input [6:0] opcode,
    output reg [`CW_LEN:0] control_word
);
    always @(*) begin
        control_word <= 0;

        casez (opcode)
            `OP_LUI: begin

            end

            `OP_AUIPC: begin

            end

            `OP_JAL: begin
                control_word[`CW_BRANCH] <= 1; 

            end

            `OP_JALR: begin
                control_word[`CW_BRANCH] <= 1; 

            end

            `OP_BRANCH: begin
                control_word[`CW_BRANCH] <= 1; 
            end

            `OP_LOAD: begin
                control_word[`CW_ALU_CTRL] <= `ALU_CTRL_ADD; 

            end

            `OP_STORE: begin
                control_word[`CW_ALU_CTRL] <= `ALU_CTRL_ADD; 

            end

            `OP_ALU: begin
                control_word[`CW_REG_WRITE] <= 1;
                control_word[`CW_ALU_CTRL] <= `ALU_CTRL_FUNCT; 
            end

            `OP_ALUI: begin
                control_word[`CW_ALU_SRC] <= 1; 
                control_word[`CW_REG_WRITE] <= 1; 
                control_word[`CW_ALU_CTRL] <= `ALU_CTRL_FUNCT; 
            end

            default: control_word <= 0;
        endcase
    end

endmodule