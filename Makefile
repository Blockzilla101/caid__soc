# MAKEFILE_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

ONE_OFF_TAG = dev

RUN_TAG = $(shell ls librelane/runs/ | tail -n 1)
TOP = asic_top

PDK ?= ihp-sg13g2
PDK_COMMIT ?= 3b5a704ba6738aa686b08706187830e6284d2a10
PDK_ROOT ?= ~/.ciel

.DEFAULT_GOAL := help

$(PDK_ROOT)/$(PDK):
	ciel enable $(PDK_COMMIT) --pdk-family $(PDK) --pdk-root $(PDK_ROOT)

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
.PHONY: help

clone-pdk: $(PDK_ROOT)/$(PDK) ## Clone the IHP-Open-PDK repository
.PHONY: clone-pdk

all: librelane ## Build the project (runs LibreLane)
.PHONY: all

copy-rom: build-gcc
	cp tests/gcc/build/wb_fpga_test.mem rom.mem
.PHONY: copy-rom

build-gcc:
	(cd tests/gcc ; bash build.sh)
.PHONY: build-gcc

librelane: rom.mem $(PDK_ROOT)/$(PDK) ## Run LibreLane
	librelane librelane/config.yaml --pdk ${PDK} --pdk-root ${PDK_ROOT} --manual-pdk --save-views-to final/
.PHONY: librelane

librelane-nodrc: rom.mem $(PDK_ROOT)/$(PDK) ## Run LibreLane without DRC checks
	librelane librelane/config.yaml --pdk ${PDK} --pdk-root ${PDK_ROOT} --manual-pdk --save-views-to final/ --skip KLayout.DRC --skip Magic.DRC --skip KLayout.Antenna --skip KLayout.Density
.PHONY: librelane-nodrc

librelane-magicdrc: rom.mem $(PDK_ROOT)/$(PDK) ## Run LibreLane with only Magic DRC checks
	librelane librelane/config.yaml --pdk ${PDK} --pdk-root ${PDK_ROOT} --manual-pdk --save-views-to final/ --skip KLayout.DRC
.PHONY: librelane-magicdrc

librelane-klayoutdrc: rom.mem $(PDK_ROOT)/$(PDK) ## Run LibreLane with only KLayout DRC checks
	librelane librelane/config.yaml --pdk ${PDK} --pdk-root ${PDK_ROOT} --manual-pdk --save-views-to final/ --skip Magic.DRC
.PHONY: librelane-nodrc

librelane-openroad: rom.mem $(PDK_ROOT)/$(PDK) ## Open the last LibreLane run in OpenROAD GUI
	librelane librelane/config.yaml --pdk ${PDK} --pdk-root ${PDK_ROOT} --manual-pdk --last-run --flow OpenInOpenROAD
.PHONY: librelane-openroad

librelane-klayout: rom.mem $(PDK_ROOT)/$(PDK) ## Open the last LibreLane run in KLayout
	librelane librelane/config.yaml --pdk ${PDK} --pdk-root ${PDK_ROOT} --manual-pdk --last-run --flow OpenInKLayout
.PHONY: librelane-klayout

librelane-to-pdn: rom.mem $(PDK_ROOT)/$(PDK) ## Run till floorplan 
	librelane librelane/config.yaml --pdk ${PDK} --pdk-root ${PDK_ROOT} --manual-pdk --to OpenROAD.GeneratePDN --overwrite --run-tag $(ONE_OFF_TAG)
.PHONY: librelane-to-pdn

librelane-to-staprepnr: rom.mem $(PDK_ROOT)/$(PDK) ## Run till floorplan 
	librelane librelane/config.yaml --pdk ${PDK} --pdk-root ${PDK_ROOT} --manual-pdk --to OpenROAD.STAPrePNR --overwrite --run-tag $(ONE_OFF_TAG)
.PHONY: librelane-to-staprepnr

librelane-to-stapostpnr: rom.mem $(PDK_ROOT)/$(PDK) ## Run till STA Post PNR
	librelane librelane/config.yaml --pdk ${PDK} --pdk-root ${PDK_ROOT} --manual-pdk --to OpenROAD.STAPostPNR --overwrite --run-tag $(ONE_OFF_TAG)
.PHONY: librelane-to-stapostpnr

librelane-open-pdn: rom.mem $(PDK_ROOT)/$(PDK) ## Open pdn in openroad
	openroad -gui -db librelane/runs/$(ONE_OFF_TAG)/22-openroad-generatepdn/$(TOP).odb
.PHONY: librelane-open-pdn

clean:
	rm -rf librelane/runs
	rm -rf final
	rm -rf tests/gcc/build
	rm rom.mem
.PHONY: clean

# sim: ## Run RTL simulation with cocotb
# 	cd cocotb; PDK_ROOT=${PDK_ROOT} PDK=${PDK} python3 chip_top_tb.py
# .PHONY: sim

# sim-gl: $(PDK_ROOT)/$(PDK) ## Run gate-level simulation with cocotb
# 	cd cocotb; GL=1 PDK_ROOT=${PDK_ROOT} PDK=${PDK} python3 chip_top_tb.py
# .PHONY: sim-gl

# sim-view: ## View simulation waveforms in GTKWave
# 	gtkwave cocotb/sim_build/chip_top.fst
# .PHONY: sim-view