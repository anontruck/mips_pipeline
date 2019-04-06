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
wire [`INSTR_WIDTH-1:0] instr_read_87;
wire [`ADDR_WIDTH-1:0] adr_87;

assign adr_87 = addr_87 >> 2;

vl_ram #(.memory_file(instr_file),
         .memory_init(1),
         .data_width ('d`INSTR_WIDTH),
         .addr_width ('d`ADDR_WIDTH ),
         .mem_size   ('d`ADDR_WIDTH*2))
         iram (.d    (`INSTR_WIDTH'b0),   // input data bus - not use
               .adr  (  adr_87      ),    // address input
               .we   (  1'b0        ),    // disable write mod
               .q    (  instr_read_87),   // the retrieved instruction
               .clk  (  clk_87      )
         );

assign instr_87 = en_87 ? instr_read_87 : 0;

//always @(posedge clk_87 or negedge en_87) begin
   //if (en_87) begin
      //instr_87 <= instr_read_87;
   //end else begin
      //instr_87 <= 0;
   //end   
//end

endmodule // instr_mem