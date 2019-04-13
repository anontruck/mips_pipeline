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

module ctrl_unit(
   output reg reg_wb_87,
   output reg reg_dest_87,
   output reg alu_src_87,
   output reg branch_87,
   output reg jump_reg_87,
   output reg jump_imm_87,
   output reg mem_read_87,
   output reg mem_write_87,
   output reg mem_to_reg_87,
   output reg imm_as_reg_87, // kludge    
   output reg [1:0] alu_op_87,
   input wire en_87,
   input wire [`FIELD_WIDTH_OP-1:0]   op_87,
   input wire [`FIELD_WIDTH_FUNC-1:0] fn_87
);

always @(*) begin
   reg_wb_87      <= 1'b0;
   reg_dest_87    <= 1'b0;
   alu_src_87     <= 1'b0;
   branch_87      <= 1'b0;
   jump_reg_87    <= 1'b0;
   jump_imm_87    <= 1'b0;
   mem_read_87    <= 1'b0;
   mem_write_87   <= 1'b0;
   mem_to_reg_87  <= 1'b0;
   imm_as_reg_87  <= 1'b0;
   alu_op_87      <= 2'b0;

   if (en_87 == 1'b1) begin
      if (op_87 == `OPCODE_R) begin
         if (fn_87 == `FUNC_JR) begin
            jump_reg_87    <= 1'b1;
         end else begin
            reg_wb_87      <= 1'b1;
            reg_dest_87    <= 1'b1;       // destination register is rd
            alu_op_87      <= 2'b10;
         end
      end else if (op_87 == `OPCODE_J) begin
         jump_imm_87    <= 1'b1;
      end else if (op_87 == `OPCODE_BEQ) begin
         branch_87      <= 1'b1;
         alu_op_87      <= 2'b01;
      end else if (op_87 == `OPCODE_BNE) begin
         branch_87      <= 1'b1;
         alu_op_87      <= 2'b11;
      end else if (op_87 == `OPCODE_LW) begin
         reg_wb_87      <= 1'b1;
         alu_src_87     <= 1'b1;
         mem_read_87    <= 1'b1;
         mem_to_reg_87  <= 1'b1;
         alu_op_87      <= 2'b0;
      end else if (op_87 == `OPCODE_SW) begin
         alu_src_87     <= 1'b1;
         mem_write_87   <= 1'b1;
         alu_op_87      <= 2'b0;
      end else if (op_87 == `OPCODE_ADDI) begin
         alu_src_87     <= 1'b1;
         reg_wb_87      <= 1'b1;
         alu_op_87      <= 2'b0;
      end else if (op_87 == `OPCODE_ADDIU) begin
         alu_src_87     <= 1'b1;
         reg_wb_87      <= 1'b1;
         alu_op_87      <= 2'b0;
      end else if (op_87 == `OPCODE_ANDI) begin
         alu_src_87     <= 1'b1;
         reg_wb_87      <= 1'b1;
      end else if (op_87 == `OPCODE_ORI) begin
         alu_src_87     <= 1'b1;
         reg_wb_87      <= 1'b1;
      end else if (op_87 == `OPCODE_SLTI) begin
         alu_src_87     <= 1'b1;
         reg_wb_87      <= 1'b1;
      end else if (op_87 == `OPCODE_SLTIU) begin
         alu_src_87     <= 1'b1;
         reg_wb_87      <= 1'b1;
      end else if (op_87 == `OPCODE_MUL) begin  // treating this like an R-type
         reg_wb_87      <= 1'b1;
         reg_dest_87    <= 1'b1;       // destination register is rd
         imm_as_reg_87  <= 1'b1;
         alu_op_87      <= 2'b10;
      end else begin
         // TODO - handle this somehow. Or not.
      end
   end
end

endmodule // ctrl_unit