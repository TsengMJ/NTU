module Control(OpCode , ALUOp, ALUSrc, RegWrite);

// Interface
input       [6:0] OpCode;
output      [1:0] ALUOp;
output      [0:0] ALUSrc;
output      [0:0] RegWrite;

//
always @(OpCode) begin 
    if (OpCode[5])
        assign ALUSrc = 1'b0;
    else
        assign ALUSrc = 1'b1;
    
    assign ALUOp = 2'b10;
    assign RegWrite = 1'b1;
end

endmodule;
