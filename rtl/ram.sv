import ram_params::*;
 
module ram (
    input wire clk,
    input wire [$clog2(ADDRESS_SPACE)-1:0]addr_i,
    input wire [DATA_WIDTH-1:0] wr_data_i,
    input wire [NUM_OF_MEM_BLOCKS-1:0] mem_block_en_i, // Signal to specify which blocks are active
    input wire wr_en_i,

    output reg [DATA_WIDTH-1:0] rd_data_o
);
    localparam BANK_WIDTH = 8; // Default 8 (1 byte)

    reg [$clog2(ADDRESS_SPACE)-1:0] bank_addr [NUM_OF_MEM_BLOCKS-1:0];

    genvar bank_num;
    generate
        for (bank_num = 0; bank_num < NUM_OF_MEM_BLOCKS;bank_num=bank_num+1) begin : mem_block_loop
            localparam [$clog2(NUM_OF_MEM_BLOCKS)-1:0] bank_num_bin = bank_num;
            assign bank_addr[bank_num] =  addr_i;
            memblock #(
                .DEPTH(DEPTH),
                .DATA_WIDTH(BANK_WIDTH)
            ) mem_bank (
                .clk(clk),
                .wr_en_i(wr_en_i & mem_block_en_i[bank_num]),
                .addr_i(bank_addr[bank_num][$clog2(ADDRESS_SPACE)-1:$clog2(NUM_OF_MEM_BLOCKS)]),
                .wr_data_i(wr_data_i[bank_num*BANK_WIDTH+:BANK_WIDTH]),
                .rd_data_o(rd_data_o[bank_num*BANK_WIDTH+:BANK_WIDTH])
            );
        end
    endgenerate
endmodule