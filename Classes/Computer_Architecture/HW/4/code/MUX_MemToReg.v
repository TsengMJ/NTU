module MUX_MemToReg
(
    memData_i,
    aluResult_i,
    memToReg_i,
    wbData_o
);

// Interface
input  [31:0] memData_i;
input  [31:0] aluResult_i;
input  [ 0:0] memToReg_i;
output [31:0] wbData_o

// Calculation
assign wbData_o = (memToReg_i)? memData_i: aluResult_i;

endmodule
