module WB_Addr_MUX
(
    rtAddr_i,
    rdAddr_i,
    wbDst_i,
    wbAddr_o
);

// Interface
input  [4:0] rsAddr_i;
input  [4:0] rdAddr_i;
input  [1:0] wbDst_i;
output [4:0] wbAddr_o

// Calculation
assign wbAddr_o = (wbDst_i)? rsAddr_i: rdAddr_i;

endmodule
