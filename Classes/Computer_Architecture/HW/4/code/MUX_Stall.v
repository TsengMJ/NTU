module MUX_Stall
(
    hazardDetected_i,
    aluOp_i,
    aluSrc_i,
    wbDst_i,
    memRead_i,
    memWrite_i,
    memToReg_i,
    regWrite_i,
    zero_i,

    aluOp_o,
    aluSrc_o,
    wbDst_o,
    memRead_o,
    memWrite_o,
    memToReg_o,
    regWrite_i
);

// Interface
input   [0:0] hazardDetected_i,
input   [1:0] aluOp_i,
input   [0:0] aluSrc_i,
input   [0:0] wbDst_i,
input   [0:0] memRead_i,
input   [0:0] memWrite_i,
input   [0:0] memToReg_i
input   [0:0] regWrite_i,
input   [0:0] zero_i,

output  [1:0] aluOp_o,
output  [0:0] aluSrc_o,
output  [0:0] wbDst_o,
output  [0:0] memRead_o,
output  [0:0] memWrite_o,
output  [0:0] memToReg_o
output  [0:0] regWrite_o,

// Calculate
assign aluOp_o    = (hazardDetected_i)? zero_i: aluOp_i;
assign aluSrc_o   = (hazardDetected_i)? zero_i: aluSrc_i;
assign wbDst_o    = (hazardDetected_i)? zero_i: wbDst_i;
assign memRead_o  = (hazardDetected_i)? zero_i: memRead_i;
assign memWrite_o = (hazardDetected_i)? zero_i: memWrite_i;
assign memToReg_o = (hazardDetected_i)? zero_i: memToReg_i;
assign regWrite_0 = (hazardDetected_i)? zero_i: regWrite_i;


endmodule
