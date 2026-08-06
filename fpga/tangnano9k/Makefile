# project name (no comments behind assignment lines because spaces are added!)
PROJ = soc
# constraints file (same as projectname)
PIN_DEF = constr.cst
DEVICE = GW1NR-LV9QN88PC6/I5
DEVICE_FAMILY = GW1N-9C

#     SOURCE = $(PROJ).v

BOARD = tangnano9k

TARGET ?= SRAM

$(info PROJ = $(PROJ))           # Print variables for debugging

all: $(PROJ).fs                  # final bitstream file

$(PROJ)-yosys.json: $(SOURCE)    # synthesizes Verilog-source to JSON using Yosys
	yosys yosys.ys
$(info Building $(PROJ)-yosys.json)
$(PROJ)-nextpnr.json: $(PIN_DEF) $(PROJ)-yosys.json
	nextpnr-himbaechel --json $(PROJ)-yosys.json --write $@ --device $(DEVICE) --vopt family=$(DEVICE_FAMILY) --vopt cst=$(PIN_DEF)

$(PROJ).fs: $(PROJ)-nextpnr.json
	gowin_pack -d $(DEVICE_FAMILY) -o $@ $(PROJ)-nextpnr.json

prog: $(PROJ).fs                 # load bitstream fs-file to SRAM or FLASH

ifeq ($(TARGET),FLASH)
	openFPGALoader -f --freq 2000000 -b $(BOARD) $(PROJ).fs
else
	openFPGALoader -m --freq 2000000 -b $(BOARD) $(PROJ).fs
endif

clean:                           # clean the files that are needed no more
	rm -f *.json *.fs

.PHONY: all prog clean
# EOF