.PHONY: all bmem rom ram

OUT_DIR = ./out/

all: bmem rom ram  

bmem:
	mkdir -p $(OUT_DIR)

	xvlog --sv -d MEM_INIT_PATH=\"./verif/init_mem/memblock_tb_init.hex\" verif/tb_memblock.sv rtl/memblock.sv
	xelab tb_memblock -debug typical
	xsim tb_memblock -R
	
	mv xsim.dir $(OUT_DIR)
	mv xvlog* xelab* xsim* *.wdb *.vcd $(OUT_DIR)

rom:
	mkdir -p $(OUT_DIR)

	xvlog --sv -d ROM_INIT_PATH=\"./verif/init_mem/rom_tb_init.hex\" verif/tb_rom.sv rtl/rom.sv rtl/memblock.sv
	xelab tb_rom -debug typical
	xsim tb_rom -R
	
	mv xsim.dir $(OUT_DIR)
	mv xvlog* xelab* xsim* *.wdb *.vcd $(OUT_DIR)

ram:
	mkdir -p $(OUT_DIR)

	xvlog --sv verif/tb_ram.sv rtl/ram.sv rtl/memblock.sv
	xelab tb_ram -debug typical
	xsim tb_ram -R
	
	mv xsim.dir $(OUT_DIR)
	mv xvlog* xelab* xsim* *.wdb *.vcd $(OUT_DIR)

clean:
	rm -rf $(OUT_DIR) xsim.dir 
	rm -rf *.pb *.log *.jou *.wdb *.vcd