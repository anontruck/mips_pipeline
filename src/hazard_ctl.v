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
   output reg [1:0] alu_fw_sel_a_87,
   output reg [1:0] alu_fw_sel_b_87,
   output reg branch_fw_a_87,
   output reg branch_fw_b_87,
   input wire branch_flag_87,
   input wire reg_write_ex_mem_87,
   input wire reg_write_mem_wb_87,
   input wire mem_read_id_ex_87,
   input wire [`RADDR_WIDTH-1:0] rs_if_id_87,   // 1st incoming read reg to ID
   input wire [`RADDR_WIDTH-1:0] rt_if_id_87,   // 2nd incoming read reg to ID
   input wire [`RADDR_WIDTH-1:0] rs_id_ex_87,
   input wire [`RADDR_WIDTH-1:0] rt_id_ex_87,
   input wire [`RADDR_WIDTH-1:0] rd_id_ex_87,   // rd between ID and EX stages
   input wire [`RADDR_WIDTH-1:0] rd_ex_dm_87,   // rd between EX and MEM stages
   input wire [`RADDR_WIDTH-1:0] rd_dm_wb_87,   // rd between MEM and WB stages
   input wire [`RADDR_WIDTH-1:0] rd_wb_id_87,   // write back reg
   input wire rst_87
);
parameter FORWARDING_ENABLED = 0;

wire hazard_r1_id_ex = (rs_if_id_87 == rd_id_ex_87) && (rd_id_ex_87 != 0);
wire hazard_r1_ex_dm = (rs_if_id_87 == rd_ex_dm_87) && (rd_ex_dm_87 != 0);
wire hazard_r1_dm_wb = (rs_if_id_87 == rd_dm_wb_87) && (rd_dm_wb_87 != 0);
wire hazard_r1_wb_id = (rs_if_id_87 == rd_wb_id_87) && (rd_wb_id_87 != 0);

wire hazard_r2_id_ex = (rt_if_id_87 == rd_id_ex_87) && (rd_id_ex_87 != 0);
wire hazard_r2_ex_dm = (rt_if_id_87 == rd_ex_dm_87) && (rd_ex_dm_87 != 0);
wire hazard_r2_dm_wb = (rt_if_id_87 == rd_dm_wb_87) && (rd_dm_wb_87 != 0);
wire hazard_r2_wb_id = (rt_if_id_87 == rd_wb_id_87) && (rd_wb_id_87 != 0);

wire hazard_r1 = hazard_r1_id_ex || hazard_r1_ex_dm || hazard_r1_dm_wb || hazard_r1_wb_id;
wire hazard_r2 = hazard_r2_id_ex || hazard_r2_ex_dm || hazard_r2_dm_wb || hazard_r2_wb_id;

wire hazard_load = mem_read_id_ex_87 && ((rt_id_ex_87 == rs_if_id_87) || (rt_id_ex_87 == rt_if_id_87));

wire hazard_exe_v = reg_write_ex_mem_87 && (rd_ex_dm_87 != 0);
wire hazard_exe_a = hazard_exe_v && (rd_ex_dm_87 == rs_id_ex_87);
wire hazard_exe_b = hazard_exe_v && (rd_ex_dm_87 == rt_id_ex_87);

wire hazard_mem_v = reg_write_mem_wb_87 && (rd_dm_wb_87 != 0);
wire hazard_mem_a = hazard_mem_v && (rd_dm_wb_87 == rs_id_ex_87) && !hazard_exe_a;
wire hazard_mem_b = hazard_mem_v && (rd_dm_wb_87 == rt_id_ex_87) && !hazard_exe_b;

always @(*) begin
   stall_87 <= 0;
   alu_fw_sel_a_87 <= 2'b0;
   alu_fw_sel_b_87 <= 2'b0;
   branch_fw_a_87 <= 0;
   branch_fw_b_87 <= 0;
   if (!rst_87) begin
      if (FORWARDING_ENABLED == 1) begin
         if (hazard_load) begin
            stall_87 <= 1;
         end else begin
         //end
            if (hazard_exe_a)
               alu_fw_sel_a_87 <= 2'b10;
            if (hazard_exe_b)
               alu_fw_sel_b_87 <= 2'b10;
            if (hazard_mem_a)
               alu_fw_sel_a_87 <= 2'b01;
            if (hazard_mem_b)
               alu_fw_sel_b_87 <= 2'b01;
            
            if (branch_flag_87 && hazard_r1_ex_dm)
               branch_fw_a_87 <= 1;
            if (branch_flag_87 && hazard_r2_ex_dm)
               branch_fw_b_87 <= 1;
         end
      end else if (hazard_r1 || hazard_r2) begin
         stall_87 <= 1;
      end
   end
end

endmodule // hazard_ctl