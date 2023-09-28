.PHONY: all bmem rom ram

OUT_DIR = ./out/

all: bmem rom ram  

bmem:
	mkdir -p $(OUT_DIR)bmem/

	xvlog --sv -d MEM_INIT_PATH=\"./verif/init_mem/memblock_tb_init.hex\" verif/tb_memblock.sv rtl/memblock.sv
	xelab tb_memblock -debug typical
	xsim tb_memblock -R
	
	mv xsim.dir $(OUT_DIR)bmem/
	mv xvlog* xelab* xsim* *.wdb *.vcd $(OUT_DIR)bmem/

rom:
	mkdir -p $(OUT_DIR)rom/

	xvlog --sv -d ROM_INIT_PATH=\"./verif/init_mem/rom_tb_init.hex\" verif/tb_rom.sv rtl/rom.sv rtl/memblock.sv
	xelab tb_rom -debug typical
	xsim tb_rom -R
	
	mv xsim.dir $(OUT_DIR)rom/
	mv xvlog* xelab* xsim* *.wdb *.vcd $(OUT_DIR)rom/

ram:
	mkdir -p $(OUT_DIR)/ram/

	xvlog --sv verif/tb_ram.sv rtl/ram.sv rtl/memblock.sv
	xelab tb_ram -debug typical
	xsim tb_ram -R
	
	rm -rf $(OUT_DIR)/ram//xsim.dir
	mv xsim.dir $(OUT_DIR)/ram/
	mv xvlog* xelab* xsim* *.wdb *.vcd $(OUT_DIR)/ram/

clean:
	rm -rf $(OUT_DIR) xsim.dir 
	rm -rf *.pb *.log *.jou *.wdb *.vcd