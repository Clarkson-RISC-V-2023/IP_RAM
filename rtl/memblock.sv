module memblock #(parameter DEPTH = 256, DATA_WIDTH = 8)(
    input wire clk,
    input wire wr_en_i,
    input wire [$clog2(DEPTH)-1:0] addr_i,
    input wire [DATA_WIDTH-1:0] wr_data_i,
    output logic [DATA_WIDTH-1:0] rd_data_o
);
    logic [DATA_WIDTH-1:0] bmem [DEPTH-1:0];

    always_ff @(posedge clk) begin
        if(wr_en_i)
            bmem[addr_i] <= wr_data_i;
    end

    always_ff @(negedge clk) begin
        if(!wr_en_i)
            rd_data_o <= bmem[addr_i];
        else 
            rd_data_o <= rd_data_o;
    end
endmodule
