###################
# Configuration options
###################
# This is the technology directory.
# openram_tech = ""

# This is the name of the technology.
tech_name = "sky130"

# Port configuration (1-2 ports allowed)
num_rw_ports = 1
num_r_ports = 1
num_w_ports = 0

# By default, don't use hierarchical wordline
local_array_size = 0

# Write mask size, default will be overwritten with word_size if not user specified
# write_size = None

# These will get initialized by the user or the tech file
# nominal_corner_only = False
supply_voltages = [1.7, 1.8, 1.9]
temperatures = [25, 50, 100]
process_corners = ["SS", "TT", "FF"]
# load_scales = ""
# slew_scales = ""

# Size parameters must be specified by user in config file.
num_words = 32
word_size = 32
# You can manually specify banks, but it is better to auto-detect it.
# num_banks = 1
# words_per_row = None
# num_spare_rows = 0
# num_spare_cols = 0

###################
# ROM configuration options
###################
# rom_endian = "little"
# rom_data = None
# data_type = "bin"
# strap_spacing = 8
# scramble_bits = True

###################
# Control logic options
###################
# Approximate percentage of delay compared to bitlines
# rbl_delay_percentage = 0.5

# multi delay chain is NOT automatically sized, needs to be set by user
# list indexes 0 & 1 need to be even for polarity
# list indexes 2 - 4 need to be odd for polarity
# these default values are the ones used on the September 2023 Chipignite Shuttle
# to test delay based control logic with sky130 1rw1r 8x1024 bit (1KB) with 8 column mux
# multi_delay_chain_pinouts = [2, 10, 11, 17, 31]

# stages for delay chain in rbl control logic only
# delay_chain_stages = 9

# fanout per stage for any control logic
# delay_chain_fanout_per_stage = 4

# accuracy_requirement = 0.75

###################
# Debug options.
###################

# This is the verbosity level to control debug information. 0 is none, 1
# is minimal, etc.
verbose_level = 1
# Drop to pdb on failure?
# debug = False
# Only use corners in config file. Disables generated corners
# only_use_config_corners = False
# A list of PVT tuples and be given and only these will be characterized
# use_specified_corners = None
# Allows specification of model data
# sim_data_path = None
# A list of load/slew tuples
# use_specified_load_slew = None
# Spice simulation raw file
# spice_raw_file = None

###################
# Run-time vs accuracy options.
# Default, sacrifice accuracy/completeness for speed.
# Must turn on options for verification, final routing, etc.
###################
# When enabled, layout is not generated (and no DRC or LVS are performed)
netlist_only = False
# Whether we should do the final power routing
route_supplies = True
supply_pin_type = "ring"
# This determines whether LVS and DRC is checked at all.
check_lvsdrc = True
# This determines whether LVS and DRC is checked for every submodule.
# inline_lvsdrc = False
# Remove noncritical memory cells for characterization speed-up
trim_netlist = True
# Run with extracted parasitics
use_pex = False
# Output config with all options
output_extended_config = False
# Output temporary file used to format HTML page
output_datasheet_info = True
# Determines which analytical model to use.
# Available Models: elmore, linear_regression
model_name = "elmore"
# Write graph to a file
write_graph = True

num_threads = 12
num_sim_threads = 12

output_path = "build/reg_file"
output_name = "reg_file"

# Use analytical delay models by default
# rather than (slow) characterization
analytical_delay = True
# Purge the temp directory after a successful
# run (doesn't purge on errors, anyhow)

# Route the input/output pins to the perimeter
perimeter_pins = False

# Detailed or abstract LEF view
# detailed_lef = False

# keep_temp = False
