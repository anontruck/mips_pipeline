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
   output wire system_halt_87,                        // TODO - not using actual system instructions yet
   // control signals
   output reg reg_write_87,                           // register write-back flag
   output reg reg_dest_87,                            // register write-back select
   output reg mem_to_reg_87,                          // register write-back from memory
   output reg mem_read_87,                            // read from memory flag
   output reg mem_write_87,                           // memory write-back
   output reg alu_src_87,                             // ALU input source flag
   output reg [1:0] alu_op_87,                        // ALU operation control signal
   output reg flush_flag_87,                          // if branching, flag to flush the IF stage
   output reg branch_flag_87,                         // set on jumps or branches
   output reg [`ADDR_WIDTH-1:0] pc_out_87,            // next PC if a jump or branch taken
   output reg [`DATA_WIDTH-1:0] immd_87,              // sign extended immediate
   output reg [`RADDR_WIDTH-1:0] rt_87,
   output reg [`RADDR_WIDTH-1:0] rd_87,
   output reg [`FIELD_WIDTH_OP-1:0] op_87,
   output reg [`FIELD_WIDTH_FUNC-1:0] fn_87,
   output reg [`DATA_WIDTH-1:0] data_read_1_87,       // read data outputs
   output reg [`DATA_WIDTH-1:0] data_read_2_87,
   
   // async rs and rt outputs for hazard detection and forwarding
   output wire [`RADDR_WIDTH-1:0] rs_async_out_87,
   output wire [`RADDR_WIDTH-1:0] rt_async_out_87,
   // inputs
   input wire [`INSTR_WIDTH-1:0] instr_87,
   input wire [`RADDR_WIDTH-1:0] reg_2_write_87,      // register to write to
   input wire [`DATA_WIDTH-1:0] data_2_write_87,      // data to write
   input wire [`ADDR_WIDTH-1:0] pc_in_87,
   input wire stall_87,                               // stall input signal
   input wire en_wb_87,                               // enable write-back
   input wire rst_87,
   input wire clk_87
);

wire nop_87 = instr_87 == {`INSTR_WIDTH{1'b0}} ? 1 : 0;

// instriction register decoding
wire [`RADDR_WIDTH-1:0] s_reg_87 = instr_87[`FIELD_POS_RS+`FIELD_WIDTH_RSTD-1:`FIELD_POS_RS];
wire [`RADDR_WIDTH-1:0] t_reg_87 = instr_87[`FIELD_POS_RT+`FIELD_WIDTH_RSTD-1:`FIELD_POS_RT];
wire [`RADDR_WIDTH-1:0] d_reg_87 = instr_87[`FIELD_POS_RD+`FIELD_WIDTH_RSTD-1:`FIELD_POS_RD];

// immediate decoding
wire [`FIELD_WIDTH_IMM-1:0] imm_u16_87 = instr_87[`FIELD_WIDTH_IMM-1:0];
wire [`DATA_WIDTH-1:0] imm_s32_87 = {{`FIELD_WIDTH_IMM{instr_87[`FIELD_WIDTH_IMM-1]}}, instr_87[`FIELD_WIDTH_IMM-1:0]};

// op and function code decoding
wire [`FIELD_WIDTH_OP-1:0] op_code_87 = instr_87[`FIELD_POS_OP+`FIELD_WIDTH_OP-1:`FIELD_POS_OP];
wire [`FIELD_WIDTH_FUNC-1:0] fn_code_87 = instr_87[`FIELD_POS_FUNC+`FIELD_WIDTH_FUNC-1:`FIELD_POS_FUNC];

// jump address decoding
wire [`DATA_WIDTH-1:0] jump_trgt_87 = {4'b0, instr_87[`FIELD_WIDTH_OFF-1:0], 2'b00}; // TODO hardcoded...
wire [`DATA_WIDTH-1:0] jump_addr_87 = (pc_in_87 & 'hf0000000) | jump_trgt_87;

// asynchronous outputs for forwarding
assign rs_async_out_87 = s_reg_87;
assign rt_async_out_87 = t_reg_87;

// TODO - this is a kludge for now
assign system_halt_87 = !rst_87 && (fn_code_87 == `FUNC_JR) && (s_reg_87 == 'd31);

wire [`DATA_WIDTH-1:0] reg_data_1_87;
wire [`DATA_WIDTH-1:0] reg_data_2_87;

wire imm_as_reg_87;
wire ctrl_reg_wb_87;
wire ctrl_reg_dst_87;
wire ctrl_alu_src_87;
wire ctrl_mem_read_87;
wire ctrl_mem_write_87;
wire ctrl_mem_to_reg_87;
wire [1:0] ctrl_alu_op_87;

// control unit
ctrl_unit ctrl_unit (
   .reg_wb_87        (ctrl_reg_wb_87),
   .reg_dest_87      (ctrl_reg_dst_87),
   .alu_src_87       (ctrl_alu_src_87),
   .mem_read_87      (ctrl_mem_read_87),
   .mem_write_87     (ctrl_mem_write_87),
   .mem_to_reg_87    (ctrl_mem_to_reg_87),
   .alu_op_87        (ctrl_alu_op_87),

   .imm_as_reg_87    (imm_as_reg_87),
   .en_87            (~rst_87),
   .fn_87            (fn_code_87),
   .op_87            (op_code_87)
);

// register control module
regs #(
   `ifdef REG_INITF .REG_FILE(`REG_INITF), .INIT_REGS(1) `else .INIT_REGS(0) `endif
)
   regs (
   .read_data_1_87   (reg_data_1_87),
   .read_data_2_87   (reg_data_2_87),

   .dump_reg_data_87 (system_halt_87),

   .read_reg_1_87    (s_reg_87),
   .read_reg_2_87    (t_reg_87),
   .write_reg_87     (reg_2_write_87),
   .write_data_87    (data_2_write_87),
   .we_87            (en_wb_87),
   .rst_87           (rst_87),
   .clk_87           (clk_87)
);

