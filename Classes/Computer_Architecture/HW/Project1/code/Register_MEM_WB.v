module Register_MEM_WB
(
    clk_i,

    memToReg_i,
    regWrite_i,
    memData_i,
    aluResult_i,
    wbAddr_i,

    memToReg_o,
    regWrite_o,
    memData_o,
    aluResult_o,
    wbAddr_o
);

// Interface
input       clk_i;
input   [0:0]   memToReg_i;
input   [0:0]   regWrite_i;
input   [31:0]  memData_i;
input   [31:0]  aluResult_i;
input   [5:0]   wbAddr_i;

output  reg  [0:0]   memToReg_o;
output  reg  [0:0]   regWrite_o;
output  reg  [31:0]  memData_o;
output  reg  [31:0]  aluResult_o;
output  reg  [5:0]   wbAddr_o;

// Calculation
always @ (posedge clk_i) begin
    memToReg_o  = memToReg_i;
    regWrite_o  = regWrite_i;
    memData_o   = memData_i;
    aluResult_o = aluResult_i;
    wbAddr_o    = wbAddr_i;
end


endmodule