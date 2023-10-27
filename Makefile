.PHONY: all bmem rom ram uvm_ram

IP 				= ram
FILE_LIST 		= ./files.f
UVM_FILE_LIST	= ./files_uvm.f
XVLOG_FLAGS 	= -sv -f $(FILE_LIST)
UVM_XVLOG_FLAGS	= -sv -L uvm -f $(UVM_FILE_LIST)
XELAB_FLAGS 	= -top tb_$(IP)
XSIM_FLAGS 		= -R tb_$(IP)
OUT_DIR 		= ./out

all: clean bmem rom ram uvm_ram 

build: 
	mkdir -p $(OUT_DIR)
	xvlog $(XVLOG_FLAGS) 
	xelab $(XELAB_FLAGS)
	xsim $(XSIM_FLAGS)
	rm -rf $(OUT_DIR)/*
	mv xvlog* xelab* xsim** $(OUT_DIR)
	mv *.log $(OUT_DIR) || true
	mv *.wdb $(OUT_DIR) || true
	mv *.vcd $(OUT_DIR) || true

bmem:
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	# BUILDING tb BMEM:
	make build IP=memblock OUT_DIR=$(OUT_DIR)/tb/bmem

rom:
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	# BUILDING tb ROM:
	make build IP=rom OUT_DIR=$(OUT_DIR)/tb/rom

ram:
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	# BUILDING tb RAM:
	make build IP=ram OUT_DIR=$(OUT_DIR)/tb/ram

uvm_ram:
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	# BUILDING UVM RAM:
	make build IP=uvm_ram OUT_DIR=$(OUT_DIR)/uvm/ram  XVLOG_FLAGS="$(UVM_XVLOG_FLAGS)"

program:
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	# Programming Board over Serial
	python3 ./ROM_Programmer/rpp ./ROM_Programmer/tmp.txt -c COM3 -b 115200

clean:
	rm -rf xvlog* xelab* xsim* *.wdb *.log *.vcd out