`include "uvm_macros.svh"
import uvm_pkg::*;

class ram_driver extends uvm_driver #(ram_packet_item);
    `uvm_component_utils(ram_driver)

    ram_packet_item item;
    virtual ram_if vif;

    function new (string name = "DEFAULT RAM driver", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual ram_if):: get(this, "", "ram_vif", vif))
            `uvm_fatal("DRIVER", "Could not get hold of vif...")
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            `uvm_info("DRIVER", $sformatf("Waiting for sequencer..."), UVM_LOW)
            seq_item_port.get_next_item(item);
            drive_item(item);
            seq_item_port.item_done();
        end
    endtask

    virtual task drive_item(ram_packet_item item);
        vif.addr = item.addr;
        vif.wdata = item.wdata;
        vif.mem_block_en = item.mem_block_en;
        vif.wr_en = item.wr_en;
        vif.rdata = item.rdata;
        @ (posedge vif.clk);
    endtask
endclass