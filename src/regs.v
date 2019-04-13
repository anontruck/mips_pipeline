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
   output reg  [`DATA_WIDTH-1:0]    read_data_1_87,
   output reg  [`DATA_WIDTH-1:0]    read_data_2_87,
   input wire  [`RADDR_WIDTH-1:0]   read_reg_1_87,    // rt
   input wire  [`RADDR_WIDTH-1:0]   read_reg_2_87,    // rd
   input wire  [`RADDR_WIDTH-1:0]   write_reg_87,     // rs
   input wire  [`DATA_WIDTH-1:0]    write_data_87,
   input wire                       we_87,            // write enable
   input wire                       rst_87,
   input wire                       clk_87
);
parameter REG_COUNT = 32;
parameter INIT_REGS = 0;
parameter REG_FILE = "reg.mem";

integer i;  // itterator
reg [`REG_WIDTH-1:0] regs_87 [0:REG_COUNT-1];
reg [`REG_WIDTH-1:0] init_87 [0:REG_COUNT-1];   // store if we read from a file

generate
initial begin
   if (INIT_REGS == 1) begin
      $readmemh(REG_FILE, init_87);
      init_registers;
   end else begin
      clear_registers;
   end
end
endgenerate

// store data on rising edges - first half of clock cycle
always @(posedge clk_87 or posedge rst_87) begin
   if (rst_87) begin
      init_registers;         
   end else if (we_87 && (write_reg_87 != 0)) begin
      regs_87[write_reg_87] <= write_data_87;
   end
end

// read data on falling edges - second half of clock cycle
always @(negedge clk_87) begin
   if (rst_87) begin
      read_data_1_87 <= `REG_WIDTH'b0;
      read_data_2_87 <= `REG_WIDTH'b0;
   end else begin
      read_data_1_87 <= regs_87[read_reg_1_87];
      read_data_2_87 <= regs_87[read_reg_2_87];
   end
end

task clear_registers;
   for (i=0; i<REG_COUNT; i=i+1)
      regs_87[i] <= `REG_WIDTH'b0;
endtask

task init_registers;
   if (INIT_REGS)
      for (i=0; i<REG_COUNT; i=i+1)
         regs_87[i] <= init_87[i];
   else
      clear_registers;
endtask


`ifdef DEBUG_TRACE

wire signed [`DATA_WIDTH-1:0] reg_out_1_87 = regs_87[read_reg_1_87];
wire signed [`DATA_WIDTH-1:0] reg_out_2_87 = regs_87[read_reg_2_87];

always @(posedge clk_87) begin
   if (rst_87) begin
      $strobe($time,,,"RM: RESET");
   end else if (we_87 == 1'b1 && write_reg_87 != 0) begin
         //$strobe($time,,,"RM: WRITE $r%0d<-%0d", write_reg_87, write_data_87);
         $display($time,,,"RM: WRITE $r%0d<-%0d", write_reg_87, write_data_87);
   end
end

always @(negedge clk_87) begin
   if (!rst_87) begin
      //$strobe($time,,,"RM: READ $r%0d->%0d $r%0d->%0d", read_reg_1_87, reg_out_1_87,
      //read_reg_2_87, reg_out_2_87);
      $display($time,,,"RM: READ $r%0d->%0d $r%0d->%0d", read_reg_1_87, reg_out_1_87,
      read_reg_2_87, reg_out_2_87);
   end
end

`endif // DEBUG_TRACE

endmodule // regs