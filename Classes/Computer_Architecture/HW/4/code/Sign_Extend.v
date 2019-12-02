module Sign_Extend
(
    imm_i,
    immExtended_o
);

// Interface
input   [11:0] imm_i;
output  [31:0] immExtended_o;

// Calculate
assign immExtended_o[31:0] = { {20{imm_i[11]}}, imm_i[11:0] };

endmodule
