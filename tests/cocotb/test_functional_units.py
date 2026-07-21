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
    should_be = should_be if should_be >= 0 else should_be + (1 << 32) # signed numbers
    assert dut.imm_value.value == should_be, f"{inst}: imm_value should be {bin(should_be)}, is {bin(int(str(dut.imm_value.value), 2))}, {op}"

async def test_alu_op(dut, inst_val: TestInst, inst_name: str, should_be: AluOp):
    dut.instruction.value = inst_val
    await Timer(1, "ns")
    assert dut.alu_op.value == should_be, f"{inst_name}: should set alu to {should_be}, is {dut.alu_op.value}"

def get_immediate(op):
    for key, val in op.args.items():
        if "imm" in key or key == 'shamtd':
            return val
    return 0

@cocotb.test()
async def test_alu_operation(dut):
    """Testing ALU operations"""

    await Timer(1, "ns")

    await test_alu_op(dut, TestInst.ADDI, 'ADDI', AluOp.ALU_OP_ADD)
    await test_alu_op(dut, TestInst.SLTI, 'SLTI', AluOp.ALU_OP_SLT)
    await test_alu_op(dut, TestInst.SLTIU, 'SLTIU', AluOp.ALU_OP_SLTU)
    await test_alu_op(dut, TestInst.XORI, 'XORI', AluOp.ALU_OP_XOR)
    await test_alu_op(dut, TestInst.ORI, 'ORI', AluOp.ALU_OP_OR)
    await test_alu_op(dut, TestInst.ANDI, 'ANDI', AluOp.ALU_OP_AND)
    await test_alu_op(dut, TestInst.SLLI, 'SLLI', AluOp.ALU_OP_SLL)
    await test_alu_op(dut, TestInst.SRLI, 'SRLI', AluOp.ALU_OP_SRL)
    await test_alu_op(dut, TestInst.SRAI, 'SRAI', AluOp.ALU_OP_SRA)
    await test_alu_op(dut, TestInst.ADD, 'ADD', AluOp.ALU_OP_ADD)
    await test_alu_op(dut, TestInst.SUB, 'ADD', AluOp.ALU_OP_SUB)
    await test_alu_op(dut, TestInst.SLL, 'ADD', AluOp.ALU_OP_SLL)
    await test_alu_op(dut, TestInst.SLT, 'ADD', AluOp.ALU_OP_SLT)
    await test_alu_op(dut, TestInst.SLTU, 'SLTU', AluOp.ALU_OP_SLTU)
    await test_alu_op(dut, TestInst.XOR, 'XOR', AluOp.ALU_OP_XOR)
    await test_alu_op(dut, TestInst.SRL, 'SRL', AluOp.ALU_OP_SRL)
    await test_alu_op(dut, TestInst.SRA, 'SRA', AluOp.ALU_OP_SRA)
    await test_alu_op(dut, TestInst.OR, 'OR', AluOp.ALU_OP_OR)
    await test_alu_op(dut, TestInst.AND, 'AND', AluOp.ALU_OP_AND)
    await test_alu_op(dut, TestInst.LB, 'LB', AluOp.ALU_OP_ADD)
    await test_alu_op(dut, TestInst.LH, 'LH', AluOp.ALU_OP_ADD)
    await test_alu_op(dut, TestInst.LW, 'LW', AluOp.ALU_OP_ADD)
    await test_alu_op(dut, TestInst.LBU, 'LBU', AluOp.ALU_OP_ADD)
    await test_alu_op(dut, TestInst.LHU, 'LHU', AluOp.ALU_OP_ADD)
    await test_alu_op(dut, TestInst.SB, 'SB', AluOp.ALU_OP_ADD)
    await test_alu_op(dut, TestInst.SH, 'SH', AluOp.ALU_OP_ADD)
    await test_alu_op(dut, TestInst.SW, 'SW', AluOp.ALU_OP_ADD)
    await test_alu_op(dut, TestInst.BEQ, 'BEQ', AluOp.ALU_OP_BEQ)
    await test_alu_op(dut, TestInst.BNE, 'BNE', AluOp.ALU_OP_BNE)
    await test_alu_op(dut, TestInst.BLT, 'BLT', AluOp.ALU_OP_BLT)
    await test_alu_op(dut, TestInst.BGE, 'BGE', AluOp.ALU_OP_BGE)
    await test_alu_op(dut, TestInst.BLTU, 'BLTU', AluOp.ALU_OP_BLTU)
    await test_alu_op(dut, TestInst.BGEU, 'BGEU', AluOp.ALU_OP_BGEU)

@cocotb.test()
async def test_imm_gen_value(dut):
    """Testing Immediate value generator"""

    await Timer(1, "ns")

    for key in TestInst:
        decoded = tinyrv.decode(int(key.value, 2))
        imm_value = get_immediate(decoded)
        dut.instruction.value = key.value
        await test_imm_operand(dut, key.name, imm_value, decoded)
