TARGET=soc

all: ${TARGET}.bit

$(TARGET)-yosys.json: rom.mem
	yosys yosys.ys

$(TARGET)_out.config: $(TARGET)-yosys.json
	nextpnr-ecp5 --25k --package CABGA256 --speed 6 --json $< --textcfg $@ --lpf constr.lpf --freq 65

$(TARGET).bit: $(TARGET)_out.config
	ecppack --svf ${TARGET}.svf $< $@

${TARGET}.svf : ${TARGET}.bit

rom.mem:
	cp ../../tests/gcc/build/wb_fpga_test.mem rom.mem

# prog: ${TARGET}.svf
# 	openFPGALoader -c digilent_hs2 $(TARGET).bit

clean:
	rm -f *.svf *.bit *.config *.json *.svg *.dot *.mem

.PHONY: prog clean
