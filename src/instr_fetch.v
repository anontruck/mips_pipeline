////////////////////////////////////////////////////////////////////////////////
// Module: instr_fetch.v
// Project: SJSU EE275 Mini Project 2
// Description: Instruction fetch unit
//
// Name: Zach Smith 
// Student ID: 007159087
//
// Note:
//
////////////////////////////////////////////////////////////////////////////////
`include "mips_defs.vh"

module instr_fetch(
   output wire [`INSTR_WIDTH-1:0] instr_87,  // next instruction to decode
   output reg  [`ADDR_WIDTH-1:0] pc_87,      // current instruction address
   input wire  [`ADDR_WIDTH-1:0] npc_87,     // next address if not pc+4
   input wire sel_87,                        // if set, use given npc
   input wire rst_87,
   input wire clk_87
);

wire en_87 = ~rst_87; 
wire [`ADDR_WIDTH-1:0] next_addr_87;

assign next_addr_87 = sel_87 ? npc_87 : pc_87 + 4;

instr_mem i_mem_87 (
   .instr_87   ( instr_87  ),
   .addr_87    (  pc_87    ),
   .en_87      (  en_87    ),
   .clk_87     (  clk_87   )
);


always @(posedge clk_87 or posedge rst_87) begin
   if (rst_87) begin
      pc_87          <= `ADDR_WIDTH'b0;
   end else begin
      pc_87          <= next_addr_87;
   end
end

endmodule // instr_fetch