////////////////////////////////////////////////////////////////////////////////
// Module: instr_ex.v
// Project: SJSU EE275 Mini Project 2
// Description:
//
// Name: Zach Smith 
// Student ID: 007159087
//
// Note:
//
////////////////////////////////////////////////////////////////////////////////
`include "mips_defs.vh"
`include "alu.vh"

module instr_ex (
   output reg [`DATA_WIDTH-1:0] result_87,            // ALU output
   output reg [`DATA_WIDTH-1:0] write_back_data_87,   // write-back data
   output reg [`RADDR_WIDTH-1:0] reg_write_addr_87,   // write-back register address

   output reg mem_read_out_87,
   output reg mem_write_out_87,
   output reg reg_write_out_87,
   output reg mem_2_reg_out_87,

   input wire mem_read_in_87,
   input wire mem_write_in_87,
   input wire reg_write_in_87,
   input wire mem_2_reg_in_87,
   input wire reg_dst_87,                             // register write-back select
   input wire alu_src_87,                             // select reg contents or I-val
   input wire [1:0] alu_ctl_87,

   input wire [`RADDR_WIDTH-1:0] rt_in_87,
   input wire [`RADDR_WIDTH-1:0] rd_in_87,
   input wire [`FIELD_WIDTH_OP-1:0] op_87,
   input wire [`FIELD_WIDTH_FUNC-1:0] fn_87,
   input wire [`DATA_WIDTH-1:0] imm_s_87,
   input wire [`DATA_WIDTH-1:0] rval_a_87,
   input wire [`DATA_WIDTH-1:0] rval_b_87,
   input wire rst_87,
   input wire clk_87
);

reg not_zero_87;
reg [3:0] alu_op_87;

wire do_shift_87;
wire alu_zero_87;
//wire [`ADDR_WIDTH-1:0] pc_brnch_87;
wire [`DATA_WIDTH-1:0] alu_in_a_87;
wire [`DATA_WIDTH-1:0] alu_in_b_87;
wire [`DATA_WIDTH-1:0] alu_rslt_87;
wire [`RADDR_WIDTH-1:0] reg_dest_87;

alu alu (
   .zero_87    (alu_zero_87),
   .rslt_87    (alu_rslt_87),
   .arg_a_87   (alu_in_a_87),
   .arg_b_87   (alu_in_b_87),
   .alu_op_87  (alu_op_87),
   .en_87      (~rst_87)
);

assign alu_in_a_87 = rval_a_87;
assign alu_in_b_87 = alu_src_87 ? imm_s_87 : rval_b_87;
assign reg_dest_87 = reg_dst_87 ? rd_in_87 : rt_in_87;

