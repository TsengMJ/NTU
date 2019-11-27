module Control(Op_i, RegDst_o, ALUOp_o, ALUSrc_o, RegWrite_o);

// Interface
input       [6:0] Op_i;
output      [0:0] RegDst_o;
output      [1:0] ALUOp_o;
output      [0:0] ALUSrc_o;
output      [0:0] RegWrite_o;

// Calculation
assign RegDst_o = 1'b1;
assign ALUSrc_o = (Op_i[5])? 1'b0: 1'b1;
assign ALUOp_o  = (Op_i[5])? 2'b10: 2'b01;
assign RegWrite_o = 1'b1;

endmodule
