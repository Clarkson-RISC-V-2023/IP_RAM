`include "uvm_macros.svh"
import uvm_pkg::*;

class verify_ram_test extends uvm_test;
    `uvm_component_utils(verify_ram_test)
    function new(string name = "DEFAULT RAM tets", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    ram_env e0;
    virtual ram_if vif;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        e0 = ram_env::type_id::create("ENVIROMENT", this);
        if (!uvm_config_db#(virtual ram_if)::get(this, "", "ram_vif", vif))
            `uvm_fatal(get_type_name(), "Did not get a hold for vif...")

            uvm_config_db#(virtual ram_if)::set(this, "e0.a0.*", "ram_vif", vif);
            `uvm_info(get_type_name(), "Succeed! Build Phase Complete...", UVM_LOW)
    endfunction

    virtual task run_phase(uvm_phase phase);
        gen_ram_seq seq = gen_ram_seq::type_id::create("Full Read & Write SEQ", this);
        phase.raise_objection(this);
        
        seq.randomize();

        seq.start(e0.a0.s0);

        #200
        phase.drop_objection(this);
    endtask
    
endclass 