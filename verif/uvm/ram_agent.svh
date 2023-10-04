`include "uvm_macros.svh"
import uvm_pkg::*;

class ram_agent extends uvm_agent;
    `uvm_component_utils(ram_agent)
    function new(string name = "DEFAULT RAM agent", uvm_component parent);
        super.new(name, parent);
    endfunction

    ram_driver                          d0;
    ram_monitor                         m0;
    uvm_sequencer #(ram_packet_item)    s0;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        d0 = ram_driver::type_id::create("DRIVER", this);
        m0 = ram_monitor::type_id::create("MONITOR", this);
        s0 = uvm_sequencer#(ram_packet_item)::type_id::create("SEQUENCER", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        d0.seq_item_port.connect(s0.seq_item_export);
    endfunction
endclass