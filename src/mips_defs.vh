////////////////////////////////////////////////////////////////////////////////
// File:  mips_defs.vh
// Project: SJSU EE275 Mini Project 2
// Description: Defines macros defining data widths, opcodes, function codes,
//              anything needed globally.
//
// Name: Zach Smith 
// Student ID: 007159087
//
// Note: There are more definitions than what's needed for this project.
//
////////////////////////////////////////////////////////////////////////////////
`ifndef _MIPS_DEFS_VH
`define _MIPS_DEFS_VH

/* ========================== C O N S T A N T S ============================= */

`define INSTR_WIDTH        32
`define ADDR_WIDTH         32
`define DATA_WIDTH         32
`define REG_WIDTH          32

`define FIELD_WIDTH_OP     6
`define FIELD_WIDTH_FUNC   6
`define FIELD_WIDTH_SHAMT  5
`define FIELD_WIDTH_IMM    16
`define FIELD_WIDTH_RSTD   5
`define FIELD_WIDTH_OFF    26

`define FIELD_POS_OP       26
`define FIELD_POS_RS       21
`define FIELD_POS_RT       16
`define FIELD_POS_RD       11
`define FIELD_POS_SHFT     6
`define FIELD_POS_IMMD     0
`define FIELD_POS_FUNC     0

/* ========================= O P C O D E S ================================== */

`define OPCODE_R           6'b000000
`define OPCODE_J           6'b000010   // jump   

`define OPCODE_ADDI        6'b001000   // add immediate
`define OPCODE_ADDIU       6'b001001   // add immediate unsigned
`define OPCODE_ANDI        6'b001100   // logical AND immediate
`define OPCODE_ORI         6'b001101   // logical OR immediate
//`define OPCODE_XORI        6'b001110   // logical XOR immediate
`define OPCODE_SLTI        6'b001010   // set if less than immediate
`define OPCODE_SLTIU       6'b001011   // set if less than immediate unsigned
//`define OPCODE_LB          6'b100000   // load byte
//`define OPCODE_LBU         6'b100101   // load byte unsigned
//`define OPCODE_LUI         6'b001111   // load upper immediate
//`define OPCODE_LH          6'b100001   // load halfword
`define OPCODE_LW          6'b100011   // load word
//`define OPCODE_SB          6'b101000   // store byte
//`define OPCODE_SH          6'b101001   // store halfword
`define OPCODE_SW          6'b101011   // store word
`define OPCODE_BEQ         6'b000100   // branch if equal
`define OPCODE_BNE         6'b000101   // branch if NOT equal
//`define OPCODE_JAL         6'b000011   // jump and link - used for calls
`define OPCODE_MUL         6'b011100   // multiply

/* ===================== F U N C T I O N  C O D E S ========================  */

`define FUNC_SLL           6'b000100   // shift left logical
`define FUNC_SRL           6'b000010   // shift right logical
`define FUNC_JR            6'b001000   // jump register
//`define FUNC_JALR          6'b001001   // jump and link register
//`define FUNC_SYSCALL       6'b001100   // system call
//`define FUNC_MFHI          6'b010000   // move from HI
//`define FUNC_MFLO          6'b010010   // move from LO
//`define FUNC_MTHI          6'b010001   // move to HI
//`define FUNC_MTLO          6'b010011   // move to LO
`define FUNC_MULT          6'b011000   // multiply
`define FUNC_MULTU         6'b011001   // multiply unsigned
`define FUNC_DIV           6'b011010   // divide
`define FUNC_DIVU          6'b011011   // divide unsigned
`define FUNC_ADD           6'b100000   // add
`define FUNC_ADDU          6'b100001   // add unsigned
`define FUNC_SUB           6'b100010   // sub
`define FUNC_SUBU          6'b100011   // sub unsigned
`define FUNC_AND           6'b100100   // bitwise AND
`define FUNC_OR            6'b100101   // bitwise OR
//`define FUNC_XOR           6'b100110   // bitwise XOR
`define FUNC_SLT           6'b101010   // set if less than
`define FUNC_SLTU          6'b101011   // set if less than unsigned

`endif //_MIPS_DEFS_VH