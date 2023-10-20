import ram_params::*;
 
module ram (
    input wire clk,
    input wire wr_en_i,
    input wire [$clog2(DEPTH)-1:0] addr_i,
    input wire [31:0] wdata_i,
    input wire [3:0] mem_block_en_i, // 4-bit wide signal to enable writing to each memblock
    output logic [31:0] rdata_o
);

    wire [7:0] wdata_memblock[3:0];
    wire [7:0] rdata_memblock[3:0];

    // Splitting 32-bit data into 4 8-bit data to feed into each memblock
    assign wdata_memblock[0] = wdata_i[7:0];
    assign wdata_memblock[1] = wdata_i[15:8];
    assign wdata_memblock[2] = wdata_i[23:16];
    assign wdata_memblock[3] = wdata_i[31:24];

    genvar i;
    generate
        for (i=0; i<4; i=i+1) begin : memblock_gen
            memblock #(
                .DEPTH(DEPTH),
                .DATA_WIDTH(8)
            ) u_memblock (
                .clk(clk),
                .wr_en_i(wr_en_i & mem_block_en_i[i]), // Enable write when mem_block_en_i bit is high
                .addr_i(addr_i), // Directly assigning the incoming address
                .wdata_i(wdata_memblock[i]),
                .rdata_o(rdata_memblock[i])
            );
        end
    endgenerate

    // Combining the 8-bit outputs from each memblock into a 32-bit output
    assign rdata_o = {rdata_memblock[3], rdata_memblock[2], rdata_memblock[1], rdata_memblock[0]};

endmodule