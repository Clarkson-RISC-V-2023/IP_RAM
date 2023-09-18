# IP_RAM
This repo contains the logic for our custom memory block and RAM modules

The RAM module instanciates the memory block and the default configuration will be to have the memblock have a DATA_WIDTH of 8 and then the RAM module will instanciate 4 times the block memory to build up a 32 bit memory by ofsetting the adress to the different instances of the memblock 

## To add as submodule use:
`git submodule add -b main -f --name IP_RAM git@github.com:Clarkson-RISC-V-2023/IP_RAM.git /src/ip/mem`