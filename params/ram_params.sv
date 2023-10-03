package ram_params;
    parameter int DATA_WIDTH = 32; // Must be multiple of 8 or BANK_WIDTH
    parameter int DEPTH = 1024;
    parameter int NUM_OF_MEM_BLOCKS = 4; // DATA_WIDTH/8 or DATA_WIDTH/BANK_WIDTH
    parameter int ADDRESS_SPACE = 4096; // <= DEPTH * NUM_OF_MEM_BLOCKS
endpackage