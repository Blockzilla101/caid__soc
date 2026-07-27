import cocotb
from cocotb.types import LogicArray
from cocotb.clock import Clock
from cocotb.triggers import Timer
from cocotb.handle import Force, Release
from enum import StrEnum, Enum
import tinyrv
from util import setup_clock


class AluOp(StrEnum):
    ALU_OP_ADD = "0001"
    ALU_OP_SUB = "0010"
    ALU_OP_AND = "0011"
    ALU_OP_OR = "0100"
    ALU_OP_XOR = "0101"
    ALU_OP_SLT = "0110"
    ALU_OP_SLTU = "0111"
    ALU_OP_SLL = "1000"
    ALU_OP_SRL = "1001"
    ALU_OP_SRA = "1010"


class TestInst(StrEnum):
    LUI = "00001010101111110000011010110111"
    AUIPC = "00001010101111110000011010010111"
    ADDI = "00001010101101111000000000010011"
    SLTI = "00001010101101111010011010010011"
    SLTIU = "00001010101101111011011010010011"
    XORI = "00001010101101111100011010010011"
    ORI = "00001010101101111110011010010011"
    ANDI = "00001010101101111111011010010011"
    SLLI = "00000000100101111001011010010011"
    SRLI = "00000000100101111101011010010011"
    SRAI = "01000000100101111101011010010011"
    ADD = "00000000100001111000011010110011"
    SUB = "01000000100001111000011010110011"
    SLL = "00000000100001111001011010110011"
    SLT = "00000000100001111010011010110011"
    SLTU = "00000000100001111011011010110011"
    XOR = "00000000100001111100011010110011"
    SRL = "00000000100001111101011010110011"
    SRA = "01000000100001111101011010110011"
    OR = "00000000100001111110011010110011"
    AND = "00000000100001111111011010110011"
    LB = "01011010110101111000011010000011"
    LH = "01011010110101111001011010000011"
    LW = "01011010110101111010011010000011"
    LBU = "01011010110101111100011010000011"
    LHU = "01011010110101111101011010000011"
    SB = "01011010100001111000111010100011"
    SH = "01011010100001111001111010100011"
    SW = "01011010100001111010111010100011"
    JAL = "00001010101111110000011011101111"
    JALR = "01011010110101111000011011100111"
    BEQ = "11101010100001111000111011100011"
    BNE = "11101010100001111001111011100011"
    BLT = "11101010100001111100111011100011"
    BGE = "11101010100001111101111011100011"
    BLTU = "11101010100001111110111011100011"
    BGEU = "11101010100001111111111011100011"


class MemWidth(StrEnum):
    byte = "00"
    half = "01"
    word = "10"


async def test_imm_operand(dut, inst, should_be: int, op):
    await dut.clk.rising_edge
    should_be = should_be if should_be >= 0 else should_be + (1 << 32)  # signed numbers
    assert (
        dut.imm_value.value == should_be
    ), f"{inst}: imm_value should be {bin(should_be)}, is {bin(int(str(dut.imm_value.value), 2))}, {op}"


async def test_alu_ctrl_op(dut, inst_val: TestInst, inst_name: str, should_be: AluOp):
    dut.instruction.value = inst_val
    await dut.clk.rising_edge
    assert (
        dut.alu_op.value == should_be
    ), f"{inst_name}: should set alu to {should_be}, is {dut.alu_op.value}"


async def test_branch_op(
    dut, A: int, B: int, inst_val: TestInst, inst_name: str, should_branch: bool
):
    dut.instruction.value = inst_val
    dut.A.value = A
    dut.B.value = B
    await dut.clk.rising_edge
    assert (
        dut.bu.branch_taken.value == should_branch
    ), f"{inst_name}: branch_taken should be {should_branch}, is {bool(dut.bu.branch_taken.value)}"


async def test_alu_op(
    dut, A: int, B: int, alu_op_val: AluOp, op_name: str, should_be: int
):
    dut.alu_op.value = Force(alu_op_val)
    dut.A.value = A
    dut.B.value = B
    await dut.clk.rising_edge
    assert (
        dut.alu_result.value == should_be
    ), f"{op_name}: alu_result should be {should_be} is {int(str(dut.alu_result.value), 2)}"
    dut.alu_op.value = Release()


def get_immediate(op):
    for key, val in op.args.items():
        if "imm" in key or key == "shamtd":
            return val
    return 0


