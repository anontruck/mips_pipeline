////////////////////////////////////////////////////////////////////////////////
// File:  mips_defs.vh
// Project: SJSU EE275 Mini Project 2
// Description: Defines macros defining data widths, opcodes, and function codes
//
// Name: Zach Smith 
// Student ID: 007159087
//
// Note: There are more definitions than what's needed for this project.
//
////////////////////////////////////////////////////////////////////////////////
`ifndef _MIPS_DEFS_VH
`define _MIPS_DEFS_VH

`define INSTR_WIDTH        32
`define ADDR_WIDTH         32
`define DATA_WIDTH         32
`define REG_WIDTH          32

`define FIELD_WIDTH_OP     6
`define FILED_WIDTH_FUNC   6
`define FIELD_WIDTH_SHAMT  5
`define FIELD_WIDTH_IMM    16
`define FIELD_WIDTH_RSTD   5
`define FIELD_WIDTH_OFF    26

/* ========================= O P C O D E S ================================== */

`define OPCODE_ADD         6'b000000   // add
`define OPCODE_ADDU        6'b000000   // add unsigned 
`define OPCODE_ADDI        6'b001000   // add immediate
`define OPCODE_ADDIU       6'b001001   // add immediate unsigned
`define OPCODE_SUB         6'b000000   // subtract
`define OPCODE_SUBU        6'b000000   // subtracut unsigned
`define OPCODE_MULT        6'b000000   // multiply
`define OPCODE_MULTU       6'b000000   // multiply unsigned
`define OPCODE_DIV         6'b000000   // divide
`define OPCODE_DIVU        6'b000000   // divide unsigned
`define OPCODE_MFHI        6'b000000   // move from HI
`define OPCODE_MFLO        6'b000000   // move from LO
`define OPCODE_MTHI        6'b000000   // move to HI
`define OPCODE_MTLO        6'b000000   // move to LO
`define OPCODE_AND         6'b000000   // logical AND
`define OPCODE_ANDI        6'b001100   // logical AND immediate
`define OPCODE_OR          6'b000000   // logical OR
`define OPCODE_ORI         6'b001101   // logical OR immediate
`define OPCODE_NOR         6'b000000   // logical NOR
`define OPCODE_XOR         6'b000000   // logical XOR
`define OPCODE_XORI        6'b001110   // logical XOR immediate
`define OPCODE_SLL         6'b000000   // shift left logical
`define OPCODE_SRL         6'b000000   // shift right logical
`define OPCODE_SLT         6'b000000   // set if less than
`define OPCODE_SLTI        6'b001010   // set if less than immediate
`define OPCODE_SLTIU       6'b001101   // set if less than immediate unsigned
`define OPCODE_SLTU        6'b000000   // set if less than unsigned
`define OPCODE_LUI         6'b000000   // load upper immediate
`define OPCODE_LB          6'b100000   // load byte
`define OPCODE_LBU         6'b100101   // load byte unsigned
`define OPCODE_LH          6'b100001   // load halfword
`define OPCODE_LW          6'b100011   // load word
`define OPCODE_SB          6'b101000   // store byte
`define OPCODE_SH          6'b101001   // store halfword
`define OPCODE_SW          6'b101011   // store word
`define OPCODE_BEQ         6'b000100   // branch if equal
`define OPCODE_BNE         6'b000101   // branch if NOT equal
`define OPCODE_J           6'b000010   // jump   
`define OPCODE_JAL         6'b000011   // jump and link - used for calls
`define OPCODE_JR          6'b000000   // jump register - used for returns 


/* ===================== F U N C T I O N  C O D E S ========================  */

`define FUNC_ADD           6'b100000   // add
`define FUNC_ADDU          6'b100001   // add unsigned
`define FUNC_SUB           6'b100100   // sub
`define FUNC_SUBU          6'b100011   // sub unsigned
`define FUNC_MULT          6'b011000   // multiply
`define FUNC_MULTU         6'b011001   // multiply unsigned
`define FUNC_DIV           6'b011010   // divide
`define FUNC_DIVU          6'b011011   // divide unsigned
`define FUNC_MFHI          6'b010000   // move from HI
`define FUNC_MFLO          6'b010010   // move from LO
`define FUNC_MTHI          6'b010001   // move to HI
`define FUNC_MTLO          6'b010011   // move to LO
`define FUNC_AND           6'b100100   // logical AND
`define FUNC_OR            6'b100101   // logical OR
`define FUNC_NOR           6'b100111   // logical NOR
`define FUNC_XOR           6'b100110   // logical XOR
`define FUNC_SLL           6'b000000   // shift left logical
`define FUNC_SRL           6'b000010   // shift right logical
`define FUNC_SLT           6'b101010   // set if less than
`define FUNC_SLTU          6'b101011   // set if less than unsigned
`define FUNC_JR            6'b001000   // jump register


`endif //_MIPS_DEFS_VH