from os import environ

tech_name = "sky130"
spice_name = "ngspice"

output_path = "build/sram_1rw1r_32x1024"
output_name = "sram_1rw1r_32x1024"

num_threads = 12
num_sim_threads = 12

num_rw_ports = 1
num_r_ports = 1
num_w_ports = 0

num_words = 1024
word_size = 32

words_per_row = 4
write_size = 8

# num_spare_rows = 1
# num_spare_cols = 1

supply_pin_type = "ring"

nominal_corner_only = True
netlist_only = False
route_supplies = False if environ.get("USE_POWER_PINS") is None else True
check_lvsdrc = False  # fixme: SPICE & GDS models mismatch, should check my ciel

analytical_delay = True
# use_pex = True and not analytical_delay
# inline_lvsdrc = True

output_extended_config = True
output_datasheet_info = True

perimeter_pins = True
keep_temp = True
# trim_netlist = False
