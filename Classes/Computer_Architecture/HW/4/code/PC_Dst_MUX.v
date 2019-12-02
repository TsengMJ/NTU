module PC_Dst_MUX
(
    pcBranch_i,
    pcNext_i,
    branchSignal_i,
    pc_o
);

// Interface
input   [31:0] pcBranch_i;
input   [31:0] pcNext_i;
input   [31:0] branchSignal_i;
output  [31:0] pc_o;

// Calculate
assign pc_o = (branchSignal_i)? pcBranch_i: pcNext_i;

endmodule
