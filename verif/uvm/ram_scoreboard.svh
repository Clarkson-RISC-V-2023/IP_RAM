`include "uvm_macros.svh"
import uvm_pkg::*;

import ram_params::*;

class ram_scoreboard extends uvm_scoreboard;
    
    `uvm_component_utils(ram_scoreboard)
    function new(string name = "DEFAULT RAM scoreboard", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    int mem_space = DEPTH;
    ram_packet_item refq[DEPTH];
    uvm_analysis_imp #(ram_packet_item, ram_scoreboard) m_analysis_imp; // Monittor analysis

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        m_analysis_imp = new("m_analysis_imp", this);
    endfunction

    virtual function write(ram_packet_item item);
        if(item.wr_en) begin
            if(refq[item.addr] == null) begin 
                refq[item.addr] =  new;
                mem_space = mem_space - 1;
                `uvm_info(get_type_name(), $sformatf("New value written. %d of %d left to be written", mem_space, DEPTH), UVM_LOW);
            end
            refq[item.addr] = item;
            `uvm_info(get_type_name(), $sformatf("Wrote 0x%0h to addr 0x%0h", item.wdata, item.addr), UVM_LOW);
        end

        if(!item.wr_en) begin
            if(refq[item.addr] == null)
                `uvm_error (get_type_name(), $sformatf("First time read addr=0x%0h. RAM initialization error, this address should have been written by sequence", item.addr))
            else
                if (item.rdata != refq[item.addr].wdata)
                    `uvm_error(get_type_name(), $sformatf("Data missmatch, read addr 0x%0h and got 0x%h but 0x%h was expectedd...", item.addr, item.rdata, refq[item.addr].wdata))
                else 
                    `uvm_info(get_type_name(), $sformatf("PASS! read addr 0x%0h got 0x%0h and mattched the expected 0x%h0", item.addr, item.rdata, refq[item.addr].wdata), UVM_LOW)
        end
    endfunction
endclass
