module Branch_Equal
(
    rsData_i,
    rtData_i,
    equal_o
);

// Interface
input   [31:0] rsData_i;
input   [31:0] rtData_i;
output  [1:0] equal_o;

// Calculate
assign equal_o = (rsData_i == rtData_i)? 1'b1: 1'b0;

endmodule
