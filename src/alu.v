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
   output reg                    zero_87,
   //output reg                    cout_87,
   //output reg                    overflow_87,
   input wire  [`DATA_WIDTH-1:0] arg_a_87,
   input wire  [`DATA_WIDTH-1:0] arg_b_87,
   input wire  [3:0]             alu_op_87
);

//reg [`DATA_WIDTH:0] 

always @(*) begin
   case (alu_op_87)
      `ALU_ADD:
         rslt_87 <= $signed(arg_a_87) + $signed(arg_b_87);
      `ALU_ADDU:
         rslt_87 <= arg_a_87 + arg_b_87;
      `ALU_SUB:
         rslt_87 <= $signed(arg_a_87) - $signed(arg_b_87);
      `ALU_SUBU:
         rslt_87 <= arg_a_87 - arg_b_87;
      `ALU_AND:
         rslt_87 <= arg_a_87 & arg_b_87;
      `ALU_OR:
         rslt_87 <= arg_a_87 | arg_b_87;
      `ALU_SLT:
         rslt_87 <= ($signed(arg_a_87) < $signed(arg_b_87)) ? arg_a_87 : 0;
      `ALU_SLTU:
         rslt_87 <= (arg_a_87 < arg_b_87) ? arg_a_87 : 0;
      `ALU_MULT:
         rslt_87 <= arg_a_87 * arg_b_87;
      `ALU_MULTU:
         rslt_87 <= arg_a_87 * arg_b_87;
      `ALU_DIV:
         rslt_87 <= $signed(arg_a_87) / $signed(arg_b_87);
      `ALU_DIVU:
         rslt_87 <= arg_a_87 / arg_b_87;
      `ALU_SLL:
         rslt_87 <= arg_a_87 << arg_b_87;
      `ALU_SRL:
         rslt_87 <= arg_a_87 >> arg_b_87;
      default:
         rslt_87 <= 0;
   endcase
   zero_87 <= (rslt_87 == `DATA_WIDTH'b0) ? 1'b1 : 1'b0;
end

endmodule // alu