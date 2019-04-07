////////////////////////////////////////////////////////////////////////////////
// Module:  write_back.v
// Project: SJSU EE275 Mini Project 2
// Description: write back stage module
//
// Name: Zach Smith 
// Student ID: 007159087
//
// Note:
//
////////////////////////////////////////////////////////////////////////////////
`include "mips_defs.vh"

module write_back(
   output wire reg_write_out_87,
   output wire [`DATA_WIDTH-1:0] wb_data_87,
   output wire [`FIELD_WIDTH_RSTD-1:0] wb_reg_out_87,

   input wire reg_write_in_87,
   input wire mem_2_reg_in_87,
   input wire [`DATA_WIDTH-1:0] mem_data_in_87,
   input wire [`ADDR_WIDTH-1:0] mem_addr_in_87,
   input wire [`FIELD_WIDTH_RSTD-1:0] wb_reg_in_87,
   input wire rst_87,
   input wire clk_87
);

assign reg_write_out_87 = reg_write_in_87;
assign wb_data_87 = mem_2_reg_in_87 ? mem_data_in_87 : mem_addr_in_87;
assign wb_reg_out_87 = wb_reg_out_87;

always @(posedge clk_87) begin
   if (rst_87) begin
   end else begin
   end
end

endmodule // write_back