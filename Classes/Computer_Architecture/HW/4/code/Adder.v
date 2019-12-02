module Adder
(
    operand1_i,
    operand2_i,
    result_o
);

// Interface
input	[31:0] operand1_i;
input	[31:0] operand2_i;
output	[31:0] result_o;

// Calculation
assign result_o = operand1_i + operand2_i;

endmodule