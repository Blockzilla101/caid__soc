from cocotb.clock import Clock

inst_nop = 0x00000013


async def setup_debug():
    import debugpy

    debugpy.listen(5678)
    print("Waiting for debugger attach...")
    debugpy.wait_for_client()


async def setup_clock_sig(clk_sig, rst_sig):
    Clock(clk_sig, 1, "ns").start(False)
    rst_sig.value = 1

    await clk_sig.rising_edge
    rst_sig.value = 0


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


def assert_reg(dut, reg_num, val, msg=None):
    assert dut.reg_file.registers[reg_num].value == val & 0xFFFF_FFFF, (
        f"x{reg_num} != {val}, is {dut.reg_file.registers[reg_num].value}"
        if msg is None
        else msg
    )


def assert_mem(dut, mem_addr, val, width=4):
    assert dut.data_mem.memory[mem_addr].value == val & 0xFF
    if width >= 2:
        assert dut.data_mem.memory[mem_addr + 1].value == val >> 8 & 0xFF
    if width == 4:
        assert dut.data_mem.memory[mem_addr + 2].value == val >> 16 & 0xFF
    if width == 4:
        assert dut.data_mem.memory[mem_addr + 3].value == val >> 24 & 0xFF
