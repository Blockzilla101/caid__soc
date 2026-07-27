import cocotb
from util import setup_clock


@cocotb.test()
async def test_alu_inst(dut):
    """Testing ALU instruction (R-Type)"""

    await setup_clock(dut)
