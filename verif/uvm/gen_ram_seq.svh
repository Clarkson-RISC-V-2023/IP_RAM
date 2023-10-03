`include "uvm_macros.svh"
import uvm_pkg::*;
import ram_params::*;

class gen_ram_seq extends uvm_sequence;
    // Register class with factory
    `uvm_object_utils(gen_ram_seq)

    rand bit [DEPTH-1:0] packet_data [DATA_WIDTH-1:0];

    function new(string name = "DEFAULT sequence");
        super.new(name);
    endfunction

    ram_packet_item item;          // write itme

    virtual task body();
        `uvm_info("SEQUENCER", $sformatf("Creating %d 'w' ram_packets with word size of %d bits", DEPTH, DATA_WIDTH), UVM_LOW)
        
        // Write to all RAM addresses with full words
        for (int i = 0; i < DEPTH; i++) begin
            string seq_item_name = $sformatf("RAM 'w' data packet #%d", i);

            item = ram_packet_item::type_id::create(seq_item_name);

            start_item(item);
            item.randomize() with { addr == i; mem_block_en == {NUM_OF_MEM_BLOCKS{1'b1}}; wr_en_i == 1'b1; };
            finish_item(item);
        end 

        read_all_memory();

        `uvm_info("SEQUENCER", $sformatf("Sending %d random 'w' ram_packets to overwrite data stored", DEPTH, DATA_WIDTH), UVM_LOW)
        // Read all address locations to verify data
        for (int i = 0; i < DEPTH; i++) begin
            string seq_item_name = $sformatf("RAM 'w' data packet #%d", i);

            item = ram_packet_item::type_id::create(seq_item_name);

            start_item(item);
            item.randomize() with { mem_block_en == {NUM_OF_MEM_BLOCKS{1'b1}}; wr_en_i == 1'b1; };
            finish_item(item);
        end

        read_all_memory();

    endtask

    function void read_all_memory ();
        `uvm_info("SEQUENCER", $sformatf("Sending %d 'r' ram_packets to verify data stored", DEPTH), UVM_LOW)
        
        // Read all address locations to verify data
        for (int i = 0; i < DEPTH; i++) begin
            string seq_read_item = $sformatf("sequencer_reader_item_#%d", i);
            reader_item = ram_packet_item::type_id::create(seq_read_item);
            start_item(reader_item);
            reader_item.randomize() with { addr == i; wr_en_i == 1'b0; };
            finish_item(reader_item);
        end
    endfunction

endclass