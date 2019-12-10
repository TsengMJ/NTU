module Register_ID_EX
(
    clk_i,

    aluOp_i,
    aluSrc_i,
    // wbDst_i,
    memRead_i,
    memWrite_i,
    memToReg_i,
    regWrite_i,
    rsData_i,
    rtData_i,
    immExtended_i,
    rsAddr_i,
    rtAddr_i,
    rdAddr_i,
    wbAddr_i,
    funct_i,

    aluOp_o,
    aluSrc_o,
    // wbDst_o,
    memRead_o,
    memWrite_o,
    memToReg_o,
    regWrite_o,
    rsData_o,
    rtData_o,
    immExtended_o,
    rsAddr_o,
    rtAddr_o,
    rdAddr_o,
    wbAddr_o,
    funct_o
);
// Interface
input           clk_i;
input   [1:0]   aluOp_i;
input   [0:0]   aluSrc_i;
input   [0:0]   memRead_i;
input   [0:0]   memWrite_i;
input   [0:0]   memToReg_i;
input   [0:0]   regWrite_i;
input   [31:0]  rsData_i;
input   [31:0]  rtData_i;
input   [31:0]  immExtended_i;
input   [4:0]   rsAddr_i;
input   [4:0]   rtAddr_i;
input   [4:0]   rdAddr_i;
input   [4:0]   wbAddr_i;
input   [9:0]   funct_i;

output  reg  [1:0]   aluOp_o;
output  reg  [0:0]   aluSrc_o;
output  reg  [0:0]   memRead_o;
output  reg  [0:0]   memWrite_o;
output  reg  [0:0]   memToReg_o;
output  reg  [0:0]   regWrite_o;
output  reg  [31:0]  rsData_o;
output  reg  [31:0]  rtData_o;
output  reg  [31:0]  immExtended_o;
output  reg  [4:0]   rsAddr_o;
output  reg  [4:0]   rtAddr_o;
output  reg  [4:0]   rdAddr_o;
output  reg  [4:0]   wbAddr_o;
output  reg  [9:0]   funct_o;

reg  [1:0]   aluOp_reg = 0;
reg  [0:0]   aluSrc_reg = 0;
reg  [0:0]   memRead_reg = 0;
reg  [0:0]   memWrite_reg = 0;
reg  [0:0]   memToReg_reg = 0;
reg  [0:0]   regWrite_reg = 0;
reg  [31:0]  rsData_reg = 0;
reg  [31:0]  rtData_reg = 0;
reg  [31:0]  immExtended_reg = 0;
reg  [4:0]   rsAddr_reg = 0;
reg  [4:0]   rtAddr_reg = 0;
reg  [4:0]   rdAddr_reg = 0;
reg  [4:0]   wbAddr_reg = 0;
reg  [9:0]   funct_reg = 0;


// Calculation
always @ (posedge clk_i ) begin

    if (clk_i) begin
        aluOp_o    <= aluOp_i;
        aluSrc_o   <= aluSrc_i;
        memRead_o  <= memRead_i;
        memWrite_o <= memWrite_i;
        memToReg_o <= memToReg_i;
        regWrite_o <= regWrite_i;
        rsData_o   <= rsData_i;
        rtData_o   <= rtData_i;
        immExtended_o <= immExtended_i;
        rsAddr_o   <= rsAddr_i;
        rtAddr_o   <= rtAddr_i;
        rdAddr_o   <= rdAddr_i;
        wbAddr_o   <= wbAddr_i;
        funct_o    <= funct_i;        
    end

end

endmodule