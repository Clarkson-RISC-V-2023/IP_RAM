`include "uvm_macros.svh"
import uvm_pkg::*;

import ram_params::*;

module tb_uvm_ram;

    reg clk;

    always #10 clk = ~clk;
    
    ram_if vif (
        .clk(clk)
    );

    ram ram_dut (
        .clk(clk),
        .addr_i(vif.addr),
        .wdata_i(vif.wdata),
        .mem_block_en_i(vif.mem_block_en),
        .wr_en_i(vif.wr_en),
        .rdata_o(vif.rdata)
    );

    initial begin
        $dumpvars;
        $dumpfile("tb_uvm_ram.vcd");

        clk <= 0;

        uvm_config_db #(virtual ram_if)::set(uvm_root::get(), "*", "ram_vif", vif);

        run_test("verify_ram_test");
    end

endmodule