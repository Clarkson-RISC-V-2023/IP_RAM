//import ram_params::*;
 
module ram #(
    parameter  DATA_WIDTH = 32, // Must be multiple of 8 or BANK_WIDTH
    parameter  DEPTH = 1024,
    parameter  NUM_OF_MEM_BLOCKS = 4, // DATA_WIDTH/8 or DATA_WIDTH/BANK_WIDTH
    parameter  ADDRESS_SPACE = 4096 // <= DEPTH * NUM_OF_MEM_BLOCKS
)(
    input wire clk,
    input wire [$clog2(ADDRESS_SPACE)-1:0]addr_i,
    input wire [DATA_WIDTH-1:0] wdata_i,
    input wire [NUM_OF_MEM_BLOCKS-1:0] mem_block_en_i, // Signal to specify which blocks are active
    input wire wr_en_i,

    output reg [DATA_WIDTH-1:0] rdata_o
);
    localparam BANK_WIDTH = 8; // Default 8 (1 byte)

    reg [$clog2(ADDRESS_SPACE)-1:0] bank_addr [NUM_OF_MEM_BLOCKS-1:0];

    generate
        genvar bank_num;  
        for (bank_num = 0; bank_num < NUM_OF_MEM_BLOCKS;bank_num=bank_num+1) begin : mem_block_loop
            localparam [$clog2(NUM_OF_MEM_BLOCKS)-1:0] bank_num_bin = bank_num;
            assign bank_addr[bank_num] = addr_i+bank_num_bin;
            memblock #(
                .DEPTH(DEPTH),
                .DATA_WIDTH(BANK_WIDTH)
            ) mem_bank (
                .clk(clk),
                .wr_en_i(wr_en_i & mem_block_en_i[bank_num]),
                .addr_i(bank_addr[bank_num][$clog2(ADDRESS_SPACE)-1:$clog2(NUM_OF_MEM_BLOCKS)]),
                .wdata_i(wdata_i[bank_num*BANK_WIDTH+:BANK_WIDTH]),
                .rdata_o(rdata_o[bank_num*BANK_WIDTH+:BANK_WIDTH])
            );
        end
    endgenerate
endmodule