@cocotb.test()
async def test_program_counter(dut):
    """Testing Program Counter"""

    await setup_clock(dut)

    dut.pc_next_val.value = 0
    await dut.clk.rising_edge
    assert dut.pc_val.value == 0, "PC should be 0"

    dut.pc_next_val.value = int(str(dut.pc_val.value), 2) + 4

    await dut.clk.rising_edge
    await dut.clk.falling_edge
    assert dut.pc_val.value == 4, "PC should be 4"


@cocotb.test()
async def test_alu_ctrl(dut):
    """Testing ALU Control operations"""

    await setup_clock(dut)

    dut.A.value = 0
    dut.B.value = 0

    await test_alu_ctrl_op(dut, TestInst.ADDI, "ADDI", AluOp.ALU_OP_ADD)
    await test_alu_ctrl_op(dut, TestInst.SLTI, "SLTI", AluOp.ALU_OP_SLT)
    await test_alu_ctrl_op(dut, TestInst.SLTIU, "SLTIU", AluOp.ALU_OP_SLTU)
    await test_alu_ctrl_op(dut, TestInst.XORI, "XORI", AluOp.ALU_OP_XOR)
    await test_alu_ctrl_op(dut, TestInst.ORI, "ORI", AluOp.ALU_OP_OR)
    await test_alu_ctrl_op(dut, TestInst.ANDI, "ANDI", AluOp.ALU_OP_AND)
    await test_alu_ctrl_op(dut, TestInst.SLLI, "SLLI", AluOp.ALU_OP_SLL)
    await test_alu_ctrl_op(dut, TestInst.SRLI, "SRLI", AluOp.ALU_OP_SRL)
    await test_alu_ctrl_op(dut, TestInst.SRAI, "SRAI", AluOp.ALU_OP_SRA)
    await test_alu_ctrl_op(dut, TestInst.ADD, "ADD", AluOp.ALU_OP_ADD)
    await test_alu_ctrl_op(dut, TestInst.SUB, "ADD", AluOp.ALU_OP_SUB)
    await test_alu_ctrl_op(dut, TestInst.SLL, "ADD", AluOp.ALU_OP_SLL)
    await test_alu_ctrl_op(dut, TestInst.SLT, "ADD", AluOp.ALU_OP_SLT)
    await test_alu_ctrl_op(dut, TestInst.SLTU, "SLTU", AluOp.ALU_OP_SLTU)
    await test_alu_ctrl_op(dut, TestInst.XOR, "XOR", AluOp.ALU_OP_XOR)
    await test_alu_ctrl_op(dut, TestInst.SRL, "SRL", AluOp.ALU_OP_SRL)
    await test_alu_ctrl_op(dut, TestInst.SRA, "SRA", AluOp.ALU_OP_SRA)
    await test_alu_ctrl_op(dut, TestInst.OR, "OR", AluOp.ALU_OP_OR)
    await test_alu_ctrl_op(dut, TestInst.AND, "AND", AluOp.ALU_OP_AND)
    await test_alu_ctrl_op(dut, TestInst.LB, "LB", AluOp.ALU_OP_ADD)
    await test_alu_ctrl_op(dut, TestInst.LH, "LH", AluOp.ALU_OP_ADD)
    await test_alu_ctrl_op(dut, TestInst.LW, "LW", AluOp.ALU_OP_ADD)
    await test_alu_ctrl_op(dut, TestInst.LBU, "LBU", AluOp.ALU_OP_ADD)
    await test_alu_ctrl_op(dut, TestInst.LHU, "LHU", AluOp.ALU_OP_ADD)
    await test_alu_ctrl_op(dut, TestInst.SB, "SB", AluOp.ALU_OP_ADD)
    await test_alu_ctrl_op(dut, TestInst.SH, "SH", AluOp.ALU_OP_ADD)
    await test_alu_ctrl_op(dut, TestInst.SW, "SW", AluOp.ALU_OP_ADD)
    await test_alu_ctrl_op(dut, TestInst.BEQ, "BEQ", AluOp.ALU_OP_ADD)
    await test_alu_ctrl_op(dut, TestInst.BNE, "BNE", AluOp.ALU_OP_ADD)
    await test_alu_ctrl_op(dut, TestInst.BLT, "BLT", AluOp.ALU_OP_ADD)
    await test_alu_ctrl_op(dut, TestInst.BGE, "BGE", AluOp.ALU_OP_ADD)
    await test_alu_ctrl_op(dut, TestInst.BLTU, "BLTU", AluOp.ALU_OP_ADD)
    await test_alu_ctrl_op(dut, TestInst.BGEU, "BGEU", AluOp.ALU_OP_ADD)


