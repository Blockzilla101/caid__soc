module imm_gen(
    input [31:0] instruction,
    output [31:0] imm_value
);
    wire [6:0] opcode = instruction[`INST_OPCODE];

    always @(*) begin
        imm_value <= 0;
        case (opcode)
            `OP_LUI
            `OP_AUIPC: imm_value <= { instruction[31:12], 12'b0 }
            `OP_JAL: imm_value <= $signed( instruction[31], instruction[19:12],  instruction[20], instruction[30:21] );
            `OP_BRANCH: imm_value <= $signed({instruction[31], instruction[7], instruction[30:25], instruction[11:8]});
            `OP_JALR
            `OP_STORE: imm_value <= $signed({instruction[31:25], instruction[11:7]});
            `OP_LOAD
            `OP_ALUI: imm_value <= $signed(instruction[31:20]);
            default: imm_value <= 0; 
        endcase
    end

endmodule