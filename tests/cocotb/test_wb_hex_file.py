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
    """Executing Hex file (wishbone)"""
    hex_name = os.environ.get("HEX_NAME")

    log.info(f"running hex file '{hex_name}'")

    riscv_core = dut.wb_riscv.riscv

    await setup_clock(dut)
    await reset_state(riscv_core)

    cycles = 0

    while True:
        if cycles > 20000:
            # assert False, "Ran for more than 20k cycles"
            break

        inst = str(riscv_core.instruction.value)
        if "X" in inst:
            await dut.clk.rising_edge
            await dut.clk.rising_edge
            inst = str(riscv_core.instruction.value)
            # assert ("X" not in inst) and (
            # cycles < 10
            # ), f"Encountered undefined instruction cycle={cycles}, pc={dut.pc_val}"
            if "X" in inst:
                break

        last_pc_val = str(riscv_core.pc_val.value)
        stalled = bool(riscv_core.cpu_stall.value)
        inst = int(inst, 2)
        await dut.clk.rising_edge
        await Timer(1, "ns")
        pc_val = str(riscv_core.pc_val.value)

        if last_pc_val == pc_val and not stalled:
            break

        cycles = cycles + 1

    await dut.clk.rising_edge

    print("cycles", cycles)

    hex_name = os.environ.get("HEX_NAME")
    if hex_name == "asm_wb_mem_test":
        for i in range(0, 32):
            print(i, dut.wb_data_mem.memory[i].value)
    elif hex_name == "gcc_wb_gcc_test":
        pass
    elif hex_name == "gcc_wb_fpga_test":
        pass
    else:
        raise ValueError(f"No checks defined for hex file: {hex_name}")
