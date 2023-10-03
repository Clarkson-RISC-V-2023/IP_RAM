module memblock #(
    parameter DEPTH = 256, 
    parameter DATA_WIDTH = 8,
    parameter string MEM_INIT_PATH = ""
    )(
    input wire clk,
    input wire wr_en_i,
    input wire [$clog2(DEPTH)-1:0] addr_i,
    input wire [DATA_WIDTH-1:0] wr_data_i,
    output logic [DATA_WIDTH-1:0] rd_data_o
);
    reg [DATA_WIDTH-1:0] bmem [DEPTH-1:0];

    integer i;
    initial begin
        if(MEM_INIT_PATH != "") begin
            $readmemb(MEM_INIT_PATH, bmem);
        end else begin
            for(i = 0;i < DEPTH;i = i + 1) bmem[i] = '0;
        end
    end
    
    always_ff @(posedge clk) begin
        if(wr_en_i) begin
            bmem[addr_i] <= wr_data_i;
            rd_data_o <= wr_data_i;
        end else begin
            rd_data_o <= bmem[addr_i];
        end
    end

endmodule
