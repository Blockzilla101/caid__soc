import cocotb
from cocotb.types import LogicArray
from cocotb.triggers import FallingEdge, Timer
from enum import StrEnum, Enum
import tinyrv

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

class TestInst(StrEnum):
    LUI = '00001010101111110000011010110111'
    AUIPC = '00001010101111110000011010010111'
    ADDI = '00001010101101111000000000010011'
    SLTI = '00001010101101111010011010010011'
    SLTIU = '00001010101101111011011010010011'
    XORI = '00001010101101111100011010010011'
    ORI = '00001010101101111110011010010011'
    ANDI = '00001010101101111111011010010011'
    SLLI = '00000000100101111001011010010011'
    SRLI = '00000000100101111101011010010011'
    SRAI = '01000000100101111101011010010011'
    ADD = '00000000100001111000011010110011'
    SUB = '01000000100001111000011010110011'
    SLL = '00000000100001111001011010110011'
    SLT = '00000000100001111010011010110011'
    SLTU = '00000000100001111011011010110011'
    XOR = '00000000100001111100011010110011'
    SRL = '00000000100001111101011010110011'
    SRA = '01000000100001111101011010110011'
    OR = '00000000100001111110011010110011'
    AND = '00000000100001111111011010110011'
    LB = '01011010110101111000011010000011'
    LH = '01011010110101111001011010000011'
    LW = '01011010110101111010011010000011'
    LBU = '01011010110101111100011010000011'
    LHU = '01011010110101111101011010000011'
    SB = '01011010100001111000111010100011'
    SH = '01011010100001111001111010100011'
    SW = '01011010100001111010111010100011'
    JAL = '00001010101111110000011011101111'
    JALR = '01011010110101111000011011100111'
    BEQ = '11101010100001111000111011100011'
    BNE = '11101010100001111001111011100011'
    BLT = '11101010100001111100111011100011'
    BGE = '11101010100001111101111011100011'
    BLTU = '11101010100001111110111011100011'
    BGEU = '11101010100001111111111011100011'

async def test_imm_operand(dut, inst, should_be: int, op):
    await Timer(1, "ns")
    assert dut.imm_value.value == should_be, f"{inst}: imm_value should be {bin(should_be)}, is {bin(int(str(dut.imm_value.value), 2))}, {op}"

def get_immediate(op):
    for key, val in op.args.items():
        if key.startswith("imm") or key == 'shamtd':
            return val
    return 0

@cocotb.test()
async def test_alu_operation(dut):
    """Testing ALU operations"""

    await Timer(1, "ns")

    # dut.instruction.value = '00001010101111110000011010110111' # lui
    # await Timer(1, "ns")
    # assert dut.alu_op.value == AluOp.ALU_OP.X, "lui should set alu to X"

    # dut.instruction.value = '00001010101111110000011010010111' # auipc
    # await Timer(1, "ns")
    # assert dut.alu_op.value == AluOp.ALU_OP.X, "auipc should set alu to X"
