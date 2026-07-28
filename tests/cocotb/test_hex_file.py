import cocotb
from cocotb.triggers import Timer
from util import setup_clock, set_inst, inst_nop
import tinyrv


async def reset_state(dut):
    dut.pc.counter.value = 0
    for i in range(0, 32):
        dut.reg_file.registers[i].value = 0


@cocotb.test()
async def test_hex_file(dut):
    """Testing Hex file"""

    await setup_clock(dut)
    await reset_state(dut)

    # for i in range(0, 2048, 4):
    #     val = [
    #         str(dut.inst_mem.memory[i + 3].value),
    #         str(dut.inst_mem.memory[i + 2].value),
    #         str(dut.inst_mem.memory[i + 1].value),
    #         str(dut.inst_mem.memory[i + 0].value),
    #     ]

    #     if len([s for s in val if "X" in s]) == 0:
    #         val = [int(v, 2) for v in val]
    #         inst = val[0] << 24 | val[1] << 16 | val[2] << 8 | val[3]
    #         print(tinyrv.decode(inst))
    #         await dut.clk.rising_edge

    # await dut.clk.rising_edge

    cycles = 0

    while True:
        if cycles > 20000:
            break

        inst = str(dut.instruction.value)
        if "X" in inst:
            await dut.clk.rising_edge
            await dut.clk.rising_edge
            inst = str(dut.instruction.value)
            if "X" in inst:
                break

        last_pc_val = int(str(dut.pc_val.value), 2)
        inst = int(inst, 2)
        await dut.clk.rising_edge
        await Timer(1, "ns")
        pc_val = int(str(dut.pc_val.value), 2)

        if last_pc_val == pc_val:
            break

        cycles = cycles + 1

    await dut.clk.rising_edge
