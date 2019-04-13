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
   output wire system_halt_87,
   input wire rst_87,
   input wire clk_87
);

//wire system_halt_id_87;

wire [`ADDR_WIDTH-1:0] pc_if_id_87;
wire [`ADDR_WIDTH-1:0] pc_if_in_87; // address ultimately fed back to IF stage

wire [`INSTR_WIDTH-1:0] instr_if_id_87;

wire npc_src_87;
wire stall_pipeline_87;
wire branch_flag_id_87;
wire flush_if_stage_87;
wire [`ADDR_WIDTH-1:0] branch_addr_id_87;

// control signals
//wire zero_ex_87;
wire mem_read_out_ex_87;
wire mem_write_out_ex_87;
wire reg_write_out_ex_87;
wire mem_2_reg_out_ex_87;
wire [`DATA_WIDTH-1:0] alu_out_ex_87;
wire [`DATA_WIDTH-1:0] mem_data_ex_dm_87;
wire [`RADDR_WIDTH-1:0] reg_addr_ex_dm_87;

//assign npc_src_87 = jump_flag_id_87 || branch_flag_id_87;
//assign pc_if_in_87 = jump_flag_id_87 ? jump_adr_id_out_87 : branch_addr_id_87;

instr_fetch ifu (
   .instr_87   (instr_if_id_87),
   .npc_87     (pc_if_id_87),

   //.pc_87      (pc_if_in_87),
   //.sel_87     (npc_src_87),
   .pc_87      (branch_addr_id_87),
   .sel_87     (branch_flag_id_87),
   .flush_87   (flush_if_stage_87),
   .stall_87   (stall_pipeline_87),
   .rst_87     (rst_87),
   .clk_87     (clk_87)
);

wire reg_write_id_ex_87;
wire mem_2_reg_id_ex_87;
wire mem_read_id_ex_87;
wire mem_wbck_id_ex_87;
wire reg_dst_id_ex_87;
wire alu_src_id_ex_87;
wire [1:0] alu_ctl_id_ex_87;

wire [`DATA_WIDTH-1:0] data_out_1_id_ex_87;
wire [`DATA_WIDTH-1:0] data_out_2_id_ex_87;
wire [`DATA_WIDTH-1:0] immed_out_id_ex_87;

wire [`RADDR_WIDTH-1:0] rt_id_ex_87;
wire [`RADDR_WIDTH-1:0] rd_id_ex_87;

wire [`FIELD_WIDTH_OP-1:0] op_code_id_ex_87;
wire [`FIELD_WIDTH_FUNC-1:0] fn_code_id_ex_87;

wire reg_write_wb_id_87;
wire [`DATA_WIDTH-1:0] wr_data_wb_id_87;
wire [`RADDR_WIDTH-1:0] wr_addr_wb_id_87;


wire [`RADDR_WIDTH-1:0] rt_id_in_hz_87;
wire [`RADDR_WIDTH-1:0] rs_id_in_hz_87;

instr_decode idu (
   .reg_write_87     (reg_write_id_ex_87),
   .reg_dest_87      (reg_dst_id_ex_87),
   .mem_to_reg_87    (mem_2_reg_id_ex_87),
   .mem_read_87      (mem_read_id_ex_87),
   .mem_write_87     (mem_wbck_id_ex_87),
   .alu_src_87       (alu_src_id_ex_87),
   .alu_op_87        (alu_ctl_id_ex_87),
   .data_read_1_87   (data_out_1_id_ex_87),
   .data_read_2_87   (data_out_2_id_ex_87),
   .immd_87          (immed_out_id_ex_87),
   .op_87            (op_code_id_ex_87),
   .fn_87            (fn_code_id_ex_87),
   .rt_87            (rt_id_ex_87),
   .rd_87            (rd_id_ex_87),
   .rs_async_out_87  (rs_id_in_hz_87),
   .rt_async_out_87  (rt_id_in_hz_87),

   .branch_flag_87   (branch_flag_id_87),
   .pc_out_87        (branch_addr_id_87),
   .flush_flag_87    (flush_if_stage_87),

   //.system_halt_87   (system_halt_id_87),
   .system_halt_87   (system_halt_87),

   .stall_87         (stall_pipeline_87),
   .pc_in_87         (pc_if_id_87),
   .instr_87         (instr_if_id_87),
   .reg_2_write_87   (wr_addr_wb_id_87),
   .data_2_write_87  (wr_data_wb_id_87),
   .en_wb_87         (reg_write_wb_id_87),
   .rst_87           (rst_87),
   .clk_87           (clk_87)
);

