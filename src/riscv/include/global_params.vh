`define CW_LEN 6

`define INST_OPCODE 6:0 
`define INST_RD 11:7
`define INST_FUNCT3 14:12
`define INST_RS1 19:15
`define INST_RS2 24:20
`define INST_FUNCT7 31:25

`define CW_BRANCH 0
`define CW_MEM_READ 1
`define CW_MEM_WRITE 2
`define CW_ALU_CTRL 4:3
`define CW_ALU_SRC 5
`define CW_REG_WRITE 6

`define ALU_CTRL_ADD 2'b00
`define ALU_CTRL_SUB 2'b01
`define ALU_CTRL_FUNCT 2'b10

`define ALU_OP_ADD 4'b0001
`define ALU_OP_SUB 4'b0010
`define ALU_OP_AND 4'b0011
`define ALU_OP_OR 4'b0100
`define ALU_OP_XOR 4'b0101
`define ALU_OP_SLT 4'b0110
`define ALU_OP_SLTU 4'b0111
`define ALU_OP_SLL 4'b1000
`define ALU_OP_SRL 4'b1001
`define ALU_OP_SRA 4'b1010

`define OP_LUI 7'b0110111 // Load Upper Immediate
`define OP_AUIPC 7'b0010111 // Add Upper Immediate to PC
`define OP_JAL 7'b1101111 // Jump and Link
`define OP_JALR 7'b1100111 // Jump and Link Register
`define OP_BRANCH 7'b1100011 // Branch Instructions (BEQ, BNE, BLT, etc.)
`define OP_LOAD 7'b0000011 // Load Instructions (LB, LH, LW, LBU, LHU)
`define OP_STORE 7'b0100011 // Store Instructions (SB, SH, SW)
`define OP_ALU 7'b0110011 // ALU Instructions (ADD, SUB, AND, OR, XOR, etc.)
`define OP_ALUI 7'b0010011 // ALU Immediate Instructions (ADDI, ANDI, ORI, XORI, etc.)
// `define OP_FENCE 7'b0001111 // Fence
// `define OP_SYSTEM 7'b1110011 // System Instructions (ECALL, EBREAK, etc.)