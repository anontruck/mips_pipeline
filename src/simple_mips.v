////////////////////////////////////////////////////////////////////////////////
// Module:  simple_mips.v
// Project: SJSU EE275 Mini Project 2
// Description: Portion of a 5-stage pipeline MIPS datapath with forwarding
//
// Name: Zach Smith 
// Student ID: 007159087
//
// Note:
//
////////////////////////////////////////////////////////////////////////////////
`include "mips_defs.vh"

module simple_mips(
   input wire rst_87,
   input wire clk_87
);

wire [`INSTR_WIDTH-1:0] instr_if_87,
                        instr_id_87;

wire [`ADDR_WIDTH-1:0]  pc_if_87,
                        pc_id_87,
                        pc_id_out_87,
                        pc_ex_87;


wire  [`FIELD_WIDTH_RSTD-1:0] wreg_id_87,
                              rt_id_87,
                              rd_id_87;

instr_fetch ifu (
   .instr_87   (instr_if_87),
   .npc_87     ( pc_if_87 ),
   .pc_87      (  32'b0   ),
   .sel_87     (   1'b0   ),
   .rst_87     (  rst_87  ),
   .clk_87     (  clk_87  )
);

vl_dff #(.width(`INSTR_WIDTH)) dff_inst_if (.d(instr_if_87), .q(instr_id_87), .rst(rst_87), .clk(clk_87));
vl_dff #(.width(`ADDR_WIDTH)) dff_npc_if (.d(pc_if_87), .q(pc_id_87), .rst(rst_87), .clk(clk_87));

//assign rreg_1_87 = instr_id_87[`FIELD_POS_RS+`FIELD_WIDTH_RSTD:`FIELD_POS_RS];
//assign rreg_2_87 = instr_id_87[`FIELD_POS_RD+`FIELD_WIDTH_RSTD:`FIELD_POS_RD];

wire reg_wb_id_87, reg_wb_ex_87;
wire mem2reg_id_87, mem2reg_ex_87;
wire branch_id_87, branch_ex_87;
wire mem_rd_id_87, mem_rd_ex_87;
wire mem_wb_id_87, mem_wb_ex_87;
wire reg_dst_id_87, reg_dst_ex_87;
wire alu_src_id_87, alu_src_ex_87;
wire [1:0] jmp_op_id_87, jmp_op_ex_87;
wire [1:0] alu_op_id_87, alu_op_ex_87;

wire  [`DATA_WIDTH-1:0] data_1_id_87, data_1_ex_87;
wire  [`DATA_WIDTH-1:0] data_2_id_87, data_2_ex_87;
wire  [`DATA_WIDTH-1:0] immed_id_87, immed_ex_87;

wire  [`FIELD_WIDTH_OP-1:0] op_id_87, op_ex_87;
wire  [`FIELD_WIDTH_FUNC-1:0] fn_id_87, fn_ex_87;

instr_decode idu (
   .reg_write_87     (  reg_wb_id_87   ),
   .reg_dst_87       (  reg_dst_id_87  ),
   .mem_to_reg_87    (  mem2reg_id_87  ),
   .branch_87        (  branch_id_87   ),
   .jump_sel_87      (  jmp_op_id_87   ),
   .mem_read_87      (  mem_rd_id_87   ),
   .mem_write_87     (  mem_wb_id_87   ),
   .alu_src_87       (  alu_src_id_87  ),
   .alu_op_87        (  alu_op_id_87   ),
   .data_read_1_87   (  data_1_id_87   ),
   .data_read_2_87   (  data_2_id_87   ),
   .immd_87          (  immed_id_87    ),
   .op_87            (  op_id_87       ),
   .fn_87            (  fn_id_87       ),
   .pc_out_87        (  pc_id_out_87   ),
   .pc_in_87         (  pc_id_87       ),
   .instr_87         (  instr_id_87    ),
   .reg_2_write_87   (`FIELD_WIDTH_RSTD'b0),
   .data_2_write_87  (`DATA_WIDTH'b0   ),
   .en_wb_87         (  1'b0           ),
   .rst_87           (  rst_87         ),
   .clk_87           (  clk_87         )
);

vl_dff dff_ctl_id_0 (.d(reg_dst_id_87),   .q(reg_dst_ex_87),   .rst(rst_87), .clk(clk_87));
vl_dff dff_ctl_id_1 (.d(reg_wb_id_87),    .q(reg_wb_ex_87),    .rst(rst_87), .clk(clk_87));
vl_dff dff_ctl_id_2 (.d(mem2reg_id_87),   .q(mem2reg_ex_87),   .rst(rst_87), .clk(clk_87));
vl_dff dff_ctl_id_3 (.d(branch_id_87),    .q(branch_ex_87),    .rst(rst_87), .clk(clk_87));
vl_dff dff_ctl_id_5 (.d(mem_rd_id_87),    .q(mem_rd_ex_87),    .rst(rst_87), .clk(clk_87));
vl_dff dff_ctl_id_6 (.d(mem_wb_id_87),    .q(mem_wb_ex_87),    .rst(rst_87), .clk(clk_87));
vl_dff dff_ctl_id_7 (.d(alu_src_id_87),   .q(alu_src_ex_87),   .rst(rst_87), .clk(clk_87));
vl_dff #(.width(2)) dff_ctl_id_8 (.d(alu_op_id_87), .q(alu_op_id_87), .rst(rst_87), .clk(clk_87));
vl_dff #(.width(2)) dff_ctl_id_9 (.d(jmp_op_id_87), .q(jmp_op_ex_87), .rst(rst_87), .clk(clk_87));
vl_dff #(.width(`DATA_WIDTH)) dff_id_data_1 (.d(data_1_id_87),  .q(data_1_ex_87), .rst(rst_87), .clk(clk_87));
vl_dff #(.width(`DATA_WIDTH)) dff_id_data_2 (.d(data_2_id_87),  .q(data_2_ex_87), .rst(rst_87), .clk(clk_87));
vl_dff #(.width(`DATA_WIDTH)) dff_id_immd   (.d(immed_id_87),   .q(immed_ex_87),  .rst(rst_87), .clk(clk_87));
vl_dff #(.width(`FIELD_WIDTH_OP))   dff_id_op (.d(op_id_87),   .q(op_ex_87), .rst(rst_87), .clk(clk_87));
vl_dff #(.width(`FIELD_WIDTH_FUNC)) dff_id_fn (.d(fn_id_87),   .q(fn_ex_87), .rst(rst_87), .clk(clk_87));
vl_dff #(.width(`ADDR_WIDTH)) dff_npc_id (.d(pc_id_out_87), .q(pc_ex_87), .rst(rst_87), .clk(clk_87));

instr_ex exu (
   .zero_87(),
   .alu_out_87(),
   .pc_brnch_87(),
   .pc_out_87(),
   .reg_dst_87(reg_dst_ex_87),
   .alu_src_87(alu_src_ex_87),
   .alu_ctl_87(alu_op_ex_87),
   .jmp_sel_87(jmp_op_ex_87),
   .op_87(op_ex_87),
   .fn_87(fn_ex_87),
   .imm_s_87(immed_ex_87),
   .rval_a_87(data_1_ex_87),
   .rval_b_87(data_2_ex_87),
   .pc_in_87(pc_ex_87),
   .rst_87(rst_87),
   .clk_87(clk_87)
);

endmodule // simple_mips