module RT_IMM_MUX
(
    rtData_i,
    immExtended_i,
    alu_rtimmResource_i,
    rt_immMuxOutput_o
);


// Interface
input  [31:0] rtData_i;
input  [31:0] immExtended_i;
input  		  alu_rtimmResource_i;

output [31:0] rt_immMuxOutput_o ;
// Calculate

assign rt_immMuxOutput_o = (alu_rtimmResource_i)? immExtended_i:rtData_i;
endmodule
