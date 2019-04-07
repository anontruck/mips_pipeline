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

wire [`INSTR_WIDTH-1:0] instr_if_87;
wire [`ADDR_WIDTH-1:0] pc_out_if_87;
wire [`ADDR_WIDTH-1:0] pc_ex_87;


wire  [`FIELD_WIDTH_RSTD-1:0] wreg_id_87;
wire  [`FIELD_WIDTH_RSTD-1:0] rt_id_87;
wire  [`FIELD_WIDTH_RSTD-1:0] rd_id_87;

wire br_taken_mem_87;

instr_fetch ifu (
   .instr_87   (instr_if_87),
   .npc_87     ( pc_out_if_87 ),

   .pc_87      (  32'b0   ),
   .sel_87     (   1'b0   ),
   .rst_87     (  rst_87  ),
   .clk_87     (  clk_87  )
);

//assign rreg_1_87 = instr_id_87[`FIELD_POS_RS+`FIELD_WIDTH_RSTD:`FIELD_POS_RS];
//assign rreg_2_87 = instr_id_87[`FIELD_POS_RD+`FIELD_WIDTH_RSTD:`FIELD_POS_RD];

wire reg_wb_id_87;
wire mem2reg_id_87;
wire branch_id_87;
wire mem_rd_id_87;
wire mem_wb_id_87;
wire reg_dst_id_87;
wire alu_src_id_87;
wire [1:0] jmp_op_id_87;
wire [1:0] alu_op_id_87;

wire [`ADDR_WIDTH-1:0] pc_out_id_87;

wire [`DATA_WIDTH-1:0] data_1_id_87;
wire [`DATA_WIDTH-1:0] data_2_id_87;
wire [`DATA_WIDTH-1:0] immed_id_87;
wire [`DATA_WIDTH-1:0] jmp_addr_87;

wire [`INSTR_WIDTH-1:0] instr_id_87;

wire [`FIELD_WIDTH_RSTD-1:0] trgt_reg_id_87;
wire [`FIELD_WIDTH_RSTD-1:0] dest_reg_id_87;

wire [`FIELD_WIDTH_OP-1:0] op_id_87;
wire [`FIELD_WIDTH_FUNC-1:0] fn_id_87;

wire reg_write_wbu_87;
wire [`DATA_WIDTH-1:0] wb_data_out_wbu_87;
wire [`FIELD_WIDTH_RSTD-1:0] wb_reg_out_wbu_87;

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
   .j_addr_87        (  jmp_addr_87    ),
   .immd_87          (  immed_id_87    ),
   .op_87            (  op_id_87       ),
   .rt_87            (  trgt_reg_id_87 ),
   .rd_87            (  dest_reg_id_87 ),
   .fn_87            (  fn_id_87       ),
   .pc_out_87        (  pc_out_id_87   ),

   .pc_in_87         (  pc_out_if_87      ),
   .instr_87         (  instr_if_87    ),
   .reg_2_write_87   (wb_reg_out_wbu_87),
   .data_2_write_87  (wb_data_out_wbu_87),
   .en_wb_87         (reg_write_wbu_87 ),
   .rst_87           (  rst_87         ),
   .clk_87           (  clk_87         )
);

wire zero_ex_87;
wire branch_out_ex_87;
wire mem_read_out_ex_87;
wire mem_write_out_ex_87;
wire reg_write_out_ex_87;
wire mem_2_reg_out_ex_87;
wire [`ADDR_WIDTH-1:0] br_addr_ex_87;
wire [`DATA_WIDTH-1:0] alu_out_ex_87;
wire [`ADDR_WIDTH-1:0] pc_out_ex_87;
wire [`DATA_WIDTH-1:0] wb_data_ex_87;
wire [`FIELD_WIDTH_RSTD-1:0] wb_reg_ex_87;

instr_ex exu (
   .zero_87(zero_ex_87),
   .pc_out_87(pc_out_ex_87),
   .br_addr_87(br_addr_ex_87),
   .adr_out_87(alu_out_ex_87),
   .wb_data_87(wb_data_ex_87),
   .wb_radr_87(wb_reg_ex_87),

   .branch_out_87(branch_out_ex_87),
   .mem_read_out_87(mem_read_out_ex_87),
   .mem_write_out_87(mem_write_out_ex_87),
   .reg_write_out_87(reg_write_out_ex_87),
   .mem_2_reg_out_87(mem_2_reg_out_ex_87),

   .branch_in_87(branch_id_87),
   .mem_read_in_87(mem_rd_id_87),
   .mem_write_in_87(mem_wb_id_87),
   .reg_write_in_87(reg_wb_id_87),
   .mem_2_reg_in_87(mem2reg_id_87),

   .reg_dst_87(reg_dst_id_87),
   .alu_src_87(alu_src_id_87),
   .alu_ctl_87(alu_op_id_87),
   .jmp_sel_87(jmp_op_id_87),

   .trgt_r_in_87(trgt_reg_id_87),
   .dest_r_in_87(dest_reg_id_87),
   .op_87(op_id_87),
   .fn_87(fn_id_87),
   .imm_s_87(immed_id_87),
   .rval_a_87(data_1_id_87),
   .rval_b_87(data_2_id_87),
   .pc_in_87(pc_ex_87),
   .rst_87(rst_87),
   .clk_87(clk_87)
);

wire [`ADDR_WIDTH-1:0] pc_out_dm_87;
wire [`ADDR_WIDTH-1:0] b_addr_mem_87;
wire [`DATA_WIDTH-1:0] mem_data_out_87;
wire [`ADDR_WIDTH-1:0] mem_addr_out_87;
wire [`FIELD_WIDTH_RSTD-1:0] wb_reg_mem_87;
wire mem_2_reg_dm_87;

mem dmu (
   .branch_taken_87(br_taken_mem_87),
   .branch_adr_out_87(b_addr_mem_87),

   .rd_data_87(mem_data_out_87),
   .wb_addr_87(mem_addr_out_87),
   .wb_reg_out_87(wb_reg_mem_87),
   .mem_2_reg_out_87(mem_2_reg_dm_87),
   .pc_out_87(pc_out_dm_87),
   
   .pc_in_87(pc_out_ex_87),
   .mem_2_reg_in_87(mem_2_reg_out_ex_87),
   .wb_reg_in_87(wb_reg_ex_87),
   .wb_data_87(wb_data_ex_87),
   .rd_addr_87(alu_out_ex_87),
   .branch_adr_in_87(br_addr_ex_87),
   .mem_read_87(mem_read_out_ex_87),
   .mem_write_87(mem_write_out_ex_87),
   .branch_in_87(branch_out_ex_87),
   .zero_flag_87(zero_ex_87),

   .rst_87(rst_87),
   .clk_87(clk_87)
);

write_back wbu (
   .reg_write_out_87(reg_write_wbu_87),
   .wb_data_87(wb_data_out_wbu_87),
   .wb_reg_out_87(wb_reg_out_wbu_87),

   .reg_write_in_87(mem_write_out_ex_87),
   .mem_2_reg_in_87(mem_2_reg_dm_87),
   .mem_data_in_87(mem_data_out_87),
   .mem_addr_in_87(mem_addr_out_87),
   .wb_reg_in_87(wb_reg_mem_87),

   .rst_87(rst_87),
   .clk_87(clk_87)
);

endmodule // simple_mips