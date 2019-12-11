module WB_Addr_MUX 
(
    rtAddr_i ,
    rdAddr_i ,
    wbDst_i  ,
    wbAddr_o 
);
//0 rt 1 rt
// Interface
input  [31:0] rtAddr_i;
input  [31:0] rdAddr_i;
input  		  wbDst_i;

output [31:0] wbAddr_o ;
// Calculate
assign wbAddr_o  = (wbDst_i)? rdAddr_i:rtAddr_i;

endmodule