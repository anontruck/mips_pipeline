////////////////////////////////////////////////////////////////////////////////
// Module: ctrl_unit.v
// Project: SJSU EE275 Mini Project 2
// Description: Control unit. Part of the instruction decode stage.
//
// Name: Zach Smith 
// Student ID: 007159087
//
// Note:
//
////////////////////////////////////////////////////////////////////////////////
`include "mips_defs.vh"
`include "alu.vh"

module ctrl_unit(
   output   reg                           reg_wb_87,
   output   reg                           reg_dst_87,
   output   reg                           alu_src_87,
   output   reg                           branch_87,
   output   reg                           jump_87,
   output   reg                           mem_read_87,
   output   reg                           mem_write_87,
   output   reg                           mem_to_reg_87,
   output   reg   [3:0]                   alu_op_87,
   input    wire  [`FIELD_WIDTH_OP-1:0]   op_87
);

always @(*) begin
   reg_wb_87      <= 1'b0;
   reg_dst_87     <= 1'b0;
   alu_src_87     <= 1'b0;
   branch_87      <= 1'b0;
   jump_87        <= 1'b0;
   mem_read_87    <= 1'b0;
   mem_write_87   <= 1'b0;
   mem_to_reg_87  <= 1'b0;
   alu_op_87      <= 4'b0;

   if (op_87 == `OPCODE_R) begin
      reg_wb_87      <= 1'b1;
      reg_dst_87     <= 1'b1;       // destination register is rd
      alu_op_87      <= `ALU_FCN;
   end else if (op_87 == `OPCODE_J) begin
      jump_87        <= 1'b1;
   end else if ((op_87 == `OPCODE_BEQ) || (op_87 == `OPCODE_BNE)) begin
      branch_87      <= 1'b1;
      alu_op_87      <= `ALU_SUB;
   end else if (op_87 == `OPCODE_LW) begin
      reg_wb_87      <= 1'b1;
      alu_src_87     <= 1'b1;
      mem_read_87    <= 1'b1;
      mem_to_reg_87  <= 1'b1;
      alu_op_87      <= `ALU_ADD;
   end else if (op_87 == `OPCODE_SW) begin
      alu_src_87     <= 1'b1;
      mem_write_87   <= 1'b1;
      alu_op_87      <= `ALU_ADD;
   end else if (op_87 == `OPCODE_ADDI) begin
      alu_src_87     <= 1'b1;
      reg_wb_87      <= 1'b1;
      alu_op_87      <= `ALU_ADD;
   end else if (op_87 == `OPCODE_ADDIU) begin
      alu_src_87     <= 1'b1;
      reg_wb_87      <= 1'b1;
      alu_op_87      <= `ALU_ADDU;
   end else if (op_87 == `OPCODE_ANDI) begin
      alu_src_87     <= 1'b1;
      reg_wb_87      <= 1'b1;
      alu_op_87      <= `ALU_AND;
   end else if (op_87 == `OPCODE_ORI) begin
      alu_src_87     <= 1'b1;
      reg_wb_87      <= 1'b1;
      alu_op_87      <= `ALU_OR;
   end else if (op_87 == `OPCODE_SLTI) begin
      alu_src_87     <= 1'b1;
      reg_wb_87      <= 1'b1;
      alu_op_87      <= `ALU_SLT;
   end else if (op_87 == `OPCODE_SLTIU) begin
      alu_src_87     <= 1'b1;
      reg_wb_87      <= 1'b1;
      alu_op_87      <= `ALU_SLTU;
   end else begin
      // TODO - handle this somehow
   end
end

endmodule // ctrl_unit