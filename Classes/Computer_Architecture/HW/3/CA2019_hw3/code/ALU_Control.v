module ALU_Control(funct, ALUOp, ALUctr);

// Interface
input       [3:0] funct
input       [1:0] ALUOp
output      [2:0] ALUctr

//
always @(funct, ALUOp) begin
    if(funct[0])
        assign ALUctr
end


module
