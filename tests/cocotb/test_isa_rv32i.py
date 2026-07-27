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


async def load_inst(dut, inst_strs: list[str], reset=True):
    if reset:
        await reset_state(dut)

    insts = asm_inst(inst_strs)
    for i in range(0, len(insts) * 4, 4):
        dut.inst_mem.memory[i + 4].value = insts[i // 4]

    await dut.clk.rising_edge
    await Timer(1, "step")


@cocotb.test()
async def test_alu_inst(dut):
    """Testing ALU instruction (R-Type)"""

    await setup_clock(dut)
    await load_inst(dut, ["addi x5, x0, 1"])

    await dut.clk.rising_edge

    assert dut.reg_file.registers[5].value == 1

    await dut.clk.rising_edge
