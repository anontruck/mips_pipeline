////////////////////////////////////////////////////////////////////////////////
// Module:  mips_pipeline_tb.v
// Project: SJSU EE275 Mini Project 2
// Description: Test bench
//
// Name: Zach Smith 
// Student ID: 007159087
//
// Note:
//
////////////////////////////////////////////////////////////////////////////////
`include "mips_defs.vh"

module mips_pipeline_tb();

wire [`INSTR_WIDTH-1:0] instr_87;
wire [`ADDR_WIDTH-1:0] addr_87;

reg clk_87, rst_87;

instr_fetch_unit ifu (
   .instr_87(instr_87),
   .pc_87(addr_87),
   .npc_87('b0),
   .sel_87(1'b0),
   .rst_87(rst_87),
   .clk_87(clk_87)
);

initial begin
   rst_87 = 1'b1;
   clk_87 = 1'b0;
   $dumpfile("../build/bin/dump.vcd");
   $dumpvars;  // dump em all

   #2 rst_87 = 1'b0;

   $monitor($time,,,"%h %h", instr_87, addr_87);
   #12
   $finish;
end

//always #1 clk_87 <= ~clk_87;
initial forever #1 clk_87 <= ~clk_87;

endmodule // mips_pipeline_tb