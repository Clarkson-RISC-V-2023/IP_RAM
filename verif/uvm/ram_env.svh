`include "uvm_macros.svh"
import uvm_pkg::*;

class ram_env extends uvm_env;
    `uvm_component_utils(ram_env)
    function new(string name = "DEFAULT ram_env", uvm_component parent);
        super.new(name, parent);
    endfunction

    ram_agent       a0;
    ram_scoreboard  sb0;
    virtual ram_if  vif;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        a0  = ram_agent::type_id::create("AGENT", this);
        sb0 = ram_scoreboard::type_id::create("SCOREBOARD", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        a0.m0.mon_analysis_port.connect(sb0.m_analysis_imp);
    endfunction
endclass