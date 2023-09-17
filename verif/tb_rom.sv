`timescale 1ns/1ps
`define ROM_INIT_PATH ""

module tb_rom #(
    parameter INSTR_WIDTH = 32,
    parameter INSTR_COUNT = 10,
    parameter string MEM_INIT_PATH = `ROM_INIT_PATH
)(
    // EMPTY 
);

    localparam DEPTH = INSTR_COUNT*INSTR_WIDTH/4;

    reg clk;
    reg [$clog2(DEPTH)-1:0] addr;
    wire [INSTR_WIDTH-1:0] instr;

    rom #(
        .DATA_WIDTH(INSTR_WIDTH),
        .DEPTH(DEPTH)
    ) dut_rom (
        .clk(clk),
        .addr_i(addr),
        .rom_o(instr)
    );

    always #10 clk= ~clk;



    initial begin
        $readmemh(MEM_INIT_PATH, dut_rom.mem_inst.bmem);
        $dumpfile("rom_tb.vcd");
        $dumpvars(0, tb_rom);
        $display("ROM data loaded from %s", MEM_INIT_PATH);
        clk = 1'b0;
        addr = {$clog2(DEPTH){1'b0}};
        #20 addr = addr + 3'b100;
        #20 addr = addr + 3'b100;
        #20 addr = addr + 3'b100;
        #20 addr = addr + 3'b100;
        #20 addr = addr + 3'b100;
        #20 addr = addr + 3'b100;
        #20 addr = addr + 3'b100;
        #20 addr = addr + 3'b100;
        #20 addr = addr + 3'b100;
        // Now go down
        #20 addr = addr - 3'b100;
        #20 addr = addr - 3'b100;
        #20 addr = addr - 3'b100;
        #20 addr = addr - 3'b100;
        #20 addr = addr - 3'b100;
        #20 addr = addr - 3'b100;
        #20 addr = addr - 3'b100;
        #20 addr = addr - 3'b100;
        #20 addr = addr - 3'b100;
        #50 $finish;
    end
endmodule