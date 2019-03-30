////////////////////////////////////////////////////////////////////////////////
// Module: instr_mem.v
// Project: SJSU EE275 Mini Project 2
// Description: Instruction memory unit. Essentially just a wrapper around a 
//              RAM module.
//
// Name: Zach Smith 
// Student ID: 007159087
//
// Note: RAM module is from OpenCores Versatile Library:
//       https://opencores.org/projects/versatile_library
//
////////////////////////////////////////////////////////////////////////////////
`include "mips_defs.vh"

module instr_mem(
   output wire [`INSTR_WIDTH-1:0] instr_87,     // 32-bit fetched instruction
   input wire  [`ADDR_WIDTH-1:0] addr_87,       // 32-bit instruction address
   input wire  en_87,                           // enable line
   input wire  clk_87                           // 
);
parameter instr_file = `ifdef INSTR_FILE `INSTR_FILE `else "instr_mem.mem" `endif;

// this will still be made synchronous by ram module
wire [`INSTR_WIDTH/8-1:0] be = en_87 ? `INSTR_WIDTH/8'b1 : `INSTR_WIDTH/8'b0;

// TODO: need to make the instruction memory file set on build
// byte enabled ram module
vl_ram_be #(.memory_file(instr_file),  // Note: data expected to be in hex
            .data_width(32'd`INSTR_WIDTH),
            .addr_width(32'd`ADDR_WIDTH),
            .mem_size(32'd`ADDR_WIDTH * 2),
            .memory_init(1))
            iram_87 (
               .d(`INSTR_WIDTH'b0), // input data bus - not used
               .adr(addr_87),       // address input
               .we(1'b0),           // disable write mode
               .be(be),             // byte enable input
               .q(instr_87),        // the retrieved instruction
               .clk(clk_87)         // not sure what this does
);

endmodule // instr_mem