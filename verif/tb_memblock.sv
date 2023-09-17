`timescale 1ns/1ps
`define MEM_INIT_PATH ""

module tb_memblock #(
    parameter DEPTH = 10,
    parameter DATA_WIDTH = 8,
    parameter string MEM_INIT_PATH = `MEM_INIT_PATH
)(
    // EMPTY No_Ports
);

    reg clk;
    reg wr_en;
    reg [$clog2(DEPTH)-1:0] addr;
    reg [DATA_WIDTH-1:0] wr_data;
    wire [DATA_WIDTH-1:0] rd_data;

    memblock #(
        .DEPTH(DEPTH),
        .DATA_WIDTH(DATA_WIDTH),
        .MEM_INIT_PATH("")
    ) dut_bmem (
        .clk(clk),
        .wr_en_i(wr_en),
        .addr_i(addr),
        .wr_data_i(wr_data),
        .rd_data_o(rd_data)
    );

    initial begin
        $display("%s", MEM_INIT_PATH);
        $readmemh(MEM_INIT_PATH, dut_bmem.bmem);
        $dumpfile("memblock_tb.vcd");
        $dumpvars(0, tb_memblock);

        // Set read mode and address to 0
        clk = 0;
        wr_en = 0;
        wr_data = {DATA_WIDTH{1'b1}};
        addr = {$clog2(DEPTH){1'b0}};
        // Read all the preloaded values
        #20 addr = addr + 1'b1;
        #20 addr = addr + 1'b1;
        #20 addr = addr + 1'b1;
        #20 addr = addr + 1'b1;
        #20 addr = addr + 1'b1;
        #20 addr = addr + 1'b1;
        #20 addr = addr + 1'b1;
        #20 addr = addr + 1'b1;
        #20 addr = addr + 1'b1;
        #20 addr = addr + 1'b1;

        // Reset address to zero
        addr = {$clog2(DEPTH){1'b0}};
        #20

        // Write 4 new values
        wr_en = 1;
        #20 addr = addr + 1'b1;
        wr_data = {DATA_WIDTH{1'b0}};
        #20 addr = addr + 1'b1;
        wr_data = wr_data + 1'b1;
        #20 addr = addr + 1'b1;
        wr_data = wr_data + 1'b1;

        #20 wr_en = 1'b0;
        addr = {$clog2(DEPTH){1'b0}};

        // Read those 4 new values back
        #20 addr = addr + 1'b1;
        #20 addr = addr + 1'b1;
        #20 addr = addr + 1'b1;
        #20 addr = addr + 1'b1;
        #20 addr = addr + 1'b1;
        #20 addr = addr + 1'b1;
        #20 addr = addr + 1'b1;
        #20 addr = addr + 1'b1;
        #20 addr = addr + 1'b1;
        #40 $finish;

    end

    always #10 clk= ~clk;

endmodule
