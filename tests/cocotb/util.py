from cocotb.clock import Clock

inst_nop = 0x00000013


async def setup_clock(dut):
    Clock(dut.clk, 1, "ns").start(False)
    dut.rst.value = 1

    await dut.clk.rising_edge
    dut.rst.value = 0


def sign_extend(value, bits):
    sign_bit = 1 << (bits - 1)
    return (value & (sign_bit - 1)) - (value & sign_bit)


def set_inst(dut, addr, inst):
    dut.inst_mem.memory[addr + 0].value = inst & 0xFF
    dut.inst_mem.memory[addr + 1].value = (inst >> 8) & 0xFF
    dut.inst_mem.memory[addr + 2].value = (inst >> 16) & 0xFF
    dut.inst_mem.memory[addr + 3].value = (inst >> 24) & 0xFF
