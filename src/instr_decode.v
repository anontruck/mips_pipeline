////////////////////////////////////////////////////////////////////////////////
// Module: instr_decond.v
// Project: SJSU EE275 Mini Project 2
// Description: Instruction decode unit. 
//
// Name: Zach Smith 
// Student ID: 007159087
//
////////////////////////////////////////////////////////////////////////////////
`include "mips_defs.vh"

module instr_decode (
   // control signals
   output reg reg_write_87,                           // register write-back flag
   output reg reg_dst_87,                             // register write-back select
   output reg mem_to_reg_87,                          // register write-back from memory
   output reg branch_87,                              // branch flag
   output reg mem_read_87,                            // read from memory flag
   output reg mem_write_87,                           // memory write-back
   output reg alu_src_87,                             // ALU input source flag
   output reg [1:0] alu_op_87,                        // ALU operation control signal
   output reg [1:0] jump_sel_87,                      // jump address select
   // data outputs
   output reg [`DATA_WIDTH-1:0] data_read_1_87,       // read data outputs
   output reg [`DATA_WIDTH-1:0] data_read_2_87,
   // instruction decoding - TODO probably don't need
   output reg [`DATA_WIDTH-1:0] jump_addr_out_87,     // jump address
   output reg [`DATA_WIDTH-1:0] immd_87,              // sign extended immediate
   output reg [`FIELD_WIDTH_SHAMT-1:0] shamt_87,
   output reg [`FIELD_WIDTH_OP-1:0] op_87,
   output reg [`FIELD_WIDTH_FUNC-1:0] fn_87,
   output reg [`RADDR_WIDTH-1:0] rs_87,
   output reg [`RADDR_WIDTH-1:0] rt_87,
   output reg [`RADDR_WIDTH-1:0] rd_87,
   output reg [`ADDR_WIDTH-1:0] pc_out_87,
   // inputs
   input wire [`ADDR_WIDTH-1:0] pc_in_87,
   input wire [`INSTR_WIDTH-1:0] instr_87,
   input wire [`FIELD_WIDTH_RSTD-1:0] reg_2_write_87, // register to write to
   input wire [`DATA_WIDTH-1:0] data_2_write_87,      // data to write
   input wire en_wb_87,                               // enable write-back
   input wire rst_87,
   input wire clk_87
);

wire imm_as_reg_87;
wire ctrl_reg_wb_87;
wire ctrl_reg_dst_87;
wire ctrl_alu_src_87;
wire ctrl_branch_87;
wire ctrl_mem_read_87;
wire ctrl_mem_write_87;
wire ctrl_mem_to_reg_87;
wire [1:0] ctrl_alu_op_87;
wire [1:0] ctrl_jump_sel_87;
wire [`DATA_WIDTH-1:0] reg_data_1_87;
wire [`DATA_WIDTH-1:0] reg_data_2_87;