# 
    dut.instruction.value = TestInst.ADDI
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_ADD, f"addi should set alu to ALU_OP_ADD ({AluOp.ALU_OP_ADD})"

    dut.instruction.value = TestInst.SLTI
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_SLT, f"slti should set alu to ALU_OP_SLT ({AluOp.ALU_OP_SLT})"

    dut.instruction.value = TestInst.SLTIU
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_SLTU, f"sltiu should set alu to ALU_OP_SLTU ({AluOp.ALU_OP_SLTU})"

    dut.instruction.value = TestInst.XORI
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_XOR, f"xori should set alu to ALU_OP_XOR ({AluOp.ALU_OP_XOR})"

    dut.instruction.value = TestInst.ORI
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_OR, f"ori should set alu to ALU_OP_OR ({AluOp.ALU_OP_OR})"

    dut.instruction.value = TestInst.ANDI
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_AND, f"andi should set alu to ALU_OP_AND ({AluOp.ALU_OP_AND})"

    dut.instruction.value = TestInst.SLLI
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_SLL, f"slli should set alu to ALU_OP_SLL ({AluOp.ALU_OP_SLL})"

    dut.instruction.value = TestInst.SRLI
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_SRL, f"srli should set alu to ALU_OP_SRL ({AluOp.ALU_OP_SRL})"

    dut.instruction.value = TestInst.SRAI
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_SRA, f"srai should set alu to ALU_OP_SRA ({AluOp.ALU_OP_SRA})"

    dut.instruction.value = TestInst.ADD
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_ADD, f"add should set alu to ALU_OP_ADD ({AluOp.ALU_OP_ADD})"

    dut.instruction.value = TestInst.SUB
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_SUB, f"sub should set alu to ALU_OP_SUB ({AluOp.ALU_OP_SUB})"

    dut.instruction.value = TestInst.SLL
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_SLL, f"sll should set alu to ALU_OP_SLL ({AluOp.ALU_OP_SLL})"

    dut.instruction.value = TestInst.SLT
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_SLT, f"slt should set alu to ALU_OP_SLT ({AluOp.ALU_OP_SLT})"

    dut.instruction.value = TestInst.SLTU
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_SLTU, f"sltu should set alu to ALU_OP_SLTU ({AluOp.ALU_OP_SLTU})"

    dut.instruction.value = TestInst.XOR
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_XOR, f"xor should set alu to ALU_OP_XOR ({AluOp.ALU_OP_XOR})"

    dut.instruction.value = TestInst.SRL
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_SRL, f"srl should set alu to ALU_OP_SRL ({AluOp.ALU_OP_SRL})"

    dut.instruction.value = TestInst.SRA
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_SRA, f"sra should set alu to ALU_OP_SRA ({AluOp.ALU_OP_SRA})"

    dut.instruction.value = TestInst.OR
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_OR, f"or should set alu to ALU_OP_OR ({AluOp.ALU_OP_OR})"

    dut.instruction.value = TestInst.AND
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_AND, f"and should set alu to ALU_OP_AND ({AluOp.ALU_OP_AND})"

    dut.instruction.value = TestInst.LB
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_ADD, f"lb should set alu to ALU_OP_ADD ({AluOp.ALU_OP_ADD})"

    dut.instruction.value = TestInst.LH
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_ADD, f"lh should set alu to ALU_OP_ADD ({AluOp.ALU_OP_ADD})"

    dut.instruction.value = TestInst.LW
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_ADD, f"lw should set alu to ALU_OP_ADD ({AluOp.ALU_OP_ADD})"

    dut.instruction.value = TestInst.LBU
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_ADD, f"lbu should set alu to ALU_OP_ADD ({AluOp.ALU_OP_ADD})"

    dut.instruction.value = TestInst.LHU
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_ADD, f"lhu should set alu to ALU_OP_ADD ({AluOp.ALU_OP_ADD})"

    dut.instruction.value = TestInst.SB
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_ADD, f"sb should set alu to ALU_OP_ADD ({AluOp.ALU_OP_ADD})"

    dut.instruction.value = TestInst.SH
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_ADD, f"sh should set alu to ALU_OP_ADD ({AluOp.ALU_OP_ADD})"

    dut.instruction.value = TestInst.SW
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_ADD, f"sw should set alu to ALU_OP_ADD ({AluOp.ALU_OP_ADD})"

    # dut.instruction.value = TestInst.JAL
    # await Timer(1, "ns")
    # assert dut.alu_op.value == AluOp.ALU_OP.X, "jal should set alu to X"

    # dut.instruction.value = TestInst.JALR
    # await Timer(1, "ns")
    # assert dut.alu_op.value == AluOp.ALU_OP.X, "jalr should set alu to X"

    dut.instruction.value = TestInst.BEQ
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_BEQ, f"beq should set alu to ALU_OP_BEQ ({AluOp.ALU_OP_BEQ})"

    dut.instruction.value = TestInst.BNE
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_BNE, f"bne should set alu to ALU_OP_BNE ({AluOp.ALU_OP_BNE})"

    dut.instruction.value = TestInst.BLT
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_BLT, f"blt should set alu to ALU_OP_BLT ({AluOp.ALU_OP_BLT})"

    dut.instruction.value = TestInst.BGE
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_BGE, f"bge should set alu to ALU_OP_BGE ({AluOp.ALU_OP_BGE})"

    dut.instruction.value = TestInst.BLTU
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_BLTU, f"bltu should set alu to ALU_OP_BLTU ({AluOp.ALU_OP_BLTU})"

    dut.instruction.value = TestInst.BGEU
    await Timer(1, "ns")
    assert dut.alu_op.value == AluOp.ALU_OP_BGEU, f"bgeu should set alu to ALU_OP_BGEU ({AluOp.ALU_OP_BGEU})"

@cocotb.test()
async def test_imm_gen_value(dut):
    """Testing Immediate value generator"""

    await Timer(1, "ns")

    for key in TestInst:
        decoded = tinyrv.decode(int(key.value, 2))
        imm_value = get_immediate(decoded)
        dut.instruction.value = key.value
        await test_imm_operand(dut, key.name, imm_value, decoded)
