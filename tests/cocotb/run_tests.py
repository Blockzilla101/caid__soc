from cocotb_tools.runner import get_runner
import os.path as path
import shutil
import os

src_path = "../../src"
sim_path = "./sim"

runner = get_runner("icarus")

def run_test_single(module: str):
    run_test(sources=[f"../../src/riscv/{module}.v"], hdl_toplevel=module, test_module=f"test_{module}")

def run_test(sources: list[str], hdl_toplevel: str, test_module: str):
    if not path.exists("waves"):
        os.mkdir("waves")
    
    runner.build(
        sources=sources,
        hdl_toplevel=hdl_toplevel,
        includes=["../../src/riscv/include"],
        clean=True
    )
    
    runner.test(
        hdl_toplevel=hdl_toplevel,
        test_module=test_module,
        waves=True
    )
    
    waveform = f"{hdl_toplevel}.fst"
    shutil.copyfile(path.join("sim_build", waveform), path.join("waves", waveform))

def test_all_modules():
    run_test(sources=[f"{src_path}/riscv/control_unit.v", f"{src_path}/riscv/alu_control.v", f"{src_path}/riscv/imm_gen.v", f"{sim_path}/tb_functional_units.v"], hdl_toplevel="tb_functional_units", test_module="test_functional_units")

    run_test_single('register_file')
    
if __name__ == "__main__":
    test_all_modules()