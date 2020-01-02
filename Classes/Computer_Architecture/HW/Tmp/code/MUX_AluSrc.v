module MUX_AluSrc
(
    currentData_i,
    aluForward_i,
    memForward_i,
    forwarSignal_i,
    output_o
);

//ForwardA = 00  ID/EX
//ForwardA = 10 EX/MEM
//ForwardA = 01 MEM/WB
// Interface
input       [31:0] currentData_i;
input       [31:0] aluForward_i;
input       [31:0] memForward_i;
input       [1:0]  forwarSignal_i;
output reg  [31:0] output_o = 0;

// Calculate
always @(*) begin
    output_o = (forwarSignal_i[1])? aluForward_i: (forwarSignal_i[0])? memForward_i: currentData_i;
end

endmodule