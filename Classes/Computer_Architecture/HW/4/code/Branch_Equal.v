module Branch_Equal
(
    rsData_i,
    rtData_i,
    equal_o
);

// Interface
input   [31:0] rsData_i;
input   [31:0] rtData_i;
output reg  [0:0] equal_o = 0;

// Calculate
always @(*) begin
    equal_o = (rsData_i == rtData_i)? 1'b1: 1'b0;
end

endmodule
