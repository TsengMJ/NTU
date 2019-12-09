module Register_EX_MEM
(
    clk_i,

    memRead_i,
    memWrite_i,
    memToReg_i,
    regWrite_i,
    aluResult_i,
    aluSrc2_i,
    wbAddr_i,

    memRead_o,
    memWrite_o,
    memToReg_o,
    regWrite_o,
    aluResult_o,
    aluSrc2_o,
    wbAddr_o
);

// Interface
input           clk_i;
input   [0:0]   memRead_i;
input   [0:0]   memWrite_i;
input   [0:0]   memToReg_i;
input   [0:0]   regWrite_i;
input   [31:0]  aluResult_i;
input   [31:0]  aluSrc2_i;
input   [4:0]   wbAddr_i;

output  reg  [0:0]   memRead_o;
output  reg  [0:0]   memWrite_o;
output  reg  [0:0]   memToReg_o;
output  reg  [0:0]   regWrite_o;
output  reg  [31:0]  aluResult_o;
output  reg  [31:0]  aluSrc2_o;
output  reg  [4:0]   wbAddr_o;

//
// reg [31:0] pipeRegister [:0]

// Calculation
always @ (posedge clk_i) begin
    memRead_o   <= memRead_i;
    memWrite_o  <= memWrite_i;
    memToReg_o  <= memToReg_i;
    regWrite_o  <= regWrite_i;
    aluResult_o <= aluResult_i;
    aluSrc2_o   <= aluSrc2_i;
    wbAddr_o    <= wbAddr_i;
end

endmodule