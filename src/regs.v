////////////////////////////////////////////////////////////////////////////////
// Module: regs.v
// Project: SJSU EE275 Mini Project 2
// Description: MIPS registers
//
// Name: Zach Smith 
// Student ID: 007159087
//
////////////////////////////////////////////////////////////////////////////////
`include "mips_defs.vh"

module regs(
   output reg  [`DATA_WIDTH-1:0]          read_data_1_87,
   output reg  [`DATA_WIDTH-1:0]          read_data_2_87,
   input wire  [`FIELD_WIDTH_RSTD-1:0]    read_reg_1_87,    // rt
   input wire  [`FIELD_WIDTH_RSTD-1:0]    read_reg_2_87,    // rd
   input wire  [`FIELD_WIDTH_RSTD-1:0]    write_reg_87,     // rs
   input wire  [`DATA_WIDTH-1:0]          write_data_87,
   input wire                             we_87,            // write enable
   input wire                             rst_87,
   input wire                             clk_87
);
parameter REG_COUNT = 32;
integer i;  // iterator
reg [`REG_WIDTH-1:0] regs_87 [0:REG_COUNT-1];

// store data on rising edges - first half of clock cycle
always @(posedge clk_87 or posedge rst_87) begin
   if (rst_87) begin

      for (i=0; i<REG_COUNT; i=i+1)
         regs_87[i] <= `REG_WIDTH'b0;
         
      read_data_1_87 <= `REG_WIDTH'b0;
      read_data_2_87 <= `REG_WIDTH'b0;
   end else if (we_87) begin
      // don't allow writes to r0
      regs_87[write_reg_87] <= write_reg_87 ? write_data_87 : `REG_WIDTH'b0;
   end
end

// read data on falling edges - second half of clock cycle
always @(negedge clk_87) begin
   if (!rst_87) begin
      read_data_1_87 <= regs_87[read_reg_1_87];
      read_data_2_87 <= regs_87[read_reg_2_87];
   end
end

`ifdef DEBUG_TRACE
always @(posedge clk_87) begin
   if (!rst_87 && we_87 && (write_reg_87 == 0))
      $strobe($time,,,"IF: Attempted to write to $r0");
end
`endif

endmodule // regs