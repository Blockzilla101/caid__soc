tech_name = "sky130"
nominal_corner_only = True


route_supplies = False
# route_supplies = "ring"
# route_supplies = "left"
check_lvsdrc = True

perimeter_pins = False
netlist_only = True
# analytical_delay = False

output_name = "test_mem"
output_path = "build/test_mem".format(**locals())

num_threads = 12
num_sim_threads = 12

write_graph = True

word_size = 32
num_words = 32
verbose = 1

num_rw_ports = 0
num_r_ports = 1
num_w_ports = 1
