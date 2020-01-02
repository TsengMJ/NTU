module Register_MEM_WB
(
    clk_i,
    stall_i,

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
input               clk_i;
input               stall_i;

input               memToReg_i;
input               regWrite_i;
input       [31:0]  memData_i;
input       [31:0]  aluResult_i;
input       [4:0]   wbAddr_i;

output  reg         memToReg_o = 0;
output  reg         regWrite_o = 0;
output  reg [31:0]  memData_o = 0;
output  reg [31:0]  aluResult_o = 0;
output  reg [4:0]   wbAddr_o = 0;


// Calculation
always @ (posedge clk_i) begin
    if (stall_i) begin
    end 
    else begin
        memToReg_o  <= memToReg_i;
        regWrite_o  <= regWrite_i;
        memData_o   <= memData_i;
        aluResult_o <= aluResult_i;
        wbAddr_o    <= wbAddr_i;       
    end
end


endmodule