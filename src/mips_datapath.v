////////////////////////////////////////////////////////////////////////////////
// Module:  mips_datapath.v
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

module mips_datapath(
   input wire rst_87,
   input wire clk_87
);

wire reg_write_87;
wire mem_to_reg_87;
wire branch_87;
wire jump_87;
wire mem_read_87;
wire mem_write_87;
wire alu_src_87;
wire [3:0] alu_op_87;

wire [`INSTR_WIDTH-1:0] instr_if_87,
                        instr_id_87;

wire [`ADDR_WIDTH-1:0]  pc_if_87,
                        pc_id_87,
                        pc_id_out_87,
                        pc_ex_87;

wire  [`DATA_WIDTH-1:0] data_out_1_id_87,
                        data_out_2_id_87,
                        immed_id_87;

wire  [`FIELD_WIDTH_OP-1:0]   op_id_87,
                              fn_id_87;

wire  [`FIELD_WIDTH_RSTD-1:0] wreg_id_87,
                              rt_id_87,
                              rd_id_87;

instr_fetch_unit ifu (
   .instr_87   (instr_if_87),
   .pc_87      ( pc_if_87 ),
   .npc_87     (  32'b0   ),
   .sel_87     (   1'b0   ),
   .rst_87     (  rst_87  ),
   .clk_87     (  clk_87  )
);

vl_dff #(.width(`INSTR_WIDTH), .reset_value(`INSTR_WIDTH'b0)) dff_instr_if (
   .d    (  instr_if_87   ),
   .q    (  instr_id_87   ),
   .rst  (    rst_87      ),
   .clk  (    clk_87      )
);

vl_dff #(.width(`ADDR_WIDTH)) dff_pc_if (
   .d    (  pc_if_87 ),
   .q    (  pc_id_87 ),
   .rst  (  rst_87   ),
   .clk  (  clk_87   )
);

//assign rreg_1_87 = instr_id_87[`FIELD_POS_RS+`FIELD_WIDTH_RSTD:`FIELD_POS_RS];
//assign rreg_2_87 = instr_id_87[`FIELD_POS_RD+`FIELD_WIDTH_RSTD:`FIELD_POS_RD];

instr_decode_unit idu (
   .reg_write_87     (  reg_write_87   ),
   .mem_to_reg_87    (  mem_to_reg_87  ),
   .branch_87        (  branch_87      ),
   .jump_87          (  jump_87        ),
   .mem_read_87      (  mem_read_87    ),
   .mem_write_87     (  mem_write_87   ),
   .alu_src_87       (  alu_src_87     ),
   .alu_op_87        (  alu_op_87      ),
   .data_read_1_87   ( data_out_1_id_87),
   .data_read_2_87   ( data_out_2_id_87),
   .immd_87          (  immed_id_87    ),
   .op_87            (     op_id_87    ),
   .fn_87            (     fn_id_87    ),
   .pc_out_87        (  pc_id_out_87   ),
   .pc_in_87         (     pc_id_87    ),
   .instr_87         (  instr_id_87    ),
   .reg_2_write_87   (`FIELD_WIDTH_RSTD'b0),
   .data_2_write_87  (`DATA_WIDTH'b0   ),
   .en_wb_87         (  1'b0           ),
   .rst_87           (  rst_87         ),
   .clk_87           (  clk_87         )
);

endmodule // mips_datapath