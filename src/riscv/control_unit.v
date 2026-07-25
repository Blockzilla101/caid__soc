`include "global_params.vh"

`timescale 1ns/1ps

module control_unit(
    input [6:0] opcode,
    output reg [`CW_LEN] control_word
);
    always @(*) begin
        control_word <= 0;

        case (opcode)
            `OP_LUI: begin // x[rd] = sext(immediate[31:12] << 12)
                control_word[`CW_ALU_SRC_OP1] <= `ALU_SRC_OP1_ZERO;
                control_word[`CW_ALU_SRC_OP2] <= `ALU_SRC_OP2_IMM;
                control_word[`CW_ALU_CTRL] <= `ALU_CTRL_ADD; 
                control_word[`CW_REG_WRITE_SRC] <= `REG_WRITE_SRC_ALU;
                control_word[`CW_REG_WRITE_EN] <= 1;
            end

            `OP_AUIPC: begin // x[rd] = pc + sext(immediate[31:12] << 12)
                control_word[`CW_ALU_CTRL] <= `ALU_CTRL_ADD; 
                control_word[`CW_ALU_SRC_OP1] <= `ALU_SRC_OP1_PC; 
                control_word[`CW_ALU_SRC_OP2] <= `ALU_SRC_OP2_IMM;
                control_word[`CW_REG_WRITE_EN] <= 1;
            end

            `OP_JAL: begin // x[rd] = pc+4; pc += sext(offset)
                control_word[`CW_BRANCH_UNCOND] <= 1; 
                control_word[`CW_REG_WRITE_SRC] <= `REG_WRITE_SRC_PC;
                control_word[`CW_REG_WRITE_EN] <= 1;
                control_word[`CW_ALU_CTRL] <= `ALU_CTRL_ADD; 
            end

            `OP_JALR: begin // t =pc+4; pc=(x[rs1]+sext(offset))&∼1; x[rd]=t
                control_word[`CW_BRANCH_UNCOND] <= 1; 
                control_word[`CW_REG_WRITE_SRC] <= `REG_WRITE_SRC_PC;
                control_word[`CW_REG_WRITE_EN] <= 1;
                control_word[`CW_ALU_CTRL] <= `ALU_CTRL_ADD; 
            end

            `OP_BRANCH: begin // if (x[rs1] == x[rs2]) pc += sext(offset)
                control_word[`CW_BRANCH] <= 1; 
                control_word[`CW_ALU_CTRL] <= `ALU_CTRL_ADD; 
            end

            // todo: deal with bytes, half words
            `OP_LOAD: begin // x[rd] = sext(M[x[rs1] + sext(offset)][31:0])
                control_word[`CW_ALU_CTRL] <= `ALU_CTRL_ADD;
                control_word[`CW_REG_WRITE_SRC] <= `REG_WRITE_SRC_MEM;
                control_word[`CW_ALU_SRC_OP2] <= `ALU_SRC_OP2_IMM;
                control_word[`CW_REG_WRITE_EN] <= 1;
            end

            // todo: deal with bytes, half words
            `OP_STORE: begin // M[x[rs1] + sext(offset)] = x[rs2][31:0]
                control_word[`CW_ALU_CTRL] <= `ALU_CTRL_ADD; 
                control_word[`CW_ALU_SRC_OP2] <= `ALU_SRC_OP2_IMM;
            end

            `OP_ALU: begin // x[rd] = x[rs1] + x[rs2]
                control_word[`CW_REG_WRITE_SRC] <= `REG_WRITE_SRC_ALU;
                control_word[`CW_REG_WRITE_EN] <= 1;
                control_word[`CW_ALU_CTRL] <= `ALU_CTRL_FUNCT;        
            end

            `OP_ALUI: begin // x[rd] = x[rs1] + sext(immediate)
                control_word[`CW_REG_WRITE_SRC] <= `REG_WRITE_SRC_ALU;
                control_word[`CW_REG_WRITE_EN] <= 1;
                control_word[`CW_ALU_CTRL] <= `ALU_CTRL_FUNCT; 
                control_word[`CW_ALU_SRC_OP2] <= `ALU_SRC_OP2_IMM;
            end

            default: control_word <= 0;
        endcase
    end

endmodule