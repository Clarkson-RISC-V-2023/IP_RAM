`timescale 1ns / 1ps
import ram_params::*;

module tb_ram;
    localparam ADDRESS_SPACE = DEPTH*NUM_OF_MEM_BLOCKS;

    // Signals
    reg clk;
    reg [$clog2(ADDRESS_SPACE)-1:0] addr_i;
    reg [DATA_WIDTH-1:0] wr_data_i;
    reg [NUM_OF_MEM_BLOCKS-1:0] mem_block_en_i;
    reg wr_en_i;
    wire [DATA_WIDTH-1:0] rd_data_o;

    // Instantiate the RAM module
    ram u_ram (
        .clk(clk),
        .addr_i(addr_i),
        .wr_data_i(wr_data_i),
        .mem_block_en_i(mem_block_en_i),
        .wr_en_i(wr_en_i),
        .rd_data_o(rd_data_o)
    );

    // Clock generator
    always begin
        #5 clk = ~clk;
    end

    // Test sequence
    initial begin
        $dumpfile("tb_ram.vcd");
        $dumpvars(0, tb_ram);
        clk = 0;
        wr_en_i = 0;
        mem_block_en_i = 4'b1111; // Enable all memory blocks

        // Write to the RAM

        for (addr_i = 0; addr_i < ADDRESS_SPACE; addr_i = addr_i + 4) begin
            wr_data_i = addr_i;
            wr_en_i = 1;
            #10; // Wait for a clock cycle
            wr_en_i = 0;
            #10; // Wait for a clock cycle
            if (addr_i == ADDRESS_SPACE-4) begin
                break;
            end
        end

        // Read from the RAM and check the data
        for (addr_i = 0; addr_i < ADDRESS_SPACE; addr_i = addr_i + 4) begin
            #10; // Wait for a clock cycle
            if (rd_data_o !== addr_i) begin
                $display("Data mismatch at address %d: expected %d, got %d", addr_i, addr_i, rd_data_o);
            end
            if (addr_i == ADDRESS_SPACE-4) begin
                $display("Test completed");
                break;
            end 
        end

        // Write to the RAM with offset

        for (addr_i = 1; addr_i < ADDRESS_SPACE; addr_i = addr_i + 4) begin
            wr_data_i = addr_i;
            wr_en_i = 1;
            #10; // Wait for a clock cycle
            wr_en_i = 0;
            #10; // Wait for a clock cycle
            if (addr_i == ADDRESS_SPACE-7) begin
                break;
            end
        end

        // Read from the RAM and check the data
        for (addr_i = 1; addr_i < ADDRESS_SPACE; addr_i = addr_i + 4) begin
            #10; // Wait for a clock cycle
            if (rd_data_o !== addr_i) begin
                $display("Data mismatch at address %d: expected %d, got %d", addr_i, addr_i, rd_data_o);
            end
            if (addr_i == ADDRESS_SPACE-7) begin
                $display("Test completed");
                $finish;
            end 
        end

        
    end
endmodule
