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
   output reg  [`DATA_WIDTH-1:0] result_87,
   output wire zero_87,
   input wire  [`DATA_WIDTH-1:0] arg_a_87,
   input wire  [`DATA_WIDTH-1:0] arg_b_87,
   input wire  [1:0] op_87,
   input wire  [`FIELD_WIDTH_FUNC-1:0] fcn_87    // function code
);

assign zero_87 = (result_87 == `DATA_WIDTH'b0);

always @(*) begin
end

endmodule // alu