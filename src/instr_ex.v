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
   output wire zero_87,
   output wire [`DATA_WIDTH-1:0] alu_out_87,
   output wire [`ADDR_WIDTH-1:0] pc_brnch_87,
   output reg [`ADDR_WIDTH-1:0] pc_out_87,
   input wire reg_dst_87,  // register destination select
   input wire alu_src_87,
   input wire [1:0] alu_ctl_87,
   input wire [1:0] jmp_sel_87,
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

wire do_shift_87;

wire [`DATA_WIDTH-1:0]  alu_in_a_87,
                        alu_in_b_87,
                        shamt_87;

alu alu (
   .zero_87    (zero_87),
   .rslt_87    (alu_out_87),
   .arg_a_87   (alu_in_a_87),
   .arg_b_87   (alu_in_b_87),
   .alu_op_87  (alu_op_87)
);

assign pc_brnch_87 = pc_in_87 + (imm_s_87 << 2);

assign shamt_87 = imm_s_87[`FIELD_WIDTH_SHAMT+`FIELD_POS_SHFT-1:`FIELD_POS_SHFT];
assign do_shift_87 = (alu_op_87 == `ALU_SLL) || (alu_op_87 == `ALU_SRL);
assign alu_in_a_87 = rval_a_87;
assign alu_in_b_87 = alu_src_87 ? imm_s_87 : do_shift_87 ? shamt_87 : alu_in_b_87;

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
            alu_op_87 <= `ALU_ADD;  // idk
      endcase
   end
end

always @(posedge clk_87 or posedge rst_87) begin
   if (rst_87) begin
   end else begin
      pc_out_87 <= pc_in_87;
   end
end

endmodule // instr_ex