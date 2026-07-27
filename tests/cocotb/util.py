from cocotb.clock import Clock


async def setup_clock(dut):
    Clock(dut.clk, 1, "ns").start(False)
    dut.rst.value = 1

    await dut.clk.rising_edge
    dut.rst.value = 0
