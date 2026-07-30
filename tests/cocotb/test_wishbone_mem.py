import cocotb
from util import setup_clock


@cocotb.test()
async def test_wishbone(dut):
    """Testing wishbone bus"""
    await setup_clock(dut)

    max_cylces = 50
    for _ in range(max_cylces):
        await dut.clk.rising_edge
