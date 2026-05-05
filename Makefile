IVERILOG ?= iverilog
VVP      ?= vvp

BUILD    := build

.PHONY: all test test-regfile clean

all: test

test: test-regfile

test-regfile: $(BUILD)/tb_regfile
	$(VVP) $<

$(BUILD)/tb_regfile: sim/tb_regfile.sv rtl/regfile.sv | $(BUILD)
	$(IVERILOG) -g2012 -o $@ $^

$(BUILD):
	mkdir -p $@

clean:
	rm -rf $(BUILD)
