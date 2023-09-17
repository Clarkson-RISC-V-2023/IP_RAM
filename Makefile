.PHONY: all bmem_sim

rom_sim: init rom end
bmem_sim: init bmem end 

init:
	mkdir -p out/

end:
	rm *.pb *.log *.jou || true
	tree

bmem:
	mkdir -p out/bmem/iverilog/
	# iverilog disabled for this process
	# mkdir -p out/bmem/xilinx/

	xvlog --sv -d MEM_INIT_PATH=\"./verif/init_mem/memblock_tb_init.hex\" verif/tb_memblock.sv rtl/memblock.sv
	xelab tb_memblock -debug typical
	xsim tb_memblock -R
	
	mv xsim.dir out/bmem/xilinx
	mv *.wdb *.vcd out/bmem/xilinx

	# iverilog -g2005-sv -D MEM_INIT_PATH=\"./verif/init_mem/memblock_tb_init.hex\" -o out/bmem/iverilog/bmem_sim -s tb_memblock verif/tb_memblock.sv rtl/memblock.sv
	# vvp out/bmem/iverilog/bmem_sim
	# mv memblock_tb.vcd out/bmem/iverilog/

clean:
	rm -rf out/ xsim.dir || true
	rm *.pb *.log *.jou *.wdb *.vcd || true