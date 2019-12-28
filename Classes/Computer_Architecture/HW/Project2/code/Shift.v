module Shift
(
    immExtended_i,
    immShifted_o
);

// Interface
input       [31:0] immExtended_i;
output reg  [31:0] immShifted_o = 0;

// Calculate
always @(*) begin
    immShifted_o = immExtended_i <<< 1;
end

endmodule
