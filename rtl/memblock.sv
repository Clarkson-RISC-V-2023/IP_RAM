module memblock #(
    parameter DEPTH = 256, 
    parameter DATA_WIDTH = 8,
    parameter string MEM_INIT_PATH = ""
    )(
    input wire clk,
    input wire wr_en_i,
    input wire [$clog2(DEPTH)-1:0] addr_i,
    input wire [DATA_WIDTH-1:0] wdata_i,
    output logic [DATA_WIDTH-1:0] rdata_o
);
    reg [DATA_WIDTH-1:0] bmem [DEPTH-1:0];

  
    initial begin
        if(MEM_INIT_PATH != "") begin
            $readmemb(MEM_INIT_PATH, bmem);
        end else begin
            integer i;
            for(i = 0;i < DEPTH;i = i + 1) bmem[i] = '0;
        end
    end
    
    always_ff @(negedge clk) begin
        if(wr_en_i)
            bmem[addr_i] <= wdata_i;
    end
    assign rdata_o = bmem[addr_i];

endmodule
