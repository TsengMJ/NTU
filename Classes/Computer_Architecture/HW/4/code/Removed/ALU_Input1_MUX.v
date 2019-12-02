module ALU_Input1_MUX
(
    rsData_i,
    aluForwarding_i,
    memForwarding_i,
    forwardingA_i,
    aluInput1_o
);
//ForwardA = 00  ID/EX
//ForwardA = 10 EX/MEM
//ForwardA = 01 MEM/WB
// Interface
input  [31:0] rsData_i;
input  [31:0] aluForwarding_i;
input  [31:0] memForwarding_i;
input  [1:0]  forwardingA_i;
output [31:0] aluInput1_o;
// Calculate

assign aluInput1_o = (forwardingA_i[1])? aluForwarding_i : (forwardingA_i[0])? memForwarding_i:rsData_i;
endmodule
