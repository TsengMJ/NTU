module MUX_Stall
(
    hazardDetected_i,
    aluOp_i,
    aluSrc_i,
    // wbDst_i,
    memRead_i,
    memWrite_i,
    memToReg_i,
    regWrite_i,
    zero_i,

    aluOp_o,
    aluSrc_o,
    // wbDst_o,
    memRead_o,
    memWrite_o,
    memToReg_o,
    regWrite_o
);

// Interface
input   [0:0] hazardDetected_i;
input   [1:0] aluOp_i;
input   [0:0] aluSrc_i;
input   [0:0] memRead_i;
input   [0:0] memWrite_i;
input   [0:0] memToReg_i;
input   [0:0] regWrite_i;
input   [0:0] zero_i;

output reg  [1:0] aluOp_o = 0;
output reg  [0:0] aluSrc_o = 0;
output reg  [0:0] memRead_o = 0;
output reg  [0:0] memWrite_o = 0;
output reg  [0:0] memToReg_o = 0;
output reg  [0:0] regWrite_o = 0;

// Calculate
always @(*) begin
    aluOp_o    = (hazardDetected_i)? 2'b00: aluOp_i;
    aluSrc_o   = (hazardDetected_i)? 1'b0: aluSrc_i;
    memRead_o  = (hazardDetected_i)? 1'b0: memRead_i;
    memWrite_o = (hazardDetected_i)? 1'b0: memWrite_i;
    memToReg_o = (hazardDetected_i)? 1'b0: memToReg_i;
    regWrite_o = (hazardDetected_i)? 1'b0: regWrite_i;
end

endmodule