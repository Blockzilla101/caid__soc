from cocotb_tools.runner import get_runner
import os.path as path
import shutil
import os
from os import environ

rtl_path = "../../rtl"
sim_path = "./sim"
gcc_build_path = "../gcc/build"
asm_build_path = "../assembly/build"

runner = get_runner("icarus")


def run_test_single(module: str):
    run_test(
        sources=[f"{rtl_path}/riscv/{module}.v"],
        hdl_toplevel=module,
        test_module=f"test_{module}",
    )


def run_test(
    sources: list[str],
    hdl_toplevel: str,
    test_module: str,
    defines={},
    waveform_name=None,
):
    if not path.exists("waves"):
        os.mkdir("waves")

    runner.build(
        sources=sources,
        hdl_toplevel=hdl_toplevel,
        includes=[f"{rtl_path}/include"],
        clean=True,
        defines=defines,
    )

    runner.test(
        hdl_toplevel=hdl_toplevel,
        test_module=test_module,
        waves=True,
        extra_env=defines,
    )

    waveform = f"{hdl_toplevel}.fst"
    shutil.copyfile(
        path.join("sim_build", waveform),
        path.join("waves", waveform_name if waveform_name else waveform),
    )


def test_all_modules():
    riscv_sources = [
        f"{rtl_path}/riscv/branch_unit.v",
        f"{rtl_path}/riscv/control_unit.v",
        f"{rtl_path}/riscv/alu_control.v",
        f"{rtl_path}/riscv/alu.v",
        f"{rtl_path}/riscv/imm_gen.v",
        f"{rtl_path}/riscv/program_counter.v",
        f"{rtl_path}/riscv/register_file.v",
        f"{rtl_path}/riscv/instruction_memory.v",
        f"{rtl_path}/riscv/data_memory.v",
        f"{rtl_path}/riscv/riscv_top.v",
        f"{rtl_path}/riscv/mux3.v",
    ]

    wb_sources = [
        f"{rtl_path}/wishbone/wb_master_riscv.v",
        f"{rtl_path}/wishbone/wb_mux.v",
        f"{rtl_path}/wishbone/wb_slave_addr.v",
        f"{rtl_path}/wishbone/wb_slave_data_mem.v",
        f"{rtl_path}/wishbone/wb_top.v",
    ]

    run_test(
        sources=[
            *riscv_sources,
            f"{sim_path}/tb_functional_units.v",
        ],
        hdl_toplevel="tb_functional_units",
        test_module="test_functional_units",
    )

    run_test(
        sources=riscv_sources,
        hdl_toplevel="riscv_top",
        test_module="test_isa_rv32i",
    )

    if environ.get("WISHBONE_TEST"):
        run_test(
            sources=[*riscv_sources, *wb_sources],
            hdl_toplevel="wb_top",
            test_module="test_wishbone_mem",
            defines={"WISHBONE_ENABLE": "1"},
        )

    gcc_memory_files = []
    asm_memory_files = []

    for _, _, filenames in os.walk(path.abspath(f"{gcc_build_path}/")):
        gcc_memory_files.extend([f[:-4] for f in filenames if f.endswith(".mem")])

    for _, _, filenames in os.walk(path.abspath(f"{asm_build_path}/")):
        asm_memory_files.extend([f[:-4] for f in filenames if f.endswith(".mem")])

    if environ.get("ASM_TEST"):
        for mem in asm_memory_files:
            run_test(
                sources=riscv_sources,
                hdl_toplevel="riscv_top",
                test_module="test_hex_file",
                defines={
                    "IMEM_LOAD_HEX": "1",
                    "IMEM_HEX_PATH": path.abspath(f"{asm_build_path}/{mem}.mem"),
                    "HEX_NAME": f"asm_{mem}",
                },
                waveform_name=f"asm__{mem}_riscv.fst",
            )

    if environ.get("GCC_TEST"):
        for mem in gcc_memory_files:
            run_test(
                sources=riscv_sources,
                hdl_toplevel="riscv_top",
                test_module="test_hex_file",
                defines={
                    "IMEM_LOAD_HEX": "1",
                    "IMEM_HEX_PATH": path.abspath(f"{gcc_build_path}/{mem}.mem"),
                    "HEX_NAME": f"gcc_{mem}",
                },
                waveform_name=f"gcc__{mem}_riscv.fst",
            )


if __name__ == "__main__":
    test_all_modules()
