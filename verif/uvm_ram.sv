// Environment Architecture:
// // Testbench
// // DUT (Design Under Test)
// // Stimulus Generation (Sequencer)
// // Data Generation (Driver)
// // Monitor
// // Scoreboard
// // Functional Coverage
// // Assertions (if needed)

// Include UVM 
`include "uvm_macros.svh"


// Define Agent class

// Define Scoreboard class

// Define Driver

// Define Sequencer

    // Sequence item

class ram_sequence_item extends uvm_sequence_item;
    `uvm_object_utils(ram_sequence_item)

    //TODO add support for half and byte read and writes
    // RAM transaction package 
    bit [31:0] addr;    // Address for the package
    bit [31:0] data;    // Data to write or read
    bit wr_en;          // Write enable bit

    // TODO this should only be constraint for Full Word
    constraint addr_constraint {
        addr >= 0;
        addr <= 4096;
        (addr + 1 ) % 4 == 0; 
    } // Address should go in increments of 4 starting from 0

    function new(string name = "RAM data packet");
        super.new(name);
    endfunction

    // Func to print packat data
    function void do_print(uvm_printer printer);
        super.do_print(printer);
        printer.field("Packet Information: ");
        printer.field_int("addr", addr, 32, UVM_HEX);
        printer.field_int("data", data, 32, UVM_HEX);
        printer.field_int("wr_en", wr_en, 1, UVM_HEX);
    endfunction : do_print

    function bit do_compare (uvm_object obj_to_compare);//, uvm_comparer comparer);
        ram_sequence_item ram_item_compare;
        if (!$cast(ram_item_compare, obj_to_compare)) // cast copies over obj_to_compare to ram_item_compare
            return 0;

        if (addr !== ram_item_compare.addr || data !== ram_item_compare.data || write !== ram_item_compare.write)
            return 0;

        return 1;
    endfunction : do_compare

    // Function to clone the data packer
    function ram_sequence_item clone();
        ram_sequence_item clone_item;
        clone_item = new();
        clone_item.addr = addr;
        clone_item.data = data;
        clone_item.write = write;
        return clone_item;
    endfunction : clone
endclass : ram_sequence_item

class ram_sequence_rw_type extends uvm_sequence#(ram_sequence_item);
    `uvm_object_utils(ram_sequence_rw_type)

    function new(string name = "RAM Sequence Type r/w")
        super.new(name);
    endfunction : new;

    task body();
        ram_sequence_item ram_seq_item = new;
        ram_seq_item.randomize(); // Randomize Packet data and address

        if (randomize::random() % 2 == 0)
            ram_seq_item.wr_en = 1; // Write Operation
        else
            ram_seq_item.wr_en = 0; // Read Operation

        ram_seq_item.star();

        //TODO Add steps to read back RAM and make sure the values are correct
            // Use something like wait(10); // Delays the simulation for 10 clock cycles or #1s;   // Delays the simulation by 1 second
    endtask
endclass : ram_sequence_rw_type

class ram_sequencer extends uvm_sequencer#(ram_sequence_rw_type);
    `uvm_component_utils (ram_sequencer);

    function new(string name = "ram_sequencer", uvm_component parent);
        super.new(name, parent);
    endfunction : new

    task start_read_write_sequence(int repeat_for);
        for (int i = 0; i < repeat_for; i++) begin
            ram_sequence_rw_type rw_seq = ram_sequence_rw_type::type_id::create($sformatf("rw_seq_%Od", i), this);
            // rw_seq.randomize();
            rw_seq.start(this);
        end
    endtask
endclass : ram_sequencer

// Define Monitor

