import cocotb
from util import setup_clock


@cocotb.test()
async def test_wishbone(dut):
    """Testing wishbone bus"""
    await setup_clock(dut)
