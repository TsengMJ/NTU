module Adder
(
    operand1_i,
    operand2_i,
    result_o
);

// Interface
input	    [31:0]  operand1_i;
input	    [31:0]  operand2_i;
output  reg	[31:0]  result_o = 32'b0;

// Calculation
always @(*) begin
    result_o = operand1_i + operand2_i;
end


endmodule