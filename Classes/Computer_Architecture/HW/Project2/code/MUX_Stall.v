module MUX_Stall
(
    hazardDetected_i,
    aluOp_i,
    aluSrc_i,
    memRead_i,
    memWrite_i,
    memToReg_i,
    regWrite_i,
    zero_i,

    aluOp_o,
    aluSrc_o,
    memRead_o,
    memWrite_o,
    memToReg_o,
    regWrite_o
);

// Interface
input               hazardDetected_i;
input       [1:0]   aluOp_i;
input               aluSrc_i;
input               memRead_i;
input               memWrite_i;
input               memToReg_i;
input               regWrite_i;
input               zero_i;

output reg  [1:0]   aluOp_o = 2'b0;
output reg          aluSrc_o = 1'b0;
output reg          memRead_o = 1'b0;
output reg          memWrite_o = 1'b0;
output reg          memToReg_o = 1'b0;
output reg          regWrite_o = 1'b0;

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
