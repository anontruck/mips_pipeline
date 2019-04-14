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
   output reg [`INSTR_WIDTH-1:0] instr_87,   // next instruction to decode
   output reg [`ADDR_WIDTH-1:0] npc_87,      // next pc

   input wire [`ADDR_WIDTH-1:0] pc_87,
   input wire flush_87,
   input wire stall_87,
   input wire sel_87,                        // if set, use given pc
   input wire rst_87,
   input wire clk_87
);

reg [`INSTR_WIDTH-1:0] instr_store_87;
reg [`ADDR_WIDTH-1:0] cpc_87;
wire [`INSTR_WIDTH-1:0] mem_out_87;

//wire en_87 = (stall_87 == 1'b1) ? 1'b0 : 1'b1;
wire en_87 = 1;

wire [`ADDR_WIDTH-1:0] sel_adr_87 = sel_87 ? pc_87 : npc_87;
wire [`ADDR_WIDTH-1:0] mem_adr_87 = stall_87 ? cpc_87 : sel_adr_87;
wire [`ADDR_WIDTH-1:0] pc_next_87 = mem_adr_87 + 4;

instr_mem i_mem_87 (
   .instr_87   (mem_out_87),
   .addr_87    (mem_adr_87),
   .en_87      (en_87),
   .clk_87     (clk_87)
);

always @(posedge clk_87) begin
   if (rst_87 || flush_87) begin
      npc_87 <= 0;
      cpc_87 <= 0;
   end else if (stall_87) begin
      cpc_87 <= cpc_87;
      npc_87 <= npc_87;
   end else begin
      cpc_87 <= mem_adr_87;
      npc_87 <= mem_adr_87 + 4;
   end
end

always @(*) begin
   if (rst_87 || flush_87) begin
      instr_87 <= 0;
   end else begin
      instr_87 <= mem_out_87;
   end
end

`ifdef DEBUG_TRACE

always @(posedge clk_87) begin
   if (rst_87) begin
      $strobe($time,,,"IF: RESET");
   end else begin
      if (stall_87) begin
         $strobe($time,,,"IF: STALLED");
      end else begin
         $strobe($time,,,"IF: NPC=%0d PC=%0d -> 0x%8h", npc_87, cpc_87, instr_87);
         //$display($time,,,"IF: NPC=%0d PC=%0d -> 0x%8h", pc_next_87, mem_adr_87, mem_out_87);
      end
   end
end
`endif

endmodule // instr_fetch