from cocotb_tools.runner import get_runner
import os.path as path
import shutil
import os
from os import environ

rtl_path = "../../rtl"
sim_path = "./sim"
gcc_build_path = "../gcc/build"
asm_build_path = "../assembly/build"

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
    f"{rtl_path}/wishbone/wb_slave_gpio.v",
    f"{rtl_path}/wishbone/wb_top.v",
    f"{rtl_path}/wishbone/wb_controller.v",
]

fpga_sources = [
    f"{rtl_path}/fpga/fpga_top.v",
    f"{rtl_path}/fpga/rst_gen.v",
]

runner = get_runner("icarus")


def run_test_single(module: str):
    run_test(
        sources=[f"{rtl_path}/riscv/{module}.v"],
        hdl_toplevel=module,
        test_module=f"test_{module}",
    )


def run_hex_test(hex_type, mem_file: str):
    is_wishbone = mem_file.startswith("wb_")
    hdl_toplevel = "wb_top" if is_wishbone else "riscv_top"
    test_module = "test_wb_hex_file" if is_wishbone else "test_hex_file"
    sources = [*riscv_sources, *wb_sources] if is_wishbone else riscv_sources

    if "_fpga_" in mem_file:
        sources = [*riscv_sources, *wb_sources, *fpga_sources]
        hdl_toplevel = "fpga_top"

    defines = {
        "IMEM_LOAD_HEX": "1",
        "IMEM_HEX_PATH": path.abspath(
            f"{asm_build_path if hex_type == 'asm' else gcc_build_path}/{mem_file}.mem"
        ),
        "HEX_NAME": f"{hex_type}_{mem_file}",
    }

    if is_wishbone:
        defines["WISHBONE_ENABLE"] = "1"

    run_test(
        sources=sources,
        hdl_toplevel=hdl_toplevel,
        test_module=test_module,
        defines=defines,
        waveform_name=f"{hex_type}__{mem_file}_riscv.fst",
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
            sources=[*riscv_sources, *wb_sources, f"{sim_path}/tb_wb_slaves.v"],
            hdl_toplevel="tb_wb_slaves",
            test_module="test_wishbone_slaves",
            defines={
                "WISHBONE_ENABLE": "1",
                "IMEM_LOAD_HEX": "1",
                "IMEM_HEX_PATH": path.abspath(f"{asm_build_path}/wb_mem_test.mem"),
            },
        )
        run_test(
            sources=[*riscv_sources, *wb_sources],
            hdl_toplevel="wb_top",
            test_module="test_wishbone_mem",
            defines={
                "WISHBONE_ENABLE": "1",
                "IMEM_LOAD_HEX": "1",
                "IMEM_HEX_PATH": path.abspath(f"{asm_build_path}/wb_mem_test.mem"),
            },
        )

    gcc_memory_files = []
    asm_memory_files = []

    for _, _, filenames in os.walk(path.abspath(f"{gcc_build_path}/")):
        gcc_memory_files.extend([f[:-4] for f in filenames if f.endswith(".mem")])

    for _, _, filenames in os.walk(path.abspath(f"{asm_build_path}/")):
        asm_memory_files.extend([f[:-4] for f in filenames if f.endswith(".mem")])

    if environ.get("ASM_TEST"):
        for mem in asm_memory_files:
            run_hex_test("asm", mem)

    if environ.get("GCC_TEST"):
        for mem in gcc_memory_files:
            run_hex_test("gcc", mem)


if __name__ == "__main__":
    test_all_modules()
