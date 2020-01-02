module Register_ID_EX
(
    clk_i,
    stall_i,
    
    aluOp_i,
    aluSrc_i,
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
input               clk_i;
input               stall_i;

input       [1:0]   aluOp_i;
input               aluSrc_i;
input               memRead_i;
input               memWrite_i;
input               memToReg_i;
input               regWrite_i;
input       [31:0]  rsData_i;
input       [31:0]  rtData_i;
input       [31:0]  immExtended_i;
input       [4:0]   rsAddr_i;
input       [4:0]   rtAddr_i;
input       [4:0]   rdAddr_i;
input       [4:0]   wbAddr_i;
input       [9:0]   funct_i;

output  reg  [1:0]  aluOp_o = 2'b0;
output  reg         aluSrc_o = 1'b0;
output  reg         memRead_o = 1'b0;
output  reg         memWrite_o = 1'b0;
output  reg         memToReg_o = 1'b0;
output  reg         regWrite_o = 1'b0;
output  reg  [31:0] rsData_o   = 32'b0;
output  reg  [31:0] rtData_o  = 32'b0;
output  reg  [31:0] immExtended_o = 32'b0;
output  reg  [4:0]  rsAddr_o = 5'b0;
output  reg  [4:0]  rtAddr_o = 5'b0;
output  reg  [4:0]  rdAddr_o = 5'b0;
output  reg  [4:0]  wbAddr_o = 5'b0;
output  reg  [9:0]  funct_o = 10'b0;


// Calculation
always @(posedge clk_i) begin

    if (clk_i & ~stall_i) begin
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