// for R-Type functions convert to the correct ALU opcode 
always @(*) begin
   if (alu_ctl_87 == 2'b10) begin // use function code
      if (op_87 == `OPCODE_MUL) begin
         alu_op_87 <= `ALU_MULT;
      end else begin
         case (fn_87)
            `FUNC_SLL:     alu_op_87 <= `ALU_SLL;
            `FUNC_SRL:     alu_op_87 <= `ALU_SRL;
            `FUNC_MULT:    alu_op_87 <= `ALU_MULT;
            `FUNC_MULTU:   alu_op_87 <= `ALU_MULTU;
            `FUNC_DIV:     alu_op_87 <= `ALU_DIV;
            `FUNC_DIVU:    alu_op_87 <= `ALU_DIV;
            `FUNC_ADD:     alu_op_87 <= `ALU_ADD;
            `FUNC_ADDU:    alu_op_87 <= `ALU_ADDU;
            `FUNC_SUB:     alu_op_87 <= `ALU_SUB;
            `FUNC_SUBU:    alu_op_87 <= `ALU_SUBU;
            `FUNC_AND:     alu_op_87 <= `ALU_AND;
            `FUNC_OR:      alu_op_87 <= `ALU_OR;
            `FUNC_SLT:     alu_op_87 <= `ALU_SLT;
            `FUNC_SLTU:    alu_op_87 <= `ALU_SLTU;
            default:
               alu_op_87 <= 'bz; // idk
         endcase
      end
   end else if (alu_ctl_87 == 2'b00) begin // load/store
      alu_op_87 <= `ALU_ADD;
   end
end

always @(posedge clk_87) begin
   if (rst_87) begin
      result_87            <= 0;
      reg_write_addr_87    <= 0;
      write_back_data_87   <= 0;
      mem_read_out_87      <= 0;
      mem_write_out_87     <= 0;
      reg_write_out_87     <= 0;
      mem_2_reg_out_87     <= 0;
   end else begin
      result_87            <= alu_rslt_87;
      write_back_data_87   <= rval_b_87;
      reg_write_addr_87    <= reg_dest_87;     
      mem_read_out_87      <= mem_read_in_87;
      mem_write_out_87     <= mem_write_in_87;
      reg_write_out_87     <= reg_write_in_87;
      mem_2_reg_out_87     <= mem_2_reg_in_87;
   end
end

`ifdef DEBUG_TRACE

reg [3:0] alu_operation_87;
reg [`DATA_WIDTH-1:0] arg_a_87;
reg [`DATA_WIDTH-1:0] arg_b_87;
reg signed [`DATA_WIDTH-1:0] arg_a_signed_87;
reg signed [`DATA_WIDTH-1:0] arg_b_signed_87;

wire signed [`DATA_WIDTH-1:0] alu_in_a_signed_87 = $signed(alu_in_a_87);
wire signed [`DATA_WIDTH-1:0] alu_in_b_signed_87 = $signed(alu_in_b_87);

always @(negedge clk_87) begin
   if (rst_87) begin
      $strobe($time,,,"EX: RESET");
   end else begin
      //$strobe($time,,,"EX: a:%0d op b:%0d -> %0d", alu_in_a_87, alu_in_b_87, result_87);
      alu_operation_87 <= alu_op_87;
      arg_a_87 <= alu_in_a_87;
      arg_b_87 <= alu_in_b_87;
      arg_a_signed_87 <= $signed(alu_in_a_87);
      arg_b_signed_87 <= $signed(alu_in_b_87);

      if      (alu_op_87 == `ALU_ADD)    $strobe($time,,,"EX: %0d + %0d = %0d",    alu_in_a_signed_87, alu_in_b_signed_87, alu_rslt_87);
      else if (alu_op_87 == `ALU_SUB)    $strobe($time,,,"EX: %0d - %0d = %0d",    alu_in_a_signed_87, alu_in_b_signed_87, alu_rslt_87);
      else if (alu_op_87 == `ALU_SLT)    $strobe($time,,,"EX: %0d < %0d ? %0d",    alu_in_a_signed_87, alu_in_b_signed_87, alu_rslt_87);
      else if (alu_op_87 == `ALU_MULT)   $strobe($time,,,"EX: %0d x %0d = %0d",    alu_in_a_signed_87, alu_in_b_signed_87, alu_rslt_87);
      else if (alu_op_87 == `ALU_DIV)    $strobe($time,,,"EX: %0d / %0d = %0d",    alu_in_a_signed_87, alu_in_b_signed_87, alu_rslt_87);
      else if (alu_op_87 == `ALU_SLL)    $strobe($time,,,"EX: %0d << %0d = %0d",   alu_in_a_87, alu_in_b_87, alu_rslt_87);
      else if (alu_op_87 == `ALU_SRL)    $strobe($time,,,"EX: %0d >> %0d = %0d",   alu_in_a_87, alu_in_b_87, alu_rslt_87);
      else if (alu_op_87 == `ALU_ADDU)   $strobe($time,,,"EX: %0d + %0d = %0d",    alu_in_a_87, alu_in_b_87, alu_rslt_87);
      else if (alu_op_87 == `ALU_SUBU)   $strobe($time,,,"EX: %0d - %0d = %0d",    alu_in_a_87, alu_in_b_87, alu_rslt_87);
      else if (alu_op_87 == `ALU_AND)    $strobe($time,,,"EX: %0d & %0d = %0d",    alu_in_a_87, alu_in_b_87, alu_rslt_87);
      else if (alu_op_87 == `ALU_OR)     $strobe($time,,,"EX: %0d | %0d = %0d",    alu_in_a_87, alu_in_b_87, alu_rslt_87);
      else if (alu_op_87 == `ALU_SLTU)   $strobe($time,,,"EX: %0d > %0d ? %0d",    alu_in_a_87, alu_in_b_87, alu_rslt_87);
      else if (alu_op_87 == `ALU_MULTU)  $strobe($time,,,"EX: %0d x %0d = %0d",    alu_in_a_87, alu_in_b_87, alu_rslt_87);
      else if (alu_op_87 == `ALU_DIVU)   $strobe($time,,,"EX: %0d / %0d = %0d",    alu_in_a_87, alu_in_b_87, alu_rslt_87);
   end
end
`endif // DEBUG_TRACE

endmodule // instr_ex