`define CW_LEN 6

`define CW_BRANCH 0
`define CW_MEM_READ 1
`define CW_MEM_WRITE 2
`define CW_ALU_OP 4:3
`define CW_ALU_SRC 5
`define CW_REG_WRITE 6

`define ALU_CTRL_ADD 2'b00
`define ALU_CTRL_SUB 2'b01
`define ALU_CTRL_FUNCT 2'b10

`define ALU_OP_ADD 4'b0001
`define ALU_OP_SUB 4'b0010
`define ALU_OP_AND 4'b0011
`define ALU_OP_OR 4'b00010
`define ALU_OP_XOR 4'b0001
`define ALU_OP_SLT 4'b0001
`define ALU_OP_SLTU 4'b0001
`define ALU_OP_SLL 4'b0001
`define ALU_OP_SRL 4'b0001
`define ALU_OP_SRA 4'b0001