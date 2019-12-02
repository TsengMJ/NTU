module PC_Adder
(
    instrAddr_i,
    instrSize_i,
    pcNext_o
);

// Interface
input	[31:0] instrAddr_i;
input	[31:0] instrSize_i;
output	[31:0] pcNext_o ;

// Calculation
assign pcNext_o = instrAddr_i + instrSize_i;

endmodule
