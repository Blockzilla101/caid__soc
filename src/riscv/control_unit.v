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
                control_word[`CW_ALU_SRC_OP2] <= `ALU_SRC_OP2_IMM;
                control_word[`CW_REG_WRITE_EN] <= 1;
            end

            `OP_AUIPC: begin
                control_word[`CW_ALU_SRC_OP1] <= `ALU_SRC_OP1_PC; 
                control_word[`CW_ALU_SRC_OP2] <= `ALU_SRC_OP2_IMM;
                control_word[`CW_REG_WRITE_EN] <= 1;
            end

            `OP_JAL: begin
                control_word[`CW_JUMP_REL] <= 1; 
                control_word[`CW_REG_WRITE_SRC] <= `REG_WRITE_SRC_PC;
                control_word[`CW_REG_WRITE_EN] <= 1;
            end

            `OP_JALR: begin
                control_word[`CW_JUMP_ABS] <= 1; 
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
                control_word[`CW_ALU_SRC_OP2] <= `ALU_SRC_OP2_IMM;
                control_word[`CW_REG_WRITE_EN] <= 1;
            end

            `OP_STORE: begin
                control_word[`CW_ALU_CTRL] <= `ALU_CTRL_ADD; 
                control_word[`CW_ALU_SRC_OP2] <= `ALU_SRC_OP2_IMM;
            end

            `OP_ALU, `OP_ALUI: begin
                control_word[`CW_REG_WRITE_EN] <= 1;
                control_word[`CW_ALU_CTRL] <= `ALU_CTRL_FUNCT; 
            end

            default: control_word <= 0;
        endcase
    end

endmodule