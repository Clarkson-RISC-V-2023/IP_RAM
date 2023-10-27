`timescale 1ns/1ps  
module rom #(
    parameter DEPTH = 256, 
    parameter DATA_WIDTH = 32,
    parameter string MEM_INIT_PATH = "",
    parameter BUAD_FACTOR = 217,
    parameter NUM_BYTES = 4
    )(
    input wire clk,
    input wire [$clog2(DEPTH)-1:0] addr_i,
    output logic [DATA_WIDTH-1:0] rom_o,

    // Programming Inputs
    input wire prog_i,
    input wire serial_i
);
    // Internal UART Signal
    wire data_valid;
    wire [7:0] byte_recieved;
    reg prog_we;
    reg [$clog2(DEPTH)-1:0] prog_addr, prog_addr_reg;
    reg [DATA_WIDTH-1:0] prog_write_data;
    reg prog_reg;

    // UART Receiver
    uart_rx #(
        .CLKS_PER_BIT(BUAD_FACTOR)
    ) uart_inst (
        .i_Clock(clk),
        .i_Rx_Serial(serial_i),
        .o_Rx_DV(data_valid),
        .o_Rx_Byte(byte_recieved)
    );

    // Internal Memblock Signals
    reg [$clog2(DEPTH)-1:0] internal_address;
    reg internal_we;
    reg [DATA_WIDTH-1:0] internal_write_data;
    reg [$clog2(DEPTH)-1:0] num_bytes_written;

    // Memblock Storage
    memblock #(
        .DEPTH(DEPTH),
        .DATA_WIDTH(DATA_WIDTH),
        .MEM_INIT_PATH(MEM_INIT_PATH)
    ) mem_inst (
        .clk(clk),
        .wr_en_i(internal_we), // Write enable is always low for ROM
        .addr_i(internal_address), // Right shift address by 2 to increment by 4
        .wdata_i(internal_write_data), // Write data is don't care for ROM
        .rdata_o(rom_o)
    );

    // internal_address = addr_i >> 2

    // Initializing Signals
    initial begin
        internal_we <= '0;
        internal_write_data <= '0;
        num_bytes_written <= '0;
        internal_address <= '0;
        prog_addr <= '0;
        prog_reg <= prog_i;
    end

    // Enabling Programming
    always @(prog_i, addr_i, prog_we, prog_write_data, prog_addr) begin
        if(prog_i == 1'b1) begin
            internal_we <= prog_we;
            internal_write_data <= prog_write_data;
            internal_address <= prog_addr;
        end else begin
            internal_we <= '0;
            internal_write_data <= '0;
            internal_address <= addr_i >> 2;
        end
    end

    // Enabling Writing through UART
    always @(posedge clk) begin
        // Checking for Rising Edge
        if((prog_i == 1'b1) && (prog_reg == 1'b0)) begin
            prog_addr_reg <= '0;
            num_bytes_written <= '0;
            prog_we <= '0;
            prog_write_data <= '0;
        end else begin
            if(data_valid == 1'b1) begin
                prog_write_data <= {prog_write_data[DATA_WIDTH-9:0], byte_recieved};
                if(num_bytes_written == (NUM_BYTES - 1)) begin
                    prog_addr_reg <= prog_addr_reg + 1;
                    num_bytes_written <= '0;
                    prog_we <= '1;
                end else begin
                    prog_addr <= prog_addr;
                    num_bytes_written <= num_bytes_written + 1;
                    prog_we <= '0;
                end
            end else begin
                prog_write_data <= prog_write_data;
                prog_addr <= prog_addr;
                num_bytes_written <= num_bytes_written;
                prog_we <= '0;
            end
        end
        prog_addr <= prog_addr_reg;
        prog_reg <= prog_i;
    end

endmodule
