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

/*

data hazard when destination register of current instruction in execution stage
is the same as the address to be read in the incoming instruction decode stage

ALU result from EX/MEM register is always fed back to the ALU input latches

if the forwarding hardware detects that the previous ALU operation has written
to the register corresponding to the source for the current ALU operation, we
select the forwarded result as the ALU input rather than the value read from the
register


*/

module hazard_ctl(
   output reg stall_87,
   output reg flush_87,
   input wire [`RADDR_WIDTH-1:0] r1_id_in_87,   // 1st incoming read reg to ID
   input wire [`RADDR_WIDTH-1:0] r2_id_in_87,   // 2nd incoming read reg to ID
   input wire [`RADDR_WIDTH-1:0] rs_id_ex_87,   // rs between ID and EX stages
   input wire [`RADDR_WIDTH-1:0] rt_id_ex_87,   // rt between ID and EX stages
   input wire [`RADDR_WIDTH-1:0] rd_ex_dm_87,   // rd between EX and MEM stages
   input wire [`RADDR_WIDTH-1:0] rd_dm_wb_87,   // rd between MEM and WB stages
   input wire rst_87
);

always @(*) begin

end

endmodule // hazard_ctl