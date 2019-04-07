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
   output reg zero_87,                             // ALU output zero flag
   output reg [`ADDR_WIDTH-1:0] br_addr_87,        // effective branch address
   output reg [`DATA_WIDTH-1:0] adr_out_87,        // ALU output
   output reg [`DATA_WIDTH-1:0] wb_data_87,        // write-back data
   output reg [`FIELD_WIDTH_RSTD-1:0] wb_radr_87,  // write-back register address

   output reg branch_out_87,                       // control signal feed-through outputs
   output reg mem_read_out_87,
   output reg mem_write_out_87,
   output reg reg_write_out_87,
   output reg mem_2_reg_out_87,
   output reg [`ADDR_WIDTH-1:0] pc_out_87,         // next pc feed-through

   input wire branch_in_87,                        // control signal feed-through inputs
   input wire mem_read_in_87,
   input wire mem_write_in_87,
   input wire reg_write_in_87,
   input wire mem_2_reg_in_87,
   input wire reg_dst_87,                          // register write-back select
   input wire alu_src_87,                          // select reg contents or I-val
   input wire [1:0] alu_ctl_87,
   input wire [1:0] jmp_sel_87,

   input wire [`FIELD_WIDTH_RSTD-1:0] trgt_r_in_87,
   input wire [`FIELD_WIDTH_RSTD-1:0] dest_r_in_87,
   input wire [`FIELD_WIDTH_OP-1:0] op_87,
   input wire [`FIELD_WIDTH_FUNC-1:0] fn_87,
   input wire [`DATA_WIDTH-1:0] imm_s_87,
   input wire [`DATA_WIDTH-1:0] rval_a_87,
   input wire [`DATA_WIDTH-1:0] rval_b_87,
   input wire [`ADDR_WIDTH-1:0] pc_in_87,
   input wire rst_87,
   input wire clk_87
);

reg [3:0] alu_op_87;
reg [`DATA_WIDTH-1:0] result_tmp_87;

wire do_shift_87;
wire alu_zero_87;
wire [`ADDR_WIDTH-1:0] pc_brnch_87;
wire [`DATA_WIDTH-1:0] alu_in_a_87;
wire [`DATA_WIDTH-1:0] alu_in_b_87;
wire [`DATA_WIDTH-1:0] alu_rslt_87;
wire [`DATA_WIDTH-1:0] shamt_87;
wire [`FIELD_WIDTH_RSTD-1:0] wb_addr_wire_87;

alu alu (
   .zero_87    (alu_zero_87),
   .rslt_87    (alu_rslt_87),
   .arg_a_87   (alu_in_a_87),
   .arg_b_87   (alu_in_b_87),
   .alu_op_87  (alu_op_87)
);

assign pc_brnch_87 = pc_in_87 + (imm_s_87 << 2);
assign shamt_87 = imm_s_87[`FIELD_WIDTH_SHAMT+`FIELD_POS_SHFT-1:`FIELD_POS_SHFT];
assign do_shift_87 = (alu_op_87 == `ALU_SLL) || (alu_op_87 == `ALU_SRL);
assign alu_in_a_87 = rval_a_87;
assign alu_in_b_87 = alu_src_87 ? imm_s_87 : do_shift_87 ? shamt_87 : alu_in_b_87;
assign wb_addr_wire_87 = reg_dst_87 ? dest_r_in_87 : trgt_r_in_87;

// for R-Type functions convert to the correct ALU opcode 
always @(*) begin
   if (alu_ctl_87 == 2'b10) begin // use function code
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
end

always @(*) begin
   if (alu_ctl_87 == 2'b10) begin
      if (fn_87 != `FUNC_JR) begin
         result_tmp_87 <= alu_rslt_87;
      end
   end else begin
   end
end

always @(posedge clk_87) begin
   if (rst_87) begin
      pc_out_87  <= 0;
   end else begin
      zero_87     <= alu_zero_87;
      adr_out_87  <= alu_rslt_87;
      br_addr_87  <= pc_brnch_87;
      wb_data_87  <= alu_in_b_87;
      wb_radr_87  <= wb_addr_wire_87;     
      pc_out_87  <= pc_in_87;
      branch_out_87  <= branch_in_87;
      mem_read_out_87   <= mem_read_in_87;
      mem_write_out_87  <= mem_write_in_87;
      reg_write_out_87  <= reg_write_in_87;
      mem_2_reg_out_87  <= mem_2_reg_in_87;
   end
end

`ifdef DEBUG_TRACE
always @(posedge clk_87) begin
end
`endif

endmodule // instr_ex