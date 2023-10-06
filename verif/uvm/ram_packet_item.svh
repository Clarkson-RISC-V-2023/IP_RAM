// Base UVM transaction item

`include "uvm_macros.svh"
import uvm_pkg::*;

import ram_params::*;

class ram_packet_item extends uvm_sequence_item;
    rand bit [$clog2(ADDRESS_SPACE)-1:0]    addr;
    rand bit [DATA_WIDTH-1:0]               wdata;
    rand bit [NUM_OF_MEM_BLOCKS-1:0]        mem_block_en;
    rand bit                                wr_en;
    bit      [DATA_WIDTH-1:0]               rdata;

    constraint ram_item_addr { addr inside {[0:ADDRESS_SPACE-1]}; };

    // Use macro to register class with factory
    `uvm_object_utils_begin(ram_packet_item)
        `uvm_field_int(addr, UVM_DEFAULT)
        `uvm_field_int(wdata, UVM_DEFAULT)
        `uvm_field_int(rdata, UVM_DEFAULT)
        `uvm_field_int(mem_block_en, UVM_DEFAULT)
        `uvm_field_int(wr_en, UVM_DEFAULT)
    `uvm_object_utils_end

    function new (string name = "DEFAULT ram_packet_item");
        super.new(name);
    endfunction

    virtual function string convert2string();
        return $sformatf("addr=0x%0h - wdata=0x%0h - rdata=0x%0h - wr=%0d - mem_block_en=0x%h", addr, wdata, rdata, wr_en, mem_block_en);
    endfunction

endclass