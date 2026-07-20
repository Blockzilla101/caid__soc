import cocotb
from cocotb.triggers import FallingEdge, Timer
from cocotb.clock import Clock

@cocotb.test()
async def test_reg_file(dut):
    """Testing Register File"""

    Clock(dut.clk, 1, "ns").start()

    dut.rs1.value = 0
    dut.rs2.value = 0
    dut.rd.value = 0
    dut.write_data.value = 0
    dut.write_enable.value = 0

    await FallingEdge(dut.clk)

    dut.write_enable.value = 1
    for i in range(0, 32):
        dut.rd.value = i
        dut.write_data.value = 0
        await FallingEdge(dut.clk)

    dut.write_enable.value = 1
    for i in range(0, 32):
        dut.rs1.value = i
        dut.rs2.value = i

        await FallingEdge(dut.clk)

        assert dut.rs1_data.value == 0, f"register rs1=x{i} should have 0, has {dut.rs1_data.value}"
        assert dut.rs2_data.value == 0, f"register rs2=x{i} should have 0, has {dut.rs2_data.value}"
       
        dut.rd.value = i
        dut.write_data.value = i + 1
       
        await FallingEdge(dut.clk)

    dut.write_enable.value = 0
    await FallingEdge(dut.clk)

    for i in range(0, 32):
        dut.rs1.value = i
        dut.rs2.value = i

        await FallingEdge(dut.clk)

        should_have = 0 if i == 0 else i + 1
        assert dut.rs1_data.value == should_have, f"register rs1=x{i} should have {should_have}, has {dut.rs1_data.value}"
        assert dut.rs2_data.value == should_have, f"register rs2=x{i} should have {should_have}, has {dut.rs2_data.value}"
