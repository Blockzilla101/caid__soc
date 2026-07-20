import cocotb
from cocotb.triggers import FallingEdge, Timer

@cocotb.test()
async def test_inst_reg(dut):
    """Testing Control Unit"""

    await Timer(1, "ns")
    
    dut.opcode.value = 0

    await Timer(1, "ns")

    dut.opcode.value = '0110011'
    
    await Timer(1, "ns")
    
    dut.opcode.value = '1100011'

    await Timer(1, "ns")

        