.PHONY: all bmem_sim rom_sim 

all: init bmem rom ram end 
rom_sim: init rom end
bmem_sim: init bmem end 
ram_sim: init ram end

init:
	mkdir -p out/

end:
	rm *.pb *.log *.jou || true
	tree

bmem:
	# mkdir -p out/bmem/iverilog/
	# iverilog disabled for this process
	mkdir -p out/bmem/xilinx/ || true

	xvlog --sv -d MEM_INIT_PATH=\"./verif/init_mem/memblock_tb_init.hex\" verif/tb_memblock.sv rtl/memblock.sv
	xelab tb_memblock -debug typical
	xsim tb_memblock -R
	
	mv xsim.dir out/bmem/xilinx
	mv *.wdb *.vcd out/bmem/xilinx

	# iverilog -g2005-sv -D MEM_INIT_PATH=\"./verif/init_mem/memblock_tb_init.hex\" -o out/bmem/iverilog/bmem_sim -s tb_memblock verif/tb_memblock.sv rtl/memblock.sv
	# vvp out/bmem/iverilog/bmem_sim
	# mv memblock_tb.vcd out/bmem/iverilog/

rom:
	# mkdir -p out/rom/iverilog/ 
	mkdir -p out/rom/xilinx/ || true

	xvlog --sv -d ROM_INIT_PATH=\"./verif/init_mem/rom_tb_init.hex\" verif/tb_rom.sv rtl/rom.sv rtl/memblock.sv
	xelab tb_rom -debug typical
	xsim tb_rom -R
	
	mv xsim.dir out/rom/xilinx
	mv *.wdb *.vcd out/rom/xilinx

	# iverilog -g2005-sv -D MEM_INIT_PATH=\"./verif/init_mem/memblock_tb_init.hex\" -o out/rom/iverilog/rom_sim -s tb_memblock verif/tb_memblock.sv rtl/memblock.sv
	# vvp out/rom/iverilog/rom_sim
	# mv memblock_tb.vcd out/rom/iverilog/

ram:
	mkdir -p out/ram/iverilog/ 
	mkdir -p out/ram/xilinx/ || true

	xvlog --sv verif/tb_ram.sv rtl/ram.sv rtl/memblock.sv
	xelab tb_ram -debug typical
	xsim tb_ram -R
	
	rm -rf out/ram/xilinx/xsim.dir || true
	mv xsim.dir out/ram/xilinx
	mv *.wdb *.vcd out/ram/xilinx

	# iverilog -g2005-sv -o out/ram/iverilog/ram_sim -s tb_ram verif/tb_ram.sv rtl/ram.sv rtl/memblock.sv
	# vvp out/ram/iverilog/ram_sim
	# mv *.vcd out/ram/iverilog/

clean:
	rm -rf out/ xsim.dir || true
	rm *.pb *.log *.jou *.wdb *.vcd || true