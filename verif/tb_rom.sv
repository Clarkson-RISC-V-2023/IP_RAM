`timescale 1ns/1ps
`define MEM_INIT_PATH ""

module tb_rom #(
    parameter INSTR_WIDTH 32,
    parameter INSTR_COUNT 10,
    parameter DEPTH INSTR_COUNT*INSTR_WIDTH/4
)(
    // EMPTY 
);

    reg clk;
    reg [$clog2(DEPTH)-1:0] addr;
    wire instr;

    dut_rom #(
        .INSTR_WIDTH(INSTR_WIDTH),
        .INSTR_COUNT(INSTR_COUNT),
        .DEPTH(DEPTH)
    ) rom (
        .clk(clk),
        .addr_i(addr),
        .rom_instr(instr)
    );

    always #10 clk= ~clk;

    initial begin
        $readmemh(`MEM_INIT_PATH, dut_rom.memb.bmem);
        $dumpfile("rom_tb.vcd");
        $dumpvars(0, tb_rom);
        clk = 1'b0;
        addr = {$clog2(DEPTH){1'b0}};
        #20 addr + 1'b1;
        #20 addr + 1'b1;
        #20 addr + 1'b1;
        #20 addr + 1'b1;
        #20 addr + 1'b1;
        #20 addr + 1'b1;
        #20 addr + 1'b1;
        #20 addr + 1'b1;
        #20 addr + 1'b1;
        #50 $finish;
    end
endmodule