#rm -rf work
#vlib work
#vlog +cover -l compile.log -sv proj.svh top.sv
#vsim -c -l run.log work.top "+UVM_TESTNAME=test_full" -sv_lib /tools/questa-/10.3e/questasim/uvm-1.1d/linux/uvm_dpi +acc 

UVM_VERBOSITY ?= UVM_MEDIUM
WLF2VCD=wlf2vcd -o dump.vcd vsim.wlf
TESTNAME ?=test1 
TOPFILE ?=top.sv
RUN_LOGFILE ?=run.log
COMPILE_LOGFILE ?=compile.log
#USER_FILELIST ?=pkg_8b9b.sv
SIMULATOR ?= QUESTA
VLIB =  vlib work
TRUECHIP_DPI=/tools/questa-/10.3e/questasim/uvm-1.1d/linux/uvm_dpi +acc 

DUMP ?=0
COVER ?=0
SIM_DUMP = 
ifeq ($(DUMP),1)
override SIM_DUMP = add log -r /*
endif

VLOG =  vlog \
        -sv \
	+cover \
        -writetoplevels questa.tops \



VSIM =  vsim \
        -f questa.tops \
        +UVM_VERBOSITY=$(UVM_VERBOSITY) \
	+UVM_TESTNAME=$(TESTNAME) \
	-l $(RUN_LOGFILE) \
        -do "coverage save -onexit name.ucdb;vcover report -html name.ucdb -htmldir  name_dir;run -all;quit" \
	-c \

vlib:
	$(VLIB)

comp: 
	$(VLOG) \
	$(TOPFILE)\

run: 
	$(VSIM)  -sv_lib $(TRUECHIP_DPI)

all:	vlib comp run   



#vlog +cover
#vsim -do "coverage save -onexit   <name>.ucdb"
#vcover report -html name.ucdb -htmldir  name_cov_dir

