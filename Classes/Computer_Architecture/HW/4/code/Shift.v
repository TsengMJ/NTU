module Shift
(
    immExtended_i,
    immShifted_o
);

// Interface
input   [31:0] immExtended_i;
output  [31:0] immShifted_o;

// Calculate
assign immShifted_o = immExtended_i <<< 1;

endmodule
