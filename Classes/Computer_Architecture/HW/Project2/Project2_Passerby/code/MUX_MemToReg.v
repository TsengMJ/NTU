module MUX_MemToReg
(
    memData_i,
    aluResult_i,
    memToReg_i,
    wbData_o
);

// Interface
input       [31:0]  memData_i;
input       [31:0]  aluResult_i;
input               memToReg_i;
output reg  [31:0]  wbData_o = 0;

// Calculation
always @(*)
begin
    wbData_o = (memToReg_i)? memData_i: aluResult_i;
end

endmodule
