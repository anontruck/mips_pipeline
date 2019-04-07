////////////////////////////////////////////////////////////////////////////////
// Module: mem.v
// Project: SJSU EE275 Mini Project 2
// Description: memory pipeline stage. 
//
// Name: Zach Smith 
// Student ID: 007159087
//
////////////////////////////////////////////////////////////////////////////////
`include "mips_defs.vh"

module mem(
   output wire branch_taken_87,                       // async - flag to take branch
   output wire [`ADDR_WIDTH-1:0] branch_adr_out_87,   // async - branch address

   output reg [`DATA_WIDTH-1:0] rd_data_87,           // data read from memory
   output reg [`ADDR_WIDTH-1:0] wb_addr_87,           // write-back address
   output reg [`FIELD_WIDTH_RSTD-1:0] wb_reg_out_87,  // feed-through
   output reg mem_2_reg_out_87,
   output reg [`ADDR_WIDTH-1:0] pc_out_87,

   input wire [`ADDR_WIDTH-1:0] pc_in_87,
   input wire [`DATA_WIDTH-1:0] wb_data_87,           // write-back data
   input wire [`ADDR_WIDTH-1:0] rd_addr_87,           // memory read address
   input wire [`DATA_WIDTH-1:0] branch_adr_in_87,     // branch address feed-through
   input wire [`FIELD_WIDTH_RSTD-1:0] wb_reg_in_87,   // feed-through
   input wire mem_read_87,                            // read memory control flag
   input wire mem_write_87,                           // write memory control flag
   input wire mem_2_reg_in_87,
   input wire branch_in_87,                           // branch control flag
   input wire zero_flag_87,                           // ALU zero out signal
   input wire rst_87,
   input wire clk_87
);

wire [`DATA_WIDTH-1:0] mem_out_87;

wire we_87 = mem_write_87 && !mem_read_87;
wire cs_87 = mem_write_87 || mem_read_87;

assign branch_taken_87 = branch_in_87 && zero_flag_87;
assign branch_adr_out_87 = branch_adr_in_87;

data_mem dmem (
               .rd_data_87(mem_out_87),
               .rd_addr_87(rd_addr_87),
               .wb_addr_87(wb_addr_87),
               .wb_data_87(wb_data_87),
               .cs_87(cs_87),
               .we_87(we_87),
               .rst_87(rst_87),
               .clk_87(clk_87)
);

always @(posedge clk_87) begin
   if (rst_87) begin
      pc_out_87 <= 0;
   end else begin
      pc_out_87 <= pc_in_87;
      rd_data_87 <= mem_out_87;
      wb_addr_87 <= rd_addr_87;
      wb_reg_out_87 <= wb_reg_in_87;
      mem_2_reg_out_87 <= mem_2_reg_in_87;
   end
end


endmodule // mem