import cocotb
from cocotb.triggers import Timer
from util import setup_clock
from riscv_assembler.convert import AssemblyConverter

asm = AssemblyConverter(hex_mode=True)
inst_nop = 0x00000013


def asm_inst(inst: list[str]):
    assembled = asm.convert(str.join("\n", inst))
    if assembled is None:
        raise ValueError(f"Invalid instruction: {inst}")
    return [int(x, 16) for x in assembled]


async def reset_state(dut):
    dut.pc.counter.value = 4
    for i in range(0, 32):
        dut.reg_file.registers[i].value = 0

    for i in range(0, 1024):
        dut.data_mem.memory[i].value = 0

    for i in range(0, 512):
        dut.inst_mem.memory[i].value = inst_nop

    dut.rst.value = 1
    await dut.clk.rising_edge
    dut.rst.value = 0


async def load_and_exec_inst(dut, inst_strs: list[str], reset=False):
    if reset:
        await reset_state(dut)
        await dut.clk.rising_edge

    dut.pc.counter.value = 4

    insts = asm_inst(inst_strs)
    for i in range(0, len(insts) * 4, 4):
        dut.inst_mem.memory[i + 4].value = insts[i // 4]

    await dut.clk.rising_edge  # instruction fetched
    await dut.clk.rising_edge  # instruction executed
    await Timer(1, "step")


async def exec_imm(dut, inst: str | int):
    insts = [inst] if isinstance(inst, int) else asm_inst([inst])
    # insts = asm_inst([inst])
    dut.inst_mem.memory[int(str(dut.pc.counter.value), 2)].value = insts[0]
    dut.instruction.value = insts[0]

    await dut.clk.rising_edge
    await Timer(1, "step")


def assert_reg(dut, reg_num, val, msg=None):
    assert dut.reg_file.registers[reg_num].value == val & 0xFFFF_FFFF, (
        f"x{reg_num} != {val}, is {dut.reg_file.registers[reg_num].value}"
        if msg is None
        else msg
    )


def assert_mem(dut, mem_addr, val, msg=None):
    assert dut.data_mem.memory[mem_addr].value == val & 0xFF
    assert dut.data_mem.memory[mem_addr + 1].value == val >> 8 & 0xFF
    assert dut.data_mem.memory[mem_addr + 2].value == val >> 16 & 0xFF
    assert dut.data_mem.memory[mem_addr + 3].value == val >> 24 & 0xFF


@cocotb.test()
async def test_imm_inst(dut):
    """Testing immediate instructions (auipc, lui)"""

    await setup_clock(dut)
    await reset_state(dut)

    await exec_imm(dut, 0x00032237)  # lui x4, 50
    assert_reg(dut, 4, 50 << 12)

    await exec_imm(dut, 0x00032217)  # auipc x5, 50
    assert_reg(dut, 4, int(str(dut.pc.counter.value), 2) - 4 + (50 << 12))


@cocotb.test()
async def test_alu_imm_inst(dut):
    """Testing ALU immediate instructions (I-Type)"""

    await setup_clock(dut)
    await reset_state(dut)
    await dut.clk.rising_edge

    await exec_imm(dut, "addi x5, x0, 1")
    assert_reg(dut, 5, 1, "x5 != 1")

    assert dut.reg_file.registers[5].value == 1

    await exec_imm(dut, "addi x6, x0, -2")
    assert_reg(dut, 6, -2)

    await exec_imm(dut, "slti x4, x6, 0")
    assert_reg(dut, 4, 1)

    await exec_imm(dut, "slti x4, x6, -5")
    assert_reg(dut, 4, 0)

    await exec_imm(dut, "sltiu x4, x6, 5")
    assert_reg(dut, 4, 0)

    await exec_imm(dut, "sltiu x4, x5, 5")
    assert_reg(dut, 4, 1)

    x5 = 25
    await exec_imm(dut, f"addi x5, x0, {x5}")

    await exec_imm(dut, "xori x4, x5, 10")
    assert_reg(dut, 4, x5 ^ 10)

    await exec_imm(dut, "ori x4, x5, 10")
    assert_reg(dut, 4, x5 | 10)

    await exec_imm(dut, "andi x4, x5, 10")
    assert_reg(dut, 4, x5 & 10)

    await exec_imm(dut, "slli x4, x5, 5")
    assert_reg(dut, 4, x5 << 5)

    await exec_imm(dut, 0x0052D213)  # srli x4, x5, 5
    assert_reg(dut, 4, x5 >> 5)

    await exec_imm(dut, "srai x4, x5, 5")
    assert_reg(dut, 4, x5 >> 5)


@cocotb.test()
async def test_alu_inst(dut):
    """Testing ALU instructions (R-Type)"""

    await setup_clock(dut)
    await reset_state(dut)

    x5 = 24
    x6 = 3
    await exec_imm(dut, f"addi x5, x0, {x5}")
    await exec_imm(dut, f"addi x6, x0, {x6}")

    await exec_imm(dut, "add x4, x5, x6")
    assert_reg(dut, 4, x5 + x6)

    await exec_imm(dut, "sub x4, x5, x6")
    assert_reg(dut, 4, x5 - x6)

    await exec_imm(dut, "sll x4, x5, x6")
    assert_reg(dut, 4, x5 << x6)

    await exec_imm(dut, 0x0062A233)  # slt x4, x5, x6
    assert_reg(dut, 4, x5 < x6)

    await exec_imm(dut, "sltu x4, x5, x6")
    assert_reg(dut, 4, x5 < x6)

    await exec_imm(dut, "xor x4, x5, x6")
    assert_reg(dut, 4, x5 ^ x6)

    await exec_imm(dut, "srl x4, x5, x6")
    assert_reg(dut, 4, x5 >> x6)

    await exec_imm(dut, "sra x4, x5, x6")
    assert_reg(dut, 4, x5 >> x6)

    await exec_imm(dut, "or x4, x5, x6")
    assert_reg(dut, 4, x5 | x6)

    await exec_imm(dut, "and x4, x5, x6")
    assert_reg(dut, 4, x5 & x6)


@cocotb.test()
async def test_store_inst(dut):
    """Testing store instructions"""

    await setup_clock(dut)
    await reset_state(dut)

    # load 32bit value into x5
    x5 = 0xABCD_C5BA
    await exec_imm(dut, f"addi x5, x0, {x5 & 0xFFF}")
    await exec_imm(dut, (x5 & 0xFFFF_F000) | 0x337)  # f"lui x6, {x5 >> 12}")
    await exec_imm(dut, f"or x4, x5, x6")
    assert_reg(dut, 4, x5)

    await exec_imm(dut, f"sw x4, 0(x0)")
    assert_mem(dut, 0, x5)

    await exec_imm(dut, f"sw x0, 0(x0)")
    await exec_imm(dut, f"sh x4, 0(x0)")
    assert_mem(dut, 0, x5 & 0xFFFF)

    await exec_imm(dut, f"sw x0, 0(x0)")
    await exec_imm(dut, f"sb x4, 0(x0)")
    assert_mem(dut, 0, x5 & 0xFF)


@cocotb.test()
async def test_load_inst(dut):
    """Testing load instructions"""

    await setup_clock(dut)
    await reset_state(dut)

    # load 32bit value into x5
    x5 = 0xABCD_C5BA
    await exec_imm(dut, f"addi x5, x0, {x5 & 0xFFF}")
    await exec_imm(dut, (x5 & 0xFFFF_F000) | 0x337)  # f"lui x6, {x5 >> 12}")
    await exec_imm(dut, f"or x4, x5, x6")
    assert_reg(dut, 4, x5)

    await exec_imm(dut, f"sw x4, 0(x0)")


@cocotb.test(skip=True)
async def test_jump_inst(dut):
    """Testing jump instructions"""


@cocotb.test(skip=True)
async def test_branch_inst(dut):
    """Testing branch instructions"""