reg [`DATA_WIDTH-1:0] data_out_1_87;
reg [`DATA_WIDTH-1:0] data_out_2_87;
reg [`DATA_WIDTH-1:0] immd_out_87;

// instruction decoding
wire [`DATA_WIDTH-1:0] shift_amt_87 = instr_87[`FIELD_WIDTH_SHAMT+`FIELD_POS_SHFT-1:`FIELD_POS_SHFT];
wire [`DATA_WIDTH-1:0] immediate_87 = {{`FIELD_WIDTH_IMM{instr_87[`FIELD_WIDTH_IMM-1]}}, instr_87[`FIELD_WIDTH_IMM-1:0]};
wire [`DATA_WIDTH-1:0] offset_ld_87 = immediate_87;
wire [`DATA_WIDTH-1:0] offset_st_87 = immediate_87; // todo verify this
wire [`DATA_WIDTH-1:0] offset_br_87 = {immediate_87 << 2, 2'b00};

// jump address decoding
wire [`DATA_WIDTH-1:0] jump_trgt_87 = {4'b0, instr_87[`FIELD_WIDTH_OFF-1:0], 2'b00}; // TODO hardcoded...
wire [`DATA_WIDTH-1:0] jump_addr_87 = (pc_in_87 & 'hf0000000) | jump_trgt_87;

wire [`FIELD_WIDTH_RSTD-1:0] s_reg_87 = instr_87[`FIELD_POS_RS+`FIELD_WIDTH_RSTD-1:`FIELD_POS_RS];
wire [`FIELD_WIDTH_RSTD-1:0] t_reg_87 = instr_87[`FIELD_POS_RT+`FIELD_WIDTH_RSTD-1:`FIELD_POS_RT];
wire [`FIELD_WIDTH_RSTD-1:0] d_reg_87 = imm_as_reg_87 ? immediate_87[`FIELD_WIDTH_RSTD-1:0] : instr_87[`FIELD_POS_RD+`FIELD_WIDTH_RSTD-1:`FIELD_POS_RD];

// in some cases (as of now only JR) we read the contents of the source register
wire [`FIELD_WIDTH_RSTD-1:0] rread_87 = ctrl_jump_sel_87 == 2'b10 ? s_reg_87 : d_reg_87;

wire [`FIELD_WIDTH_OP-1:0] op_code_87 = instr_87[`FIELD_POS_OP+`FIELD_WIDTH_OP-1:`FIELD_POS_OP];
wire [`FIELD_WIDTH_FUNC-1:0] fn_code_87 = instr_87[`FIELD_POS_FUNC+`FIELD_WIDTH_FUNC-1:`FIELD_POS_FUNC];

// register control module
regs regs (
   .read_data_1_87   (  reg_data_1_87  ),
   .read_data_2_87   (  reg_data_2_87  ),

   .read_reg_1_87    (  t_reg_87       ),
   .read_reg_2_87    (  rread_87       ),
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
   .jump_sel_87      (  ctrl_jump_sel_87  ),
   .mem_read_87      (  ctrl_mem_read_87  ),
   .mem_write_87     (  ctrl_mem_write_87 ),
   .mem_to_reg_87    (  ctrl_mem_to_reg_87),
   .alu_op_87        (  ctrl_alu_op_87    ),

   .imm_as_reg_87    (  imm_as_reg_87     ),
   .fn_87            (  fn_code_87        ),
   .op_87            (  op_code_87        )
);

always @(*) begin
   if (op_code_87 == `OPCODE_R) begin
      if (fn_code_87 == `FUNC_JR) begin
         jump_addr_out_87 <= reg_data_2_87;
      end else begin
         data_out_1_87 <= reg_data_1_87;
         data_out_2_87 <= reg_data_2_87;
      end
   end else if (op_code_87 == `OPCODE_J) begin
      jump_addr_out_87 <= jump_addr_87;
   end else if (op_code_87 == `OPCODE_LW) begin
      data_out_1_87 <= reg_data_1_87;
      data_out_2_87 <= reg_data_2_87;
      immd_out_87 <= offset_ld_87;
   end else if (op_code_87 == `OPCODE_SW) begin
      data_out_1_87 <= reg_data_1_87;
      data_out_2_87 <= reg_data_2_87;
      immd_out_87 <= offset_st_87;
   end else if ((op_code_87 == `OPCODE_BEQ) || (op_code_87 == `OPCODE_BNE)) begin
      data_out_1_87 <= reg_data_1_87;
      data_out_2_87 <= reg_data_2_87;
      immd_out_87 <= offset_br_87;
   end else begin
      data_out_1_87 <= reg_data_1_87;
      data_out_2_87 <= immediate_87;
      immd_out_87 <= immediate_87;  // TODO - clean this up...
   end
end

always @(posedge clk_87) begin
   if (rst_87) begin
      pc_out_87      <= 0;
   end else begin
      pc_out_87      <= pc_in_87;
      immd_87        <= immd_out_87;
      shamt_87       <= shift_amt_87;
      data_read_1_87 <= data_out_1_87;
      data_read_2_87 <= data_out_2_87;
      reg_write_87   <= ctrl_reg_wb_87;
      reg_dst_87     <= ctrl_reg_dst_87;
      mem_to_reg_87  <= ctrl_mem_to_reg_87;
      branch_87      <= ctrl_branch_87;
      jump_sel_87    <= ctrl_jump_sel_87;
      mem_read_87    <= ctrl_mem_read_87;
      mem_write_87   <= ctrl_mem_write_87;
      alu_src_87     <= ctrl_alu_src_87;
      alu_op_87      <= ctrl_alu_op_87;
      rs_87          <= s_reg_87;
      rt_87          <= t_reg_87;
      rd_87          <= d_reg_87;
      op_87          <= op_code_87;
      fn_87          <= fn_code_87;
   end
end

`ifdef DEBUG_TRACE
   reg [`DATA_WIDTH-1:0] jmp_address_87;
   wire signed [`FIELD_WIDTH_IMM-1:0] immd = $signed(immd_87);
   always @(posedge clk_87) begin
   jmp_address_87 <= jump_addr_87;
   if (rst_87) begin
         //$strobe($time,,,"...reset...");
      end else if (instr_87 == 0) begin
         //$strobe("");
      end else if (op_code_87 == `OPCODE_R) begin
         case (fn_code_87)
            `FUNC_JR    : $strobe($time,,,"ID: JR\t%0d", rs_87);
            `FUNC_SLL   : $strobe($time,,,"ID: SLL\t$%0d, $%0d, $%0d", rd_87, rt_87, shamt_87);
            `FUNC_SRL   : $strobe($time,,,"ID: SRL\t$%0d, $%0d, $%0d", rd_87, rt_87, shamt_87);
            `FUNC_ADDU  : $strobe($time,,,"ID: ADDU\t$%0d, $%0d, $%0d", rd_87, rs_87, rt_87);
            `FUNC_MULT  : $strobe($time,,,"ID: MULT\t$%0d, $%0d, $%0d", rd_87, rs_87, rt_87);
            default     : $strobe($time,,,"ID: UNKNOWN R-TYPE FUNCTION: %b", instr_87);
         endcase
      end else if (op_code_87 == `OPCODE_J) begin
         $strobe($time,,,"ID: J\t%0d", jmp_address_87);
      end else begin
         case (op_code_87)
            `OPCODE_ADDIU  : $strobe($time,,,"ID: ADDIU\t$%0d, $%0d, %0d", rt_87, rs_87, immd);
            `OPCODE_LW     : $strobe($time,,,"ID: LW\t$%0d, %0d($%0d)", rt_87, immd, rs_87);
            `OPCODE_BEQ    : $strobe($time,,,"ID: BEQ\t$%0d, $%0d, %0d", rs_87, rt_87, immd);
            `OPCODE_MUL    : $strobe($time,,,"ID: MUL\t$%0d, $%0d, $%0d", rd_87, rs_87, rt_87);
            default        : $strobe($time,,,"ID: UNKNOWN I-TYPE FUNCTION: %b", instr_87);
         endcase
      end
   end
`endif

endmodule // instr_decode