@cocotb.test()
async def test_alu(dut):
    """Testing ALU"""

    await setup_clock(dut)

    await test_alu_op(dut, 1, 1, AluOp.ALU_OP_ADD, "ALU_OP_ADD", 2)
    await test_alu_op(dut, 1, 1, AluOp.ALU_OP_SUB, "ALU_OP_SUB", 0)
    await test_alu_op(dut, 10, 20, AluOp.ALU_OP_AND, "ALU_OP_AND", 10 & 20)
    await test_alu_op(dut, 10, 20, AluOp.ALU_OP_OR, "ALU_OP_OR", 10 | 20)
    await test_alu_op(dut, 10, 20, AluOp.ALU_OP_XOR, "ALU_OP_XOR", 10 ^ 20)

    await test_alu_op(dut, 4, 1, AluOp.ALU_OP_SLT, "ALU_OP_SLT", 0)
    await test_alu_op(dut, -4, -5, AluOp.ALU_OP_SLT, "ALU_OP_SLT", 0)
    await test_alu_op(dut, 1, 4, AluOp.ALU_OP_SLT, "ALU_OP_SLT", 1)
    await test_alu_op(dut, -1, 4, AluOp.ALU_OP_SLT, "ALU_OP_SLT", 1)

    await test_alu_op(dut, 5, 1, AluOp.ALU_OP_SLTU, "ALU_OP_SLTU", 0)
    await test_alu_op(dut, 1, 5, AluOp.ALU_OP_SLTU, "ALU_OP_SLTU", 1)

    await test_alu_op(dut, 4, 1, AluOp.ALU_OP_SLL, "ALU_OP_SLL", 4 << 1)
    await test_alu_op(dut, 4, 1, AluOp.ALU_OP_SRL, "ALU_OP_SRL", 4 >> 1)

    await test_alu_op(dut, 4, 1, AluOp.ALU_OP_SRA, "ALU_OP_SRA", 4 >> 1)


@cocotb.test()
async def test_imm_gen_value(dut):
    """Testing Immediate value generator"""

    await setup_clock(dut)

    for key in TestInst:
        decoded = tinyrv.decode(int(key.value, 2))
        imm_value = get_immediate(decoded)
        dut.instruction.value = key.value
        await test_imm_operand(dut, key.name, imm_value, decoded)


@cocotb.test()
async def test_branch_unit(dut):
    """Testing branch unit"""

    await setup_clock(dut)

    await test_branch_op(dut, 10, 20, TestInst.BEQ, "BEQ", False)
    await test_branch_op(dut, 10, 10, TestInst.BEQ, "BEQ", True)

    await test_branch_op(dut, 10, 20, TestInst.BNE, "BNE", True)
    await test_branch_op(dut, 10, 10, TestInst.BNE, "BNE", False)

    await test_branch_op(dut, 10, 20, TestInst.BGE, "BGE", False)
    await test_branch_op(dut, -10, 20, TestInst.BGE, "BGE", False)
    await test_branch_op(dut, 20, 10, TestInst.BGE, "BGE", True)
    await test_branch_op(dut, -10, -20, TestInst.BGE, "BGE", True)

    await test_branch_op(dut, 10, 20, TestInst.BGEU, "BGEU", False)
    await test_branch_op(dut, 20, 10, TestInst.BGEU, "BGEU", True)

    await test_branch_op(dut, 10, 20, TestInst.BLT, "BLT", True)
    await test_branch_op(dut, -10, 20, TestInst.BLT, "BLT", True)
    await test_branch_op(dut, 20, 10, TestInst.BLT, "BLT", False)
    await test_branch_op(dut, -10, -20, TestInst.BLT, "BLT", False)

    await test_branch_op(dut, 10, 20, TestInst.BLTU, "BLTU", True)

    await test_branch_op(dut, 0, 0, TestInst.JAL, "JALR", True)
    await test_branch_op(dut, 0, 0, TestInst.JALR, "JAL", True)


