import cocotb
from cocotb import log
from cocotb.triggers import Timer
from util import setup_clock, assert_reg, assert_mem
import tinyrv
import os


async def reset_state(dut):
    dut.pc.counter.value = 0


@cocotb.test()
async def test_hex_file(dut):
    """Executing Hex file"""
    hex_name = os.environ.get("HEX_NAME")

    log.info(f"running hex file '{hex_name}'")

    await setup_clock(dut)
    await reset_state(dut)

    cycles = 0

    while True:
        if cycles > 20000:
            assert False, "Ran for more than 20k cycles"

        inst = str(dut.instruction.value)
        if "X" in inst:
            await dut.clk.rising_edge
            await dut.clk.rising_edge
            inst = str(dut.instruction.value)
            assert "X" not in inst and cycles < 10, "Encountered undefined instruction"
            if "X" in inst:
                break

        last_pc_val = str(dut.pc_val.value)
        inst = int(inst, 2)
        await dut.clk.rising_edge
        await Timer(1, "ns")
        pc_val = str(dut.pc_val.value)

        if last_pc_val == pc_val:
            break

        cycles = cycles + 1

    await dut.clk.rising_edge

    hex_name = os.environ.get("HEX_NAME")
    if hex_name == "gcc_fibonacci":
        assert_mem(dut, 4, 1)
        assert_mem(dut, 8, 144)
    elif hex_name == "asm_fibbonacci":
        assert_reg(dut, 5, 144)
    elif hex_name == "gcc_mem_test":
        for i in range(0, 32 * 4, 4):
            assert_mem(dut, i + 4, i // 4)
    else:
        raise ValueError(f"No checks defined for hex file: {hex_name}")
