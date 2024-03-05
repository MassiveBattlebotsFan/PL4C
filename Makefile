
.SUFFIXES: .run

SRC := src
BIN := bin
WAVE := $(BIN)/wave
WORK := $(BIN)/work
VHDL := $(SRC)/vhdl
VHDL_TB := $(SRC)/vhdl_tb
GHDL_FLAGS := --std=08 --workdir=$(WORK)


testbenches := reg_tb


all: bin import $(testbenches)

import:	work
	ghdl -i $(GHDL_FLAGS) $(VHDL)/*.vhdl
	ghdl -i $(GHDL_FLAGS) $(VHDL_TB)/*.vhdl

run: import wave $(foreach trg,$(testbenches),$(trg).run)


%_tb.run: %_tb wave
	$(BIN)/$<.exe --wave=$(WAVE)/$<.ghw

%_tb:
	ghdl -m -o $(BIN)/$@ $(GHDL_FLAGS) $@

work:
	mkdir -p $(WORK)

bin:
	mkdir -p $(BIN)

wave:
	mkdir -p $(WAVE)


clean:
	rm -f $(WORK)/*.o $(WORK)/*.cf
	rm -f $(WAVE)/*.ghw
	rm -f $(BIN)/*.exe $(BIN)/*.o
	
	rm -fd $(WORK)	
	rm -fd $(WAVE)
	rm -fd $(BIN)
