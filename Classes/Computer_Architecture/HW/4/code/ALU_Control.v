module ALU_Control
(
    funct_i,
    aluOp_i,
    aluCtrl_o
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
input       [9:0] funct_i;
input       [1:0] aluOp_i;
output reg  [3:0] aluCtrl_o;

// Calculate
always @(*)
begin
    case(funct_i)
        10'b0000000111: aluCtrl_o = 4'b0000;
        10'b0000000110: aluCtrl_o = 4'b0001;
        10'b0000000000: aluCtrl_o = 4'b0010;
        10'b0100000000: aluCtrl_o = 4'b0110;
        10'b0000001000: aluCtrl_o = 4'b0011;
    endcase

    if (funct_i[2:0] == 3'b010)
        aluCtrl_o = 4'b0010;

    if (aluOp_i == 2'b01)
        aluCtrl_o = 4'b0010;

end

endmodule
