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
   output reg [`INSTR_WIDTH-1:0] instr_87,  // next instruction to decode
   output reg [`ADDR_WIDTH-1:0] npc_87,
   input wire [`ADDR_WIDTH-1:0] pc_87,
   input wire sel_87,                        // if set, use given npc
   input wire rst_87,
   input wire clk_87
);

wire [`INSTR_WIDTH-1:0] mem_out_87;
wire [`ADDR_WIDTH-1:0] pc_sel_87;
wire [`ADDR_WIDTH-1:0] pc_nxt_87;

wire en_87 = ~rst_87; 

assign pc_sel_87 = rst_87 ? 0 : sel_87 ? pc_87 : npc_87;
assign pc_nxt_87 = pc_sel_87 + 4;

//assign npc_87 = rst_87 ? 0 : pc_next_87 + 4;

instr_mem i_mem_87 (
   .instr_87   ( mem_out_87),
   .addr_87    ( pc_sel_87),
   .en_87      (  en_87    ),
   .clk_87     (  clk_87   )
);


//always @(posedge clk_87 or posedge rst_87) begin
always @(posedge clk_87) begin
   if (rst_87) begin
      instr_87 <= 0;
      npc_87   <= 0;
   end else begin
      instr_87 <= mem_out_87;
      npc_87   <= pc_nxt_87;
   end
end

endmodule // instr_fetch