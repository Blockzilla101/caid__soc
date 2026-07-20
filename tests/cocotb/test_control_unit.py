import cocotb
from cocotb.triggers import FallingEdge, Timer
from enum import StrEnum

class AluOp(StrEnum):
    ALU_OP_ADD = '0001'
    ALU_OP_SUB = '0010'
    ALU_OP_AND = '0011'
    ALU_OP_OR = '0100'
    ALU_OP_XOR = '0101'
    ALU_OP_SLT = '0110'
    ALU_OP_SLTU = '0111'
    ALU_OP_SLL = '1000'
    ALU_OP_SRL = '1001'
    ALU_OP_SRA = '1010'
    ALU_OP_BEQ = '0010'
    ALU_OP_BNE = '1100'
    ALU_OP_BLT = '1101'
    ALU_OP_BGE = '1110'
    ALU_OP_BLTU = '1111'
    ALU_OP_BGEU = '1011'

@cocotb.test()
async def test_control_unit(dut):
    """Testing Control Unit"""

    await Timer(1, "ns")

    # dut.instruction.value = '00001010101111110000011010110111' # lui
    # await Timer(1, "ns")
    # assert dut.alu_op.value == AluOp.ALU_OP.X, "lui should set alu to X"

    # dut.instruction.value = '00001010101111110000011010010111' # auipc
    # await Timer(1, "ns")
    # assert dut.alu_op.value == AluOp.ALU_OP.X, "auipc should set alu to X"
