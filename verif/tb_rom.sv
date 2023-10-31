`define ROM_INIT_PATH "./verif/init_mem/rom_tb_init.hex"
`timescale 1ns/1ps  
module tb_rom #(
    parameter INSTR_WIDTH = 32,
    parameter INSTR_COUNT = 10,
    parameter string MEM_INIT_PATH = `ROM_INIT_PATH,
    parameter BUAD_FACTOR = 217
)(
    // EMPTY 
);

    localparam DEPTH = INSTR_COUNT*INSTR_WIDTH/4;

    reg clk;
    reg [$clog2(DEPTH)-1:0] addr;
    wire [INSTR_WIDTH-1:0] instr;
    reg prog;
    reg serial;
    reg programming_mode;

    rom #(
        .DATA_WIDTH(INSTR_WIDTH),
        .DEPTH(DEPTH),
        .BUAD_FACTOR(BUAD_FACTOR)
    ) dut_rom (
        .clk(clk),
        .addr_i(addr),
        .rom_o(instr),

        // New Programing Facilities
        .prog_i(prog),
        .serial_i(serial),
        .programming_mode(programming_mode)
    );

    always #20 clk= ~clk;

    task send_uart(input [7:0] byte_input);
        begin
            serial = '0;
            #8600;
            #1000
            for(int i = 0; i < 8; i=i+1) begin
                serial = byte_input[i];
                #8600;
            end
            serial = '1;
            #8600;
        end
    endtask

    task sent_instr(input [31:0] instr);
        begin
            send_uart(instr[24+:8]);
            #10000;
            send_uart(instr[16+:8]);
            #10000;
            send_uart(instr[8+:8]);
            #10000;
            send_uart(instr[0+:8]);
            #10000;
        end
    endtask


    initial begin
        // $readmemh(MEM_INIT_PATH, dut_rom.mem_inst.bmem);   
        $dumpfile("rom_tb.vcd");
        $dumpvars(0, tb_rom);
        // $display("ROM data loaded from %s", MEM_INIT_PATH);
        clk = 1'b0;
        serial = '1;
        prog = '0;
        addr = '0;

        #100
        prog = '1;
        #100
        sent_instr(32'h10ABCDEF);
        #100
        sent_instr(32'h12345678);
        #100
        sent_instr(32'hABCDEFAB);
        #100
        prog = '0;

        // Reading Back Data
        #1000 addr = addr + 3'b100;
        #1000 addr = addr + 3'b100;
        #1000 addr = addr + 3'b100;
        #1000 $finish;
    end
endmodule