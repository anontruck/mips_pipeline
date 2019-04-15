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
   output reg mem_2_reg_out_87,
   output reg reg_write_out_87,
   output reg [`DATA_WIDTH-1:0] mem_data_out_87,      // data read from memory
   output reg [`ADDR_WIDTH-1:0] mem_addr_out_87,      // write-back address feed-through
   output reg [`RADDR_WIDTH-1:0] reg_addr_out_87,     // feed-through

   input wire [`DATA_WIDTH-1:0] mem_data_in_87,       // write-back data
   input wire [`ADDR_WIDTH-1:0] mem_addr_in_87,       // memory read address
   input wire [`RADDR_WIDTH-1:0] reg_addr_in_87,      // feed-through
   input wire reg_write_in_87,
   input wire mem_read_in_87,                         // read memory control flag
   input wire mem_write_in_87,                        // write memory control flag
   input wire mem_2_reg_in_87,
   input wire rst_87,
   input wire clk_87
);

reg we_87;
reg cs_87; 

wire [`DATA_WIDTH-1:0] mem_out_87;

data_mem dmem (
               .rd_data_87 (mem_out_87),

               .rd_addr_87 (mem_addr_in_87),
               .wb_addr_87 (mem_addr_in_87),
               .wb_data_87 (mem_data_in_87),
               .cs_87      (cs_87),
               .we_87      (we_87),
               .rst_87     (rst_87),
               .clk_87     (clk_87)
);

always @(*) begin
   if (rst_87)
      mem_data_out_87 <= 0;
   else if (cs_87)
      mem_data_out_87 <= mem_out_87;
end

always @(posedge clk_87) begin
   if (rst_87) begin
      we_87 <= 0;
      cs_87 <= 0;
      reg_addr_out_87   <= 0;
      reg_write_out_87  <= 0;
      mem_addr_out_87   <= 0;
      mem_2_reg_out_87  <= 0;
   end else begin
      we_87 <= mem_write_in_87 && !mem_read_in_87;
      cs_87 <= mem_write_in_87 || mem_read_in_87;
      mem_addr_out_87 <= mem_addr_in_87;
      reg_addr_out_87 <= reg_addr_in_87;
      reg_write_out_87 <= reg_write_in_87;
      mem_2_reg_out_87 <= mem_2_reg_in_87;
   end
end

`ifdef DEBUG_TRACE

always @(posedge clk_87) begin
   if (rst_87) begin
      $strobe($time,,,"MEM: RESET");
   end else if (cs_87) begin
      if (mem_write_in_87) begin
         $strobe($time,,,"MEM: 0x%0h <- %0d", mem_addr_in_87, mem_data_in_87);
      end else if (mem_read_in_87) begin
         $strobe($time,,,"MEM: 0x%0h -> %0d", mem_addr_in_87, mem_data_out_87);
      end
   end
end

`endif

endmodule // mem