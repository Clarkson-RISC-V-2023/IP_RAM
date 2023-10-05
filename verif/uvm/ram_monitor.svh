`include "uvm_macros.svh"
import uvm_pkg::*;

class ram_monitor extends uvm_monitor;
    `uvm_component_utils(ram_monitor)

    function new(string name = "DEFAULT RAM monitor", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    uvm_analysis_port #(ram_packet_item) mon_analysis_port;
    virtual ram_if vif;
    semaphore sema4;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual ram_if)::get(this, "", "ram_vif", vif))
            `uvm_fatal(get_type_name(), "Could not get a hold of vif")
        sema4 =  new(1);
        mon_analysis_port = new("mon_analysis_port", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        
        forever begin
            ram_packet_item item = new;
            @ (posedge vif.clk);
            item.addr = vif.addr;
            item.wdata = vif.wdata;
            item.wr_en = vif.wr_en;

            if (!item.wr_en)
                @ (posedge vif.clk)
                item.rdata = vif.rdata;

            // Send packet to scoreboard to be analyzed
            mon_analysis_port.write(item);
        end 
    endtask
endclass