wire equals_flag_87 = (reg_data_1_87 == reg_data_2_87) ? 1'b1 : 1'b0;

reg [`DATA_WIDTH-1:0] data_out_1_87;
reg [`DATA_WIDTH-1:0] data_out_2_87;
reg [`DATA_WIDTH-1:0] immd32_out_87;

always @(*) begin
   if (rst_87 || nop_87) begin
      pc_out_87 <= 0;
      flush_flag_87 <= 1'b0;
      branch_flag_87 <= 1'b0;
      data_out_1_87 <= 0;
      data_out_2_87 <= 0;
      immd32_out_87 <= 0;
   end else if (op_code_87 == `OPCODE_R) begin
      flush_flag_87 <= 1'b0;
      if (fn_code_87 == `FUNC_JR) begin
         pc_out_87   <= reg_data_2_87;
         branch_flag_87  <= 1'b1;
         //flush_flag_87 <= 1'b1;
      end else begin
         flush_flag_87 <= 1'b0;
         if (fn_code_87 == `FUNC_SLL || fn_code_87 == `FUNC_SRL) begin
            data_out_1_87 <= reg_data_1_87;
            data_out_2_87 <= shift_amt_87;
         end else begin
            data_out_1_87 <= reg_data_1_87;
            data_out_2_87 <= reg_data_2_87;
         end
      end
   end else if (op_code_87 == `OPCODE_J) begin
      pc_out_87   <= jump_addr_87;
      branch_flag_87  <= 1'b1;
      //flush_flag_87 <= 1'b1;
   end else if (op_code_87 == `OPCODE_MUL) begin
      data_out_1_87 <= reg_data_1_87;
      data_out_2_87 <= reg_data_2_87;
   end else if (op_code_87 == `OPCODE_LW) begin
      data_out_1_87 <= reg_data_1_87;
      data_out_2_87 <= reg_data_2_87;
      immd32_out_87 <= imm_s32_87;
      flush_flag_87 <= 1'b0;
      branch_flag_87  <= 1'b0;
   end else if (op_code_87 == `OPCODE_SW) begin
      data_out_1_87 <= reg_data_1_87;
      data_out_2_87 <= reg_data_2_87;
      immd32_out_87 <= imm_s32_87;
      flush_flag_87 <= 1'b0;
      branch_flag_87  <= 1'b0;
   end else if ((op_code_87 == `OPCODE_BEQ) && (equals_flag_87 == 1'b1)) begin
      pc_out_87 <= pc_in_87 + {imm_s32_87, 2'b00};
      branch_flag_87 <= 1'b1;
      //flush_flag_87 <= 1'b1;
   end else if ((op_code_87 == `OPCODE_BNE) && (equals_flag_87 == 1'b0)) begin
      pc_out_87 <= pc_in_87 + {imm_s32_87, 2'b00};
      branch_flag_87 <= 1'b1;
      //flush_flag_87 <= 1'b1;
   end else begin
      data_out_1_87 <= reg_data_1_87;
      data_out_2_87 <= imm_s32_87;
      immd32_out_87 <= imm_s32_87;  // TODO - clean this up...
      branch_flag_87 <= 1'b0;
      flush_flag_87 <= 1'b0;
      pc_out_87 <= 0;
   end
end

always @(posedge clk_87) begin
   //if (rst_87 || stall_87 || jump_87 || system_halt_87) begin
   if (rst_87 || nop_87 || branch_flag_87 || system_halt_87) begin

      // if stalling, maintain pc but still zero everything out. This will
      // effectively result in a NOP instruction inserted into the pipeline
      //pc_out_87 <=  0;

      alu_op_87      <= 2'b0;
      alu_src_87     <= 0;
      mem_read_87    <= 0;
      mem_write_87   <= 0;
      mem_to_reg_87  <= 0;
      reg_write_87   <= 0;
      reg_dest_87    <= 0;

      data_read_1_87 <= 0;
      data_read_2_87 <= 0;

      immd_87        <= 0;
      op_87          <= 0;
      fn_87          <= 0;
      rt_87          <= 0;
      rd_87          <= 0;
   end else if (stall_87) begin
      //pc_out_87      <= pc_out_87;
      
      alu_op_87      <= 2'b0;
      alu_src_87     <= 0;
      mem_read_87    <= 0;
      mem_write_87   <= 0;
      mem_to_reg_87  <= 0;
      reg_write_87   <= 0;
      reg_dest_87    <= 0;

      data_read_1_87 <= 0;
      data_read_2_87 <= 0;

      immd_87        <= 0;
      op_87          <= 0;
      fn_87          <= 0;
      rt_87          <= 0;
      rd_87          <= 0;
   end else begin
      //pc_out_87      <= pc_in_87;
      immd_87        <= immd32_out_87;
      data_read_1_87 <= data_out_1_87;
      data_read_2_87 <= data_out_2_87;
      reg_write_87   <= ctrl_reg_wb_87;
      reg_dest_87    <= ctrl_reg_dst_87;
      mem_to_reg_87  <= ctrl_mem_to_reg_87;
      mem_read_87    <= ctrl_mem_read_87;
      mem_write_87   <= ctrl_mem_write_87;
      alu_src_87     <= ctrl_alu_src_87;
      alu_op_87      <= ctrl_alu_op_87;
      rt_87 <= t_reg_87;
      //rd_87 <= imm_as_reg_87 ? imm_s32_87[`FIELD_WIDTH_RSTD-1:0] : d_reg_87;
      rd_87 <= d_reg_87;
      op_87 <= op_code_87;
      fn_87 <= fn_code_87;
   end
end





`ifdef DEBUG_TRACE

reg [`DATA_WIDTH-1:0] jmp_address_87;
reg [`RADDR_WIDTH-1:0] rs_87;
reg [`DATA_WIDTH-1:0] shamt_87;

wire [`DATA_WIDTH-1:0] shift_amt_87 = instr_87[`FIELD_WIDTH_SHAMT+`FIELD_POS_SHFT-1:`FIELD_POS_SHFT];

wire signed [`FIELD_WIDTH_IMM-1:0] immd = $signed(immd_87);

always @(negedge clk_87) begin
   jmp_address_87 <= jump_addr_87;
   shamt_87 <= shift_amt_87;
   rs_87 <= s_reg_87;
   if (rst_87) begin
      $strobe($time,,,"ID: RESET");
   end else if (stall_87) begin
      $strobe($time,,,"ID: STALLED");
   end else if (!instr_87) begin
      $strobe($time,,,"ID: NOP");
   end else if (op_code_87 == `OPCODE_R) begin
      case (fn_code_87)
         `FUNC_JR    : $strobe($time,,,"ID: JR\t%0d", rs_87);
         `FUNC_SLL   : $strobe($time,,,"ID: SLL\t$%0d, $%0d, $%0d",    d_reg_87, t_reg_87, shift_amt_87);
         `FUNC_SRL   : $strobe($time,,,"ID: SRL\t$%0d, $%0d, $%0d",    d_reg_87, t_reg_87, shift_amt_87);
         `FUNC_ADD   : $strobe($time,,,"ID: ADD\t$%0d, $%0d, $%0d",    d_reg_87, s_reg_87, t_reg_87);
         `FUNC_ADDU  : $strobe($time,,,"ID: ADDU\t$%0d, $%0d, $%0d",   d_reg_87, s_reg_87, t_reg_87);
         `FUNC_SUB   : $strobe($time,,,"ID: SUB\t$%0d, $%0d, $%0d",    d_reg_87, s_reg_87, t_reg_87);
         `FUNC_SUBU  : $strobe($time,,,"ID: SUBU\t$%0d, $%0d, $%0d",   d_reg_87, s_reg_87, t_reg_87);
         `FUNC_MULT  : $strobe($time,,,"ID: MULT\t$%0d, $%0d, $%0d",   d_reg_87, s_reg_87, t_reg_87);
         `FUNC_MULTU : $strobe($time,,,"ID: MULTU\t$%0d, $%0d, $%0d",  d_reg_87, s_reg_87, t_reg_87);
         `FUNC_DIV   : $strobe($time,,,"ID: DIV\t$%0d, $%0d, $%0d",    d_reg_87, s_reg_87, t_reg_87);
         `FUNC_DIVU  : $strobe($time,,,"ID: DIVU\t$%0d, $%0d, $%0d",   d_reg_87, s_reg_87, t_reg_87);
         default     : $strobe($time,,,"ID: UNKNOWN R-TYPE FUNCTION: %b", instr_87);
      endcase
   end else if (op_code_87 == `OPCODE_J) begin
      $display($time,,,"ID: J\t%0d", jump_addr_87);
   end else begin
      case (op_code_87)
         `OPCODE_ADDI   : $strobe($time,,,"ID: ADDI\t$%0d, $%0d, %0d",    t_reg_87, s_reg_87, imm_s32_87);
         `OPCODE_ADDIU  : $strobe($time,,,"ID: ADDIU\t$%0d, $%0d, %0d",   t_reg_87, s_reg_87, imm_s32_87);
         `OPCODE_ANDI   : $strobe($time,,,"ID: ANDI\t$%0d, $%0d, %0d",    t_reg_87, s_reg_87, imm_s32_87);
         `OPCODE_ORI    : $strobe($time,,,"ID: ORI\t$%0d, $%0d, %0d",     t_reg_87, s_reg_87, imm_s32_87);
         `OPCODE_LW     : $strobe($time,,,"ID: LW\t$%0d, %0d($%0d)",      t_reg_87, imm_s32_87, s_reg_87);
         `OPCODE_BEQ    : $strobe($time,,,"ID: BEQ\t$%0d, $%0d, %0d",     s_reg_87, t_reg_87, imm_s32_87);
         `OPCODE_BNE    : $strobe($time,,,"ID: BNE\t$%0d, $%0d, %0d",     s_reg_87, t_reg_87, imm_s32_87);
         `OPCODE_MUL    : $strobe($time,,,"ID: MUL\t$%0d, $%0d, $%0d",    d_reg_87, s_reg_87, t_reg_87);
         default        : $strobe($time,,,"ID: UNKNOWN I-TYPE FUNCTION: %b", instr_87);
      endcase
   end
end

`endif // DEBUG_TRACE

endmodule // instr_decode