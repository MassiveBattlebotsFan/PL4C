
.SUFFIXES: .run

SRC := src
BIN := bin
WAVE := $(BIN)/wave
WORK := $(BIN)/work
SYNTH := $(BIN)/synth
VHDL := $(SRC)/vhdl
VHDL_TB := $(SRC)/vhdl_tb
GHDL_FLAGS := --std=08 --workdir=$(WORK)
SYNTH_FLAGS := --std=08 --workdir=$(SYNTH)


testbenches := reg_tb


all: bin import $(testbenches)

import:	| work
	ghdl -i $(GHDL_FLAGS) $(VHDL)/*.vhdl $(VHDL_TB)/*.vhdl

run: import wave $(foreach trg,$(testbenches),$(trg).run)


#syn: synthesis

#synthesis: synth $(foreach trg,$(wildcard $(VHDL)/*.vhdl $(VHDL_TB)/*.vhdl),$(basename $(trg)).synth)

%_tb.run: | work wave
	ghdl -m -o $(BIN)/$(basename $(notdir $@)) $(GHDL_FLAGS) $(basename $(notdir $@))
	$(BIN)/$(basename $(notdir $@)).exe --wave=$(WAVE)/$(basename $(notdir $@)).ghw

%_tb:
	ghdl -m -o $(BIN)/$@ $(GHDL_FLAGS) $@

work:
	mkdir -p $(WORK)

bin:
	mkdir -p $(BIN)

wave:
	mkdir -p $(WAVE)

synth:
	mkdir -p $(SYNTH)

clean:
	rm -f $(WORK)/*.o $(WORK)/*.cf
	rm -f $(WAVE)/*.ghw
	rm -f $(SYNTH)/*.o $(SYNTH)/*.cf
	rm -f $(BIN)/*.exe $(BIN)/*.o
	rm -f $(BIN)/*.syn-vhdl
	rm -fd $(WORK)	
	rm -fd $(WAVE)
	rm -fd $(SYNTH)
	rm -fd $(BIN)