# 
    dut.instruction.value = '00001010101101111000000000010011' # addi
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_ADD, f"addi should set alu to ALU_OP_ADD ({AluOp.ALU_OP_ADD})"

    dut.instruction.value = '00001010101101111010011010010011' # slti
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_SLT, f"slti should set alu to ALU_OP_SLT ({AluOp.ALU_OP_SLT})"

    dut.instruction.value = '00001010101101111011011010010011' # sltiu
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_SLTU, f"sltiu should set alu to ALU_OP_SLTU ({AluOp.ALU_OP_SLTU})"

    dut.instruction.value = '00001010101101111100011010010011' # xori
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_XOR, f"xori should set alu to ALU_OP_XOR ({AluOp.ALU_OP_XOR})"

    dut.instruction.value = '00001010101101111110011010010011' # ori
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_OR, f"ori should set alu to ALU_OP_OR ({AluOp.ALU_OP_OR})"

    dut.instruction.value = '00001010101101111111011010010011' # andi
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_AND, f"andi should set alu to ALU_OP_AND ({AluOp.ALU_OP_AND})"

    dut.instruction.value = '00000000100101111001011010010011' # slli
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_SLL, f"slli should set alu to ALU_OP_SLL ({AluOp.ALU_OP_SLL})"

    dut.instruction.value = '00000000100101111101011010010011' # srli
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_SRL, f"srli should set alu to ALU_OP_SRL ({AluOp.ALU_OP_SRL})"

    dut.instruction.value = '01000000100101111101011010010011' # srai
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_SRA, f"srai should set alu to ALU_OP_SRA ({AluOp.ALU_OP_SRA})"

    dut.instruction.value = '00000000100001111000011010110011' # add
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_ADD, f"add should set alu to ALU_OP_ADD ({AluOp.ALU_OP_ADD})"

    dut.instruction.value = '01000000100001111000011010110011' # sub
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_SUB, f"sub should set alu to ALU_OP_SUB ({AluOp.ALU_OP_SUB})"

    dut.instruction.value = '00000000100001111001011010110011' # sll
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_SLL, f"sll should set alu to ALU_OP_SLL ({AluOp.ALU_OP_SLL})"

    dut.instruction.value = '00000000100001111010011010110011' # slt
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_SLT, f"slt should set alu to ALU_OP_SLT ({AluOp.ALU_OP_SLT})"

    dut.instruction.value = '00000000100001111011011010110011' # sltu
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_SLTU, f"sltu should set alu to ALU_OP_SLTU ({AluOp.ALU_OP_SLTU})"

    dut.instruction.value = '00000000100001111100011010110011' # xor
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_XOR, f"xor should set alu to ALU_OP_XOR ({AluOp.ALU_OP_XOR})"

    dut.instruction.value = '00000000100001111101011010110011' # srl
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_SRL, f"srl should set alu to ALU_OP_SRL ({AluOp.ALU_OP_SRL})"

    dut.instruction.value = '01000000100001111101011010110011' # sra
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_SRA, f"sra should set alu to ALU_OP_SRA ({AluOp.ALU_OP_SRA})"

    dut.instruction.value = '00000000100001111110011010110011' # or
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_OR, f"or should set alu to ALU_OP_OR ({AluOp.ALU_OP_OR})"

    dut.instruction.value = '00000000100001111111011010110011' # and
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_AND, f"and should set alu to ALU_OP_AND ({AluOp.ALU_OP_AND})"

    dut.instruction.value = '01011010110101111000011010000011' # lb
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_ADD, f"lb should set alu to ALU_OP_ADD ({AluOp.ALU_OP_ADD})"

    dut.instruction.value = '01011010110101111001011010000011' # lh
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_ADD, f"lh should set alu to ALU_OP_ADD ({AluOp.ALU_OP_ADD})"

    dut.instruction.value = '01011010110101111010011010000011' # lw
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_ADD, f"lw should set alu to ALU_OP_ADD ({AluOp.ALU_OP_ADD})"

    dut.instruction.value = '01011010110101111100011010000011' # lbu
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_ADD, f"lbu should set alu to ALU_OP_ADD ({AluOp.ALU_OP_ADD})"

    dut.instruction.value = '01011010110101111101011010000011' # lhu
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_ADD, f"lhu should set alu to ALU_OP_ADD ({AluOp.ALU_OP_ADD})"

    dut.instruction.value = '01011010100001111000111010100011' # sb
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_ADD, f"sb should set alu to ALU_OP_ADD ({AluOp.ALU_OP_ADD})"

    dut.instruction.value = '01011010100001111001111010100011' # sh
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_ADD, f"sh should set alu to ALU_OP_ADD ({AluOp.ALU_OP_ADD})"

    dut.instruction.value = '01011010100001111010111010100011' # sw
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_ADD, f"sw should set alu to ALU_OP_ADD ({AluOp.ALU_OP_ADD})"

    # dut.instruction.value = '00001010101111110000011011101111' # jal
    # await Timer(1, "ns")
    # assert dut.alu_op.value == AluOp.ALU_OP.X, "jal should set alu to X"

    # dut.instruction.value = '01011010110101111000011011100111' # jalr
    # await Timer(1, "ns")
    # assert dut.alu_op.value == AluOp.ALU_OP.X, "jalr should set alu to X"

    dut.instruction.value = '11101010100001111000111011100011' # beq
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_BEQ, f"beq should set alu to ALU_OP_BEQ ({AluOp.ALU_OP_BEQ})"

    dut.instruction.value = '11101010100001111001111011100011' # bne
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_BNE, f"bne should set alu to ALU_OP_BNE ({AluOp.ALU_OP_BNE})"

    dut.instruction.value = '11101010100001111100111011100011' # blt
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_BLT, f"blt should set alu to ALU_OP_BLT ({AluOp.ALU_OP_BLT})"

    dut.instruction.value = '11101010100001111101111011100011' # bge
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_BGE, f"bge should set alu to ALU_OP_BGE ({AluOp.ALU_OP_BGE})"

    dut.instruction.value = '11101010100001111110111011100011' # bltu
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_BLTU, f"bltu should set alu to ALU_OP_BLTU ({AluOp.ALU_OP_BLTU})"

    dut.instruction.value = '11101010100001111111111011100011' # bgeu
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_BGEU, f"bgeu should set alu to ALU_OP_BGEU ({AluOp.ALU_OP_BGEU})"
