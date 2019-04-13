////////////////////////////////////////////////////////////////////////////////
// Module:  hazard_ctl.v
// Project: SJSU EE275 Mini Project 2
// Description: Hazard control unit
//
// Name: Zach Smith 
// Student ID: 007159087
//
////////////////////////////////////////////////////////////////////////////////
`include "mips_defs.vh"

module hazard_ctl(
   output reg stall_87,
   output reg flush_87,
   input wire [`RADDR_WIDTH-1:0] r1_id_in_87,   // 1st incoming read reg to ID
   input wire [`RADDR_WIDTH-1:0] r2_id_in_87,   // 2nd incoming read reg to ID
   input wire [`RADDR_WIDTH-1:0] rd_id_ex_87,   // rd between ID and EX stages
   input wire [`RADDR_WIDTH-1:0] rd_ex_dm_87,   // rd between EX and MEM stages
   input wire [`RADDR_WIDTH-1:0] rd_dm_wb_87,   // rd between MEM and WB stages
   input wire [`RADDR_WIDTH-1:0] rd_wb_id_87,   // write back reg
   input wire rst_87
);

wire hazard_r1_id_ex = (r1_id_in_87 == rd_id_ex_87) && (rd_id_ex_87 != 0);
wire hazard_r1_ex_dm = (r1_id_in_87 == rd_ex_dm_87) && (rd_ex_dm_87 != 0);
wire hazard_r1_dm_wb = (r1_id_in_87 == rd_dm_wb_87) && (rd_dm_wb_87 != 0);
wire hazard_r1_wb_id = (r1_id_in_87 == rd_wb_id_87) && (rd_wb_id_87 != 0);

wire hazard_r2_id_ex = (r2_id_in_87 == rd_id_ex_87) && (rd_id_ex_87 != 0);
wire hazard_r2_ex_dm = (r2_id_in_87 == rd_ex_dm_87) && (rd_ex_dm_87 != 0);
wire hazard_r2_dm_wb = (r2_id_in_87 == rd_dm_wb_87) && (rd_dm_wb_87 != 0);
wire hazard_r2_wb_id = (r2_id_in_87 == rd_wb_id_87) && (rd_wb_id_87 != 0);

wire hazard_r1 = hazard_r1_id_ex || hazard_r1_ex_dm || hazard_r1_dm_wb || hazard_r1_wb_id;
wire hazard_r2 = hazard_r2_id_ex || hazard_r2_ex_dm || hazard_r2_dm_wb || hazard_r2_wb_id;

always @(*) begin
   stall_87 <= 0;
   flush_87 <= 0;
   if (!rst_87 && (hazard_r1 || hazard_r2)) begin
      stall_87 <= 1;
   end
end

endmodule // hazard_ctl