instr_ex exu (
   .result_87           (alu_out_ex_87),
   .write_back_data_87  (mem_data_ex_dm_87),
   .reg_write_addr_87   (reg_addr_ex_dm_87),
   .mem_read_out_87     (mem_read_out_ex_87),
   .mem_write_out_87    (mem_write_out_ex_87),
   .reg_write_out_87    (reg_write_out_ex_87),
   .mem_2_reg_out_87    (mem_2_reg_out_ex_87),

   .mem_read_in_87      (mem_read_id_ex_87),
   .mem_write_in_87     (mem_wbck_id_ex_87),
   .reg_write_in_87     (reg_write_id_ex_87),
   .mem_2_reg_in_87     (mem_2_reg_id_ex_87),
   .reg_dst_87          (reg_dst_id_ex_87),
   .alu_src_87          (alu_src_id_ex_87),
   .alu_ctl_87          (alu_ctl_id_ex_87),
   .rt_in_87            (rt_id_ex_87),
   .rd_in_87            (rd_id_ex_87),
   .op_87               (op_code_id_ex_87),
   .fn_87               (fn_code_id_ex_87),
   .imm_s_87            (immed_out_id_ex_87),
   .rval_a_87           (data_out_1_id_ex_87),
   .rval_b_87           (data_out_2_id_ex_87),
   .rst_87              (rst_87),
   .clk_87              (clk_87)
);

wire [`ADDR_WIDTH-1:0] b_addr_mem_87;
wire [`DATA_WIDTH-1:0] mem_data_out_87;
wire [`ADDR_WIDTH-1:0] mem_addr_out_87;
wire [`RADDR_WIDTH-1:0] wb_reg_mem_87;
wire mem_2_reg_dm_wb_87;
wire reg_write_dm_wb_87;

mem dmu (
   .mem_data_out_87     (mem_data_out_87),
   .mem_addr_out_87     (mem_addr_out_87),
   .reg_addr_out_87     (wb_reg_mem_87),
   .mem_2_reg_out_87    (mem_2_reg_dm_wb_87), 
   .reg_write_out_87    (reg_write_dm_wb_87),
   
   .mem_2_reg_in_87     (mem_2_reg_out_ex_87),
   .mem_read_in_87      (mem_read_out_ex_87),
   .mem_write_in_87     (mem_write_out_ex_87),
   .mem_data_in_87      (mem_data_ex_dm_87),
   .reg_addr_in_87      (reg_addr_ex_dm_87),
   .reg_write_in_87     (reg_write_out_ex_87),
   .mem_addr_in_87      (alu_out_ex_87),
   .rst_87              (rst_87),
   .clk_87              (clk_87)
);

write_back wbu (
   .reg_write_out_87 (reg_write_wb_id_87),
   .wb_data_87       (wr_data_wb_id_87),
   .wb_reg_out_87    (wr_addr_wb_id_87),

   .reg_write_in_87  (reg_write_dm_wb_87),
   .mem_2_reg_in_87  (mem_2_reg_dm_wb_87),
   .mem_data_in_87   (mem_data_out_87),
   .mem_addr_in_87   (mem_addr_out_87),
   .wb_reg_in_87     (wb_reg_mem_87),
   .rst_87           (rst_87),
   .clk_87           (clk_87)
);

hazard_ctl hzu (
   .stall_87      (stall_pipeline_87),
   
   .r1_id_in_87   (rs_id_in_hz_87),
   .r2_id_in_87   (rt_id_in_hz_87),
   .rd_id_ex_87   (rd_id_ex_87),
   .rd_ex_dm_87   (reg_addr_ex_dm_87),
   .rd_dm_wb_87   (wb_reg_mem_87),
   .rd_wb_id_87   (wr_addr_wb_id_87),
   .rst_87        (rst_87)
);

endmodule // simple_mips