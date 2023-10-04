`include "uvm_macros.svh"
import uvm_pkg::*;

import ram_params::*;

interface ram_if (input bit clk);
    logic   [$clog2(ADDRESS_SPACE)-1:0]addr;
    logic   [DATA_WIDTH-1:0] wdata;
    logic   [NUM_OF_MEM_BLOCKS-1:0] mem_block_en;
    logic   wr_en;
    logic   [DATA_WIDTH-1:0] rdata;
endinterface