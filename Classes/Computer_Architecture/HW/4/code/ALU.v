module ALU
(
    aluInput1_i,
    aluInput2_i,
    aluCtrl_i,
    aluResult_o
);

//          funct    : aluOp : aluCtrl
// and -> 0000000111 : 10    : 0000
// or  -> 0000000110 : 10    : 0001
// add -> 0000000000 : 10    : 0010
// addi-> xxxxxxx000 : 01    : 0010
// sub -> 0100000000 : 10    : 0110
// mul -> 0000001000 : 10    : 0011
// lw  -> xxxxxxx010 : 00    : 0010
// sw  -> xxxxxxx010 : 00    : 0010
// beq -> xxxxxxx000 : 01    : 0110 -> don't care

// Interface
input       [31:0] aluInput1_i;
input       [31:0] aluInput2_i;
input       [ 3:0] aluCtrl_i;
output reg  [31:0] aluResult_o;

// Calculate
always @(*)
begin
    case (aluCtrl_i)
        4'b0000: aluResult_o = aluInput1_i & aluInput2_i;
        4'b0001: aluResult_o = aluInput1_i | aluInput2_i;
        4'b0010: aluResult_o = aluInput1_i + aluInput2_i;
        4'b0110: aluResult_o = aluInput1_i - aluInput2_i;
        4'b0011: aluResult_o = aluInput1_i * aluInput2_i;
        4'b0110: aluResult_o = aluInput1_i - aluInput2_i;
    endcase
end

endmodule