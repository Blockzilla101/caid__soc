from cocotb.clock import Clock


async def setup_clock(dut):
    Clock(dut.clk, 1, "ns").start(False)
    dut.rst.value = 1

    await dut.clk.rising_edge
    dut.rst.value = 0


def sign_extend(value, bits):
    sign_bit = 1 << (bits - 1)
    return (value & (sign_bit - 1)) - (value & sign_bit)
