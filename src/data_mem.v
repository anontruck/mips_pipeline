////////////////////////////////////////////////////////////////////////////////
// Module: data_mem.v
// Project: SJSU EE275 Mini Project 2
// Description: Data memory unit
//
// Name: Zach Smith 
// Student ID: 007159087
//
// Note: RAM module is from OpenCores Versatile Library:
//       https://opencores.org/projects/versatile_library
//
////////////////////////////////////////////////////////////////////////////////
`include "mips_defs.vh"

module data_mem(
   output reg [`DATA_WIDTH-1:0] rd_data_87,
   input wire [`ADDR_WIDTH-1:0] rd_addr_87,
   input wire [`ADDR_WIDTH-1:0] wb_addr_87,
   input wire [`DATA_WIDTH-1:0] wb_data_87,
   input wire cs_87, // chip select
   input wire we_87, // write enable
   input wire rst_87,
   input wire clk_87
);
parameter data_file = `ifdef DATA_FILE `DATA_FILE `else "data_mem.mem" `endif;

wire [`DATA_WIDTH-1:0] data_87;
wire [`ADDR_WIDTH-1:0] addr_87 = we_87 ? wb_addr_87 >> 2 : rd_addr_87 >> 2;
wire write_e_87 = we_87 && cs_87;

//assign rd_data_87 = (!we_87 && cs_87) ? data_87 : `DATA_WIDTH'bz;

vl_ram #(.memory_file(data_file), 
`ifdef DEBUG_TRACE
         .debug(1),
`endif
         .memory_init(1),
         .mem_size('d`ADDR_WIDTH * 4),
         .data_width(32'd`DATA_WIDTH),
         .addr_width(32'd`ADDR_WIDTH))
         dram (
               .d(wb_data_87),
               .adr(addr_87),
               .we(write_e_87),
               .q(data_87),
               .clk(clk_87)
         );

always @(*) begin
   if (rst_87)
      rd_data_87 <= 0;
   else if (cs_87)
      rd_data_87 <= data_87;
end

endmodule // data_mem