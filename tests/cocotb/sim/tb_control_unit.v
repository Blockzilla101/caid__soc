`include "global_params.vh"

module tb_control_unit(
    input [31:0] instruction
);
    wire [`CW_LEN:0] control_word;
    wire [3:0] alu_op;

    control_unit cu(
        .opcode(instruction[`INST_OPCODE]),
        .control_word(control_word)
    );

    alu_control alu_ctrl_unit(
        .opcode(instruction[`INST_OPCODE]),
        .alu_ctrl(control_word[`CW_ALU_CTRL]),
        .funct3(instruction[`INST_FUNCT3]),
        .funct7(instruction[`INST_FUNCT7]),
        .alu_op(alu_op)
    );

endmodule