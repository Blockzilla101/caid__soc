import cocotb
from cocotb.triggers import NextTimeStep, Timer
from cocotb.utils import get_sim_time
from util import setup_clock


@cocotb.test()
async def test_wishbone(dut):
    """Testing wishbone bus"""
    await setup_clock(dut)

    # max_cylces = 50
    # for _ in range(max_cylces):
    # await NextTimeStep()

    while get_sim_time("ns") < 1000:
        await Timer(1, "ns")
