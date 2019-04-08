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

wire [`INSTR_WIDTH-1:0] instr_if_id_87;
wire [`ADDR_WIDTH-1:0] pc_out_if_87;
wire [`ADDR_WIDTH-1:0] pc_ex_87;


wire  [`FIELD_WIDTH_RSTD-1:0] wreg_id_87;
wire  [`FIELD_WIDTH_RSTD-1:0] rt_id_87;
wire  [`FIELD_WIDTH_RSTD-1:0] rd_id_87;

wire pc_src_87;   // from data-memory stage
wire jump_j_87;   // jump flag
wire jump_r_87;   // jump register flag

instr_fetch ifu (
   .instr_87   (instr_if_id_87),
   .npc_87     ( pc_out_if_87 ),

   .pc_87      (  32'b0   ),
   .sel_87     (   1'b0   ),
   .rst_87     (  rst_87  ),
   .clk_87     (  clk_87  )
);

//assign rreg_1_87 = instr_id_87[`FIELD_POS_RS+`FIELD_WIDTH_RSTD:`FIELD_POS_RS];
//assign rreg_2_87 = instr_id_87[`FIELD_POS_RD+`FIELD_WIDTH_RSTD:`FIELD_POS_RD];

wire reg_write_id_ex_87;
wire mem_2_reg_id_ex_87;
wire branch_id_ex_87;
wire mem_read_id_ex_87;
wire mem_wbck_id_ex_87;
wire reg_dst_id_ex_87;
wire alu_src_id_ex_87;
wire [1:0] jmp_ctl_id_ex_87;
wire [1:0] alu_ctl_id_ex_87;

wire [`ADDR_WIDTH-1:0] pc_out_id_87;

wire [`DATA_WIDTH-1:0] data_out_1_id_ex_87;
wire [`DATA_WIDTH-1:0] data_out_2_id_ex_87;
wire [`DATA_WIDTH-1:0] immed_out_id_ex_87;
wire [`DATA_WIDTH-1:0] jump_adr_out_id_87;

wire [`RADDR_WIDTH-1:0] rs_id_ex_87;
wire [`RADDR_WIDTH-1:0] rt_id_ex_87;
wire [`RADDR_WIDTH-1:0] rd_id_ex_87;

wire [`FIELD_WIDTH_OP-1:0] op_code_id_ex_87;
wire [`FIELD_WIDTH_FUNC-1:0] fn_code_id_ex_87;

wire reg_write_wb_id_87;
wire [`DATA_WIDTH-1:0] wbck_data_wb_id_87;
wire [`RADDR_WIDTH-1:0] wr_wb_id_87;


wire [`RADDR_WIDTH-1:0] rt_id_in_hz_87;
wire [`RADDR_WIDTH-1:0] rs_id_in_hz_87;

instr_decode idu (
   .reg_write_87     (  reg_write_id_ex_87   ),
   .reg_dst_87       (  reg_dst_id_ex_87     ),
   .mem_to_reg_87    (  mem_2_reg_id_ex_87   ),
   .branch_87        (  branch_id_ex_87      ),
   .jump_sel_87      (  jmp_ctl_id_ex_87     ),
   .mem_read_87      (  mem_read_id_ex_87    ),
   .mem_write_87     (  mem_wbck_id_ex_87    ),
   .alu_src_87       (  alu_src_id_ex_87     ),
   .alu_op_87        (  alu_ctl_id_ex_87     ),

   .data_read_1_87   (  data_out_1_id_ex_87  ),
   .data_read_2_87   (  data_out_2_id_ex_87  ),
   .jump_addr_out_87 (  jump_adr_out_id_87   ),
   .immd_87          (  immed_out_id_ex_87   ),
   .op_87            (  op_code_id_ex_87     ),
   .rs_87            (  rs_id_ex_87          ),
   .rt_87            (  rt_id_ex_87          ),
   .rd_87            (  rd_id_ex_87          ),
   .fn_87            (  fn_code_id_ex_87     ),
   .pc_out_87        (  pc_out_id_87         ),

   .rs_async_out_87  (  rs_id_in_hz_87       ),
   .rt_async_out_87  (  rt_id_in_hz_87       ),

   .pc_in_87         (  pc_out_if_87         ),
   .instr_87         (  instr_if_id_87       ),
   .reg_2_write_87   (  wr_wb_id_87    ),
   .data_2_write_87  (  wbck_data_wb_id_87   ),
   .en_wb_87         (  reg_write_wb_id_87   ),
   .rst_87           (  rst_87               ),
   .clk_87           (  clk_87               )
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

   .branch_in_87(branch_id_ex_87),
   .mem_read_in_87(mem_read_id_ex_87),
   .mem_write_in_87(mem_wbck_id_ex_87),
   .reg_write_in_87(reg_write_id_ex_87),
   .mem_2_reg_in_87(mem_2_reg_id_ex_87),

   .reg_dst_87(reg_dst_id_ex_87),
   .alu_src_87(alu_src_id_ex_87),
   .alu_ctl_87(alu_ctl_id_ex_87),
   .jmp_sel_87(jmp_ctl_id_ex_87),

   .rt_in_87(rt_id_ex_87),
   .rd_in_87(rd_id_ex_87),
   .op_87(op_code_id_ex_87),
   .fn_87(fn_code_id_ex_87),
   .imm_s_87(immed_out_id_ex_87),
   .rval_a_87(data_out_1_id_ex_87),
   .rval_b_87(data_out_2_id_ex_87),
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
   .branch_taken_87(pc_src_87),
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
   .reg_write_out_87(reg_write_wb_id_87),
   .wb_data_87(wbck_data_wb_id_87),
   .wb_reg_out_87(wr_wb_id_87),

   .reg_write_in_87(mem_write_out_ex_87),
   .mem_2_reg_in_87(mem_2_reg_dm_87),
   .mem_data_in_87(mem_data_out_87),
   .mem_addr_in_87(mem_addr_out_87),
   .wb_reg_in_87(wb_reg_mem_87),

   .rst_87(rst_87),
   .clk_87(clk_87)
);

hazard_ctl hzu (
   .stall_87(),
   
   .r1_id_in_87(rs_id_in_hz_87),
   .r2_id_in_87(rt_id_in_hz_87),
   .rd_id_ex_87(rd_id_ex_87),
   .rd_ex_dm_87(wb_reg_ex_87),
   .rd_dm_wb_87(wb_reg_mem_87),
   .rd_wb_id_87(wr_wb_id_87),
   .rst_87(rst_87),
   .clk_87(clk_87)
);

endmodule // simple_mips