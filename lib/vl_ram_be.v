//////////////////////////////////////////////////////////////////////
////                                                              ////
////  Versatile library, registers                                ////
////                                                              ////
////  Description                                                 ////
////  Different type of registers                                 ////
////                                                              ////
////                                                              ////
////  To Do:                                                      ////
////   - add more different registers                             ////
////                                                              ////
////  Author(s):                                                  ////
////      - Michael Unneback, unneback@opencores.org              ////
////        ORSoC AB                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2010 Authors and OPENCORES.ORG                 ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE.  See the GNU Lesser General Public License for more ////
//// details.                                                     ////
////                                                              ////
//// You should have received a copy of the GNU Lesser General    ////
//// Public License along with this source; if not, download it   ////
//// from http://www.opencores.org/lgpl.shtml                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

// Single port RAM with byte enable
module vl_ram_be ( d, adr, be, we, q, clk);


   parameter data_width = 32;
   parameter addr_width = 6;
   parameter mem_size = 1<<addr_width;
   input [(data_width-1):0]      d;
   input [(addr_width-1):0] 	 adr;
   input [(data_width >> 3)-1:0]    be;
   input 			 we;
   output reg [(data_width-1):0] q;
   input 			 clk;

    
`ifdef SYSTEMVERILOG
    // use a multi-dimensional packed array
    //t o model individual bytes within the word
    logic [(data_width >> 3)-1:0][7:0] ram [0:mem_size-1];// # words = 1 << address width
`else
    //reg [data_width-1:0] ram [mem_size-1:0];
    reg [data_width-1:0] ram [0:mem_size-1];
    wire [(data_width >> 3)-1:0] cke;
`endif

    parameter memory_init = 0;
    parameter memory_file = "vl_ram.vmem";
    generate
    if (memory_init == 1) begin : init_mem
        initial begin
            $readmemh(memory_file, ram);
        end
    end else if (memory_init == 2) begin : init_zero
        integer k;
        initial
            for (k = 0; k < mem_size; k = k + 1)
                ram[k] = 0;
    end
   endgenerate 

`ifdef SYSTEMVERILOG

always_ff@(posedge clk)
begin
    if(we) begin
        if(be[3]) ram[adr][3] <= d[31:24];
        if(be[2]) ram[adr][2] <= d[23:16];
        if(be[1]) ram[adr][1] <= d[15:8];
        if(be[0]) ram[adr][0] <= d[7:0];
    end
        q <= ram[adr];
end

`else

assign cke = {data_width/8{we}} & be;
   genvar i;
   generate for (i=0;i<data_width/8;i=i+1) begin : be_ram
      always @ (posedge clk)
      if (cke[i])
        ram[adr][(i+1)*8-1:i*8] <= d[(i+1)*8-1:i*8];
   end
   endgenerate

   always @ (posedge clk)
      q <= ram[adr];

`endif

`ifdef verilator
   // Function to access RAM (for use by Verilator).
   function [31:0] get_mem;
      // verilator public
      input [addr_width-1:0] 		addr;
      get_mem = ram[addr];
   endfunction // get_mem

   // Function to write RAM (for use by Verilator).
   function set_mem;
      // verilator public
      input [addr_width-1:0] 		addr;
      input [data_width-1:0] 		data;
      ram[addr] = data;
   endfunction // set_mem
`endif

endmodule