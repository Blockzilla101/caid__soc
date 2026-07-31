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

    while get_sim_time("ns") < 150:
        await Timer(1, "ns")

    assert dut.wb_data_mem.memory[3].value == 0xA0
    # assert dut.wb_data_mem.memory[2].value == 0x00
    # assert dut.wb_data_mem.memory[1].value == 0x00
    assert dut.wb_data_mem.memory[0].value == 0xD0
