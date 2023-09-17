module rom (
    parameter INSTR_WIDTH 32,
    parameter INSTR_COUNT 256,
    parameter DEPTH INSTR_COUNT*INSTR_WIDTH/4        
    )(
        input wire clk,
        input wire [$clog2(DEPTH)-1:0] addr_i,
        output [INSTR_WIDTH-1:0] rom_instr
    );

    memb #(
        .DEPTH(DEPTH),
        .DATA_WIDTH(8)
    ) memblock (
        .clk(clk),
        .wr_en_i(1'b0), // ROM read only
        .addr_i(addr_i),
        .wr_data_i(8'b00000000);
        .rd_data_o(rom_instr)
    );
    
endmodule;