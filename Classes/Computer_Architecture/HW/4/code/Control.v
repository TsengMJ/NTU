module Control
(
    opCode_i,
    equal_i,
    branch_o,
    aluOP_o,
    aluSrc_o,
    memRead_o,
    memWrite_o,
    memToReg_o
);

//          funct    : aluOp : aluCtrl
// and -> 0000000111 : 10    : 0000
// or  ->i4'b0010 0000000110 : 10    : 0001
// add -> 0000000000 : 10    : 0010
// addi-> xxxxxxx000 : 01    : 0010
// sub -> 0100000000 : 10    : 0110
// mul -> 0000001000 : 10    : 0011
// lw  -> xxxxxxx010 : 00    : 0010
// sw  -> xxxxxxx010 : 00    : 0010
// beq -> xxxxxxx000 : 01    : 0110

// Interface



// Calculation

endmodule
