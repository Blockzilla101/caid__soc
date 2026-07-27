`timescale 1ns / 1ps

module imm_gen (
    input [31:0] instruction,
    output reg [31:0] imm_value
);
    always @(*) begin
        imm_value <= 0;
        case (instruction[`INST_OPCODE])
            `OP_LUI, `OP_AUIPC: imm_value <= {instruction[31:12], 12'b0};
            `OP_JAL: imm_value <= $signed({instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0});
            `OP_BRANCH: imm_value <= $signed({instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0});
            `OP_STORE: imm_value <= $signed({instruction[31:25], instruction[11:7]});
            `OP_LOAD: imm_value <= $signed(instruction[31:20]);
            `OP_ALUI, `OP_JALR: begin
                case (instruction[`INST_FUNCT3])
                    3'b001, 3'b101: imm_value <= $signed(instruction[24:20]);
                    default imm_value <= $signed(instruction[31:20]);
                endcase
            end
            default: imm_value <= 0;
        endcase
    end

endmodule
