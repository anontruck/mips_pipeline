////////////////////////////////////////////////////////////////////////////////
// File:  alu.vh
// Project: SJSU EE275 Mini Project 2
// Description:
//
// Name: Zach Smith 
// Student ID: 007159087
//
// Notes:
//
////////////////////////////////////////////////////////////////////////////////
`ifndef _ALU_VH
`define _ALU_VH

`define ALU_ADD   4'b0000
`define ALU_ADDU  4'b0001
`define ALU_SUB   4'b0010
`define ALU_SUBU  4'b0011
`define ALU_AND   4'b0100
`define ALU_OR    4'b0101
`define ALU_SLT   4'b0110
`define ALU_SLTU  4'b0111
`define ALU_MULT  4'b1000
`define ALU_MULTU 4'b1001
`define ALU_DIV   4'b1010
`define ALU_DIVU  4'b1011
`define ALU_SLL   4'b1100
`define ALU_SRL   4'b1101

`endif // _ALU_VH