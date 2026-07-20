`include "global_params.vh"

`timescale 1ns/1ps

module control_unit(
    input [6:0] opcode,
    output reg [`CW_LEN:0] control_word
);

    localparam LU_TYPE = 7'b0?10111;

    localparam  I_TYPE = 7'b0010011;
    localparam  R_TYPE = 7'b0110011;
    localparam  F_TYPE = 7'b0001111;
    localparam  C_TYPE = 7'b1110011;
    localparam  L_TYPE = 7'b0000011;
    localparam  S_TYPE = 7'b0100011;
    localparam  B_TYPE = 7'b110??11;

    // // load upper
    // localparam INST_LUI = 6'01101;
    // localparam INST_AUIPC = 6'00101;

    // // I
    // localparam INST_ADDI = 6'00100;
    // localparam INST_SLTI = 6'00100;
    // localparam INST_SLTIU = 6'00100;
    // localparam INST_XORI = 6'00100;
    // localparam INST_ORI = 6'00100;
    // localparam INST_ANDI = 6'00100;
    // localparam INST_SLLI = 6'00100;
    // localparam INST_SRLI = 6'00100;
    // localparam INST_SRAI = 6'00100;

    // // R
    // localparam INST_ADD = 6'01100;
    // localparam INST_SUB = 6'01100;
    // localparam INST_SLL = 6'01100;
    // localparam INST_SLT = 6'01100;
    // localparam INST_SLTU = 6'01100;
    // localparam INST_XOR = 6'01100;
    // localparam INST_SRL = 6'01100;
    // localparam INST_SRA = 6'01100;
    // localparam INST_OR = 6'01100;
    // localparam INST_AND = 6'01100;

    // // Fence
    // localparam INST_FENCE = 6'00011;
    // localparam INST_FENCE_I = 6'00011;
    
    // // ?
    // localparam INST_CSRRW = 6'11100;
    // localparam INST_CSRRS = 6'11100;
    // localparam INST_CSRRC = 6'11100;
    // localparam INST_CSRRWI = 6'11100;
    // localparam INST_CSRRSI = 6'11100;
    // localparam INST_CSRRCI = 6'11100;
    // localparam INST_ECALL = 6'11100;
    // localparam INST_EBREAK = 6'11100;
    // localparam INST_URET = 6'11100;
    // localparam INST_SRET = 6'11100;
    // localparam INST_MRET = 6'11100;
    // localparam INST_WFI = 6'11100;
    // localparam INST_SFENCE_VMA = 6'11100;
    // // load
    // localparam INST_LB = 6'00000;
    // localparam INST_LH = 6'00000;
    // localparam INST_LW = 6'00000;
    // localparam INST_LBU = 6'00000;
    // localparam INST_LHU = 6'00000;
    // // store
    // localparam INST_SB = 6'01000;
    // localparam INST_SH = 6'01000;
    // localparam INST_SW = 6'01000;
    // // branch + return addr
    // localparam INST_JAL = 6'11011;
    // localparam INST_JALR = 6'11001;
    // // branch
    // localparam INST_BEQ = 6'11000;
    // localparam INST_BNE = 6'11000;
    // localparam INST_BLT = 6'11000;
    // localparam INST_BGE = 6'11000;
    // localparam INST_BLTU = 6'11000;
    // localparam INST_BGEU = 6'11000;

    always @(*) begin
        control_word <= 0;

        casez (opcode)
            R_TYPE: begin
                control_word[`CW_REG_WRITE] <= 1; 
                control_word[`CW_ALU_OP] <= `ALU_OP_FUNCT; 
            end
            default: control_word <= 0;
        endcase
    end

endmodule