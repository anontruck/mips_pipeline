////////////////////////////////////////////////////////////////////////////////
// Module: alu.v
// Project: SJSU EE275 Mini Project 2
// Description:
//
// Name: Zach Smith 
// Student ID: 007159087
//
// Notes:
//
////////////////////////////////////////////////////////////////////////////////
`include "mips_defs.vh"
`include "alu.vh"

module alu (
   output reg  [`DATA_WIDTH-1:0] rslt_87,
   output wire                   zero_87,
   //output reg                    cout_87,
   //output reg                    overflow_87,
   input wire  [`DATA_WIDTH-1:0] arg_a_87,
   input wire  [`DATA_WIDTH-1:0] arg_b_87,
   input wire  [3:0]             alu_op_87,
   input wire en_87
);

reg valid_87;
wire signed [`DATA_WIDTH-1:0] arg_a_signed_87 = $signed(arg_a_87);
wire signed [`DATA_WIDTH-1:0] arg_b_signed_87 = $signed(arg_b_87);

assign zero_87 = valid_87 ? ((rslt_87 == 0) ? 1'b1 : 1'b0) : 1'b0;

always @(*) begin
   valid_87 <= 1'b1;
   if (en_87 == 1'b1) begin
      if (alu_op_87 == `ALU_ADD) begin
         rslt_87 <= arg_a_signed_87 + arg_b_signed_87;
      end else if (alu_op_87 == `ALU_ADDU) begin
         rslt_87 <= arg_a_87 + arg_b_87;
      end else if (alu_op_87 == `ALU_SUB) begin
         rslt_87 <= arg_a_signed_87 - arg_b_signed_87;
      end else if (alu_op_87 == `ALU_SUBU) begin
         rslt_87 <= arg_a_87 - arg_b_87;
      end else if (alu_op_87 == `ALU_AND) begin
         rslt_87 <= arg_a_87 & arg_b_87;
      end else if (alu_op_87 == `ALU_OR) begin
         rslt_87 <= arg_a_87 | arg_b_87;
      end else if (alu_op_87 == `ALU_SLT) begin
         rslt_87 <= (arg_a_signed_87 < arg_b_signed_87) ? arg_a_87 : 0;
      end else if (alu_op_87 == `ALU_SLTU) begin
         rslt_87 <= (arg_a_87 < arg_b_87) ? arg_a_87 : 0;
      end else if (alu_op_87 == `ALU_MULT) begin
         rslt_87 <= arg_a_signed_87 * arg_b_signed_87;
      end else if (alu_op_87 == `ALU_MULTU) begin
         rslt_87 <= arg_a_87 * arg_b_87;
      end else if (alu_op_87 == `ALU_DIV) begin
         rslt_87 <= arg_a_signed_87 / arg_b_signed_87;
      end else if (alu_op_87 == `ALU_DIVU) begin
         rslt_87 <= arg_a_87 / arg_b_87;
      end else if (alu_op_87 == `ALU_SLL) begin
         rslt_87 <= arg_a_87 << arg_b_87;
      end else if (alu_op_87 == `ALU_SRL) begin
         rslt_87 <= arg_a_87 >> arg_b_87;
      end else begin
         valid_87 <= 1'b0;
      end
   end else begin
      rslt_87 <= 0;
      valid_87 <= 1'b0;
   end
end

endmodule // alu