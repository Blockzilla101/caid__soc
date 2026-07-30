import cocotb
from cocotb.triggers import NextTimeStep, Timer
from cocotb.utils import get_sim_time
from util import setup_clock


def reset_bus(dut):
    dut.wb_CYC_I.value = 0
    dut.wb_STB_I.value = 0
    dut.wb_WE_I.value = 0
    dut.wb_ADR_I.value = 0
    dut.wb_SEL_I.value = 0
    dut.wb_DAT_I.value = 0


@cocotb.test()
async def test_wb_mem(dut):
    """Test wishbone memory"""

    while get_sim_time("ns") < 500:
        await Timer(1, "ns")

    # reset_bus(dut)
    # await setup_clock_sig(dut.wb_CLK_I, dut.wb_RST_I)

    # dut.wb_CYC_I.value = 1
    # dut.wb_STB_I.value = 1
    # dut.wb_WE_I.value = 1
    # dut.wb_ADR_I.value = 0
    # dut.wb_SEL_I.value = 0xF
    # dut.wb_DAT_I.value = 0xA0B0C0D0

    # await dut.wb_CLK_I.rising_edge
    # await dut.wb_CLK_I.rising_edge

    # reset_bus(dut)

    # await dut.wb_CLK_I.rising_edge  #

    # await dut.wb_CLK_I.rising_edge

    # dut.wb_CYC_I.value = 1
    # dut.wb_STB_I.value = 1
    # dut.wb_WE_I.value = 0
    # dut.wb_ADR_I.value = 0
    # dut.wb_SEL_I.value = 0xF

    # await dut.wb_CLK_I.rising_edge
    # await dut.wb_CLK_I.rising_edge

    # reset_bus(dut)

    # await dut.wb_CLK_I.rising_edge
