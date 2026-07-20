`include "global_params.vh"

`timescale 1ns/1ps

module control_unit(
    input [6:0] opcode,
    output reg [`CW_LEN:0] control_word
);
    always @(*) begin
        control_word <= 0;

        case (opcode)
            `OP_LUI: begin

            end

            `OP_AUIPC: begin

            end

            `OP_JAL: begin
                control_word[`CW_BRANCH] <= 1; 
                control_word[`CW_REG_WRITE_SRC] <= `REG_WRITE_SRC_PC;
                control_word[`CW_REG_WRITE_EN] <= 1;
            end

            `OP_JALR: begin
                control_word[`CW_BRANCH] <= 1; 
                control_word[`CW_REG_WRITE_SRC] <= `REG_WRITE_SRC_PC;
                control_word[`CW_REG_WRITE_EN] <= 1;
            end

            `OP_BRANCH: begin
                control_word[`CW_BRANCH] <= 1; 
                control_word[`CW_ALU_CTRL] <= `ALU_CTRL_BRANCH; 
            end

            `OP_LOAD: begin
                control_word[`CW_ALU_CTRL] <= `ALU_CTRL_ADD;
                control_word[`CW_REG_WRITE_SRC] <= `REG_WRITE_SRC_MEM;
                control_word[`CW_ALU_SRC] <= `ALU_SRC_IMM;
                control_word[`CW_REG_WRITE_EN] <= 1;
            end

            `OP_STORE: begin
                control_word[`CW_ALU_CTRL] <= `ALU_CTRL_ADD; 
                control_word[`CW_ALU_SRC] <= `ALU_SRC_IMM;
            end

            `OP_ALU: begin
                control_word[`CW_REG_WRITE_EN] <= 1;
                control_word[`CW_ALU_CTRL] <= `ALU_CTRL_FUNCT; 
            end

            `OP_ALUI: begin
                control_word[`CW_ALU_SRC] <= 1; 
                control_word[`CW_REG_WRITE_EN] <= 1; 
                control_word[`CW_ALU_CTRL] <= `ALU_CTRL_FUNCT; 
            end

            default: control_word <= 0;
        endcase
    end

endmodule