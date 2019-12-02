module ALU_Input2_MUX
(
    rt_immMuxOutput_i,
    aluForwarding_i,
    memForwarding_i,
    forwardingB_i,
    aluInput2_o
);
//ForwardB = 00 ID/EX
//ForwardB = 10 EX/MEM
//ForwardB = 01 MEM/WB
// Interface
input [31:0] rt_immMuxOutput_i;
input [31:0] aluForwarding_i;
input [31:0] memForwarding_i;
input [1:0]  forwardingB_i;
output aluInput2_o;

// Calculate
assign aluInput2_o = (forwardingB_i[1])? aluForwarding_i : (forwardingA_i[0])? memForwarding_i:rt_immMuxOutput_i;
endmodule
