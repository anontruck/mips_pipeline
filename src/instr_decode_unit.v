////////////////////////////////////////////////////////////////////////////////
// Module: instr_decond_unit.v
// Project: SJSU EE275 Mini Project 2
// Description: Instruction decode unit. 
//
// Name: Zach Smith 
// Student ID: 007159087
//
////////////////////////////////////////////////////////////////////////////////
`include "mips_defs.vh"

`define DEBUG_TRACE

module instr_decode_unit (
   output reg                                reg_write_87,        // control signals
   output reg                                mem_to_reg_87,
   output reg                                branch_87,
   output reg                                jump_87,
   output reg                                mem_read_87,
   output reg                                mem_write_87,
   output reg                                alu_src_87,
   output reg  [                  3 : 0   ]  alu_op_87,
   output reg  [`DATA_WIDTH      -1 : 0   ]  data_read_1_87,   // read data outputs
   output reg  [`DATA_WIDTH      -1 : 0   ]  data_read_2_87,
   output reg  [`DATA_WIDTH      -1 : 0   ]  immd_87,          // sign extended immediate
   output reg  [`FIELD_WIDTH_SHAMT-1: 0   ]  shamt_87,
   output reg  [`FIELD_WIDTH_OP  -1 : 0   ]  op_87,
   output reg  [`FIELD_WIDTH_OP  -1 : 0   ]  fn_87,
   output reg  [`FIELD_WIDTH_RSTD-1 : 0   ]  rt_87,
   output reg  [`FIELD_WIDTH_RSTD-1 : 0   ]  rd_87,
   output reg  [`ADDR_WIDTH      -1 : 0   ]  pc_out_87,
   input wire  [`ADDR_WIDTH      -1 : 0   ]  pc_in_87,
   input wire  [`INSTR_WIDTH     -1 : 0   ]  instr_87,
   input wire  [`FIELD_WIDTH_RSTD-1 : 0   ]  reg_2_write_87,   // register to write to
   input wire  [`DATA_WIDTH      -1 : 0   ]  data_2_write_87,  // data to write
   input wire                                en_wb_87,         // enable write-back
   input wire                                rst_87,
   input wire                                clk_87
);

wire [3:0] ctrl_alu_op_87;
wire [`DATA_WIDTH-1:0]  reg_data_1_87,
                        reg_data_2_87;

wire  ctrl_reg_wb_87,
      ctrl_reg_dst_87,
      ctrl_alu_src_87,
      ctrl_branch_87,
      ctrl_jump_87,
      ctrl_mem_read_87,
      ctrl_mem_write_87,
      ctrl_mem_to_reg_87;

// register control module
regs regs (
   .read_data_1_87   (  reg_data_1_87  ),
   .read_data_2_87   (  reg_data_2_87  ),
   .read_reg_1_87    (       rt_87     ),
   .read_reg_2_87    (       rd_87     ),
   .write_reg_87     (  reg_2_write_87 ),
   .write_data_87    ( data_2_write_87 ),
   .we_87            (     en_wb_87    ),
   .rst_87           (       rst_87    ),
   .clk_87           (       clk_87    )
);

// control unit
ctrl_unit ctrl_unit (
   .reg_wb_87        (  ctrl_reg_wb_87    ),
   .reg_dst_87       (  ctrl_reg_dst_87   ),
   .alu_src_87       (  ctrl_alu_src_87   ),
   .branch_87        (  ctrl_branch_87    ),
   .jump_87          (  ctrl_jump_87      ),
   .mem_read_87      (  ctrl_mem_read_87  ),
   .mem_write_87     (  ctrl_mem_write_87 ),
   .mem_to_reg_87    (  ctrl_mem_to_reg_87),
   .alu_op_87        (  ctrl_alu_op_87    ),
   .op_87            (        op_87       )
);

// TODO - add stall control input. If set, pc remains unchanged
//always @(posedge clk_87 or posedge rst_87) begin
   //if (rst_87) begin
   //end else begin
   //end
//end

always @(*) begin
   immd_87        <= {{`FIELD_WIDTH_IMM{instr_87[`FIELD_WIDTH_IMM-1]}}, instr_87[`FIELD_WIDTH_IMM-1:0]}; 
   shamt_87       <= instr_87[`FIELD_WIDTH_SHAMT+`FIELD_POS_SHFT-1:`FIELD_POS_SHFT];
   data_read_1_87 <= reg_data_1_87;
   data_read_2_87 <= reg_data_2_87;
   reg_write_87   <= ctrl_reg_wb_87;
   mem_to_reg_87  <= ctrl_mem_to_reg_87;
   branch_87      <= ctrl_branch_87;
   jump_87        <= ctrl_jump_87;
   mem_read_87    <= ctrl_mem_read_87;
   mem_write_87   <= ctrl_mem_write_87;
   alu_src_87     <= ctrl_alu_src_87;
   alu_op_87      <= ctrl_alu_op_87;
   rt_87          <= instr_87[`FIELD_POS_RT+`FIELD_WIDTH_RSTD-1:`FIELD_POS_RT];
   rd_87          <= instr_87[`FIELD_POS_RD+`FIELD_WIDTH_RSTD-1:`FIELD_POS_RD];
   op_87          <= instr_87[`FIELD_POS_OP+`FIELD_WIDTH_OP-1:`FIELD_POS_OP];
   fn_87          <= instr_87[`FIELD_POS_FUNC+`FIELD_WIDTH_FUNC-1:`FIELD_POS_FUNC];
end

`ifdef DEBUG_TRACE
   wire [`FIELD_WIDTH_RSTD-1:0] rs_87 = instr_87[`FIELD_POS_RS+`FIELD_WIDTH_RSTD-1:`FIELD_POS_RS];
   always @(posedge clk_87 or posedge rst_87) begin
      if (rst_87) begin
         $display($time,,,"...reset...");
      end else if (op_87 == `OPCODE_R) begin
         case (fn_87)
            `FUNC_SLL   : $display($time,,,"ID: SLL\t$%0d, $%0d, $%0d", rd_87, rt_87, 0);
            `FUNC_SRL   : $display($time,,,"ID: SRL\t$%0d, $%0d, $%0d", rd_87, rt_87, 0);
            `FUNC_JR    : $display($time,,,"ID: JR\t$%0d", 0);
            `FUNC_ADDU  : $display($time,,,"ID: ADDU\t$%0d, $%0d, $%0d", rd_87, rs_87, rt_87);
            `FUNC_MULT  : $display($time,,,"ID: MULT\t$%0d, $%0d, $%0d", rd_87, rs_87, rt_87);
            default     : $display($time,,,"ID: UNKNOWN R-TYPE FUNCTION");
         endcase
      end else if (op_87 == `OPCODE_J) begin
         $display($time,,,"ID: J\t%0d", 0);
      end else begin
         case (op_87)
            `OPCODE_ADDIU  : $display($time,,,"ID: ADDIU\t$%0d, $%0d, $%0d", rd_87, rs_87, $signed(immd_87));
            `OPCODE_LW     : $display($time,,,"ID: LW\t$%0d, %0d($%0d)", rt_87, $signed(immd_87), rs_87);
            `OPCODE_BEQ    : $display($time,,,"ID: BEQ\t$%0d, $%0d, %0d", rs_87, rt_87, $signed(immd_87));
            default        : $display($time,,,"ID: UNKNOWN I-TYPE FUNCTION");
         endcase
      end
   end
`endif

endmodule // instr_decode_unit