@cocotb.test()
async def test_data_memory(dut):
    """Testing data memory"""

    await setup_clock(dut)

    widths = [4, 2, 1]
    width_map = {4: MemWidth.word, 2: MemWidth.half, 1: MemWidth.byte}

    test_data_map = {
        4: [0xFBCD_ABCF],
        2: [0xABCF, None, 0xFBCD],
        1: [0xCF, 0xAB, 0xCD, 0xFB],
    }

    width_offsets = {4: [0], 2: [0, 2], 1: [0, 1, 2, 3]}

    for width in widths:
        dut.mem_unsigned.value = 1
        dut.mem_width.value = width_map[width]

        dut.mem_write_enable.value = 1
        for i in range(0, 32 * width, width):
            dut.mem_addr.value = i
            dut.mem_write_data.value = 0
            await dut.clk.rising_edge

        dut.mem_write_enable.value = 0
        for i in range(0, 32 * width, width):
            dut.mem_addr.value = i
            await dut.clk.rising_edge
            await Timer(1, "step")
            assert (
                dut.mem_read_data.value == 0
            ), f"W={width}: mem[{hex(i)}] != 0, is {hex(dut.mem_read_data.value)}"

    dut.mem_unsigned.value = 1
    dut.mem_write_enable.value = 1
    dut.mem_width.value = MemWidth.word
    for i in range(0, 32 * 4, 4):
        dut.mem_addr.value = i
        dut.mem_write_data.value = test_data_map[4][0]
        await dut.clk.rising_edge

    dut.mem_write_enable.value = 0
    for i in range(0, 32 * 4, 4):
        for width in widths:
            for offset in width_offsets[width]:
                affective_addr = i + offset
                dut.mem_addr.value = affective_addr
                dut.mem_width.value = width_map[width]
                await dut.clk.rising_edge
                await Timer(1, "step")
                should_be = test_data_map[width][offset]
                assert (
                    dut.mem_read_data.value == should_be
                ), f"W={width}: mem[{hex(affective_addr)}] != {hex(should_be)}, is {dut.mem_read_data.value}"


@cocotb.test()
async def test_inst_memory(dut):
    """Testing instruction memory"""

    await setup_clock(dut)

    test_val = 0xABCD_DCBA

    for i in range(0, 32):
        dut.inst_mem.memory[i].value = test_val
        await dut.clk.rising_edge

    for i in range(0, 32):
        dut.inst_addr.value = i
        await dut.clk.rising_edge
        await Timer(1, "step")
        assert (
            dut.inst_read_data.value == test_val
        ), f"inst_mem[{hex(i)}] != {hex(test_val)}, is {dut.inst_read_data.value}"


@cocotb.test()
async def test_reg_file(dut):
    """Testing register file"""

    await setup_clock(dut)

    dut.reg_rs1.value = 0
    dut.reg_rs2.value = 0
    dut.reg_rd.value = 0
    dut.reg_write_data.value = 0
    dut.reg_write_enable.value = 0

    await dut.clk.rising_edge

    dut.reg_write_enable.value = 1
    for i in range(0, 32):
        dut.reg_rd.value = i
        dut.reg_write_data.value = 0
        await dut.clk.rising_edge

    await dut.clk.rising_edge

    dut.reg_write_enable.value = 0
    for i in range(0, 32):
        dut.reg_rs1.value = i
        dut.reg_rs2.value = i

        await dut.clk.rising_edge

        assert (
            dut.reg_rs1_data.value == 0
        ), f"register rs1=x{i} should have 0, has {dut.reg_rs1_data.value}"
        assert (
            dut.reg_rs2_data.value == 0
        ), f"register rs2=x{i} should have 0, has {dut.reg_rs2_data.value}"

    await dut.clk.rising_edge

    dut.reg_write_enable.value = 1
    for i in range(0, 32):
        dut.reg_rs1.value = i
        dut.reg_rs2.value = i
        dut.reg_rd.value = i
        dut.reg_write_data.value = i + 1
        await dut.clk.rising_edge

    await dut.clk.rising_edge

    dut.reg_write_enable.value = 0
    for i in range(0, 32):
        dut.reg_rs1.value = i
        dut.reg_rs2.value = i

        await dut.clk.rising_edge
        await Timer(1, "step")

        should_have = 0 if i == 0 else i + 1

        assert (
            dut.reg_rs1_data.value == should_have
        ), f"register rs1=x{i} should have {should_have}, has {dut.reg_rs1_data.value}"
        assert (
            dut.reg_rs2_data.value == should_have
        ), f"register rs2=x{i} should have {should_have}, has {dut.reg_rs2_data.value}"
