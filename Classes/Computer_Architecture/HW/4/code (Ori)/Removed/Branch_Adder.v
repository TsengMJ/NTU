module Branch_Adder
(
    immShifted_i,
    instrAddr_i,
    pcBranch_o
);

// Interface
input   [31:0] immShifted_i;
input   [31:0] instrAddr_i;
output  [31:0] pcBranch_o;

// Calculate
assign pcBranch_o = immShifted_i + instrAddr_i;

endmodule
