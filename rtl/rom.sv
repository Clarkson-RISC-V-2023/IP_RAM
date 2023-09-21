`timescale 1ns/1ps

module rom #(
    parameter DEPTH = 256, 
    parameter DATA_WIDTH = 32,
    parameter string MEM_INIT_PATH = ""
    )(
    input wire clk,
    input wire [$clog2(DEPTH)-1:0] addr_i,
    output logic [DATA_WIDTH-1:0] rom_o
);
    memblock #(
        .DEPTH(DEPTH),
        .DATA_WIDTH(DATA_WIDTH),
        .MEM_INIT_PATH(MEM_INIT_PATH)
    ) mem_inst (
        .clk(clk),
        .wr_en_i(1'b0), // Write enable is always low for ROM
        .addr_i(addr_i >> 2), // Right shift address by 2 to increment by 4
        .wr_data_i({DEPTH{1'b0}}), // Write data is don't care for ROM
        .rd_data_o(rom_o)
    );
endmodule
