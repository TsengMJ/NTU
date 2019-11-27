module ALU_Control(funct_i, ALUOp_i, ALUCtrl_o);

// Interface
input       [9:0]  funct_i;
input       [1:0]  ALUOp_i;
output reg  [2:0]  ALUCtrl_o;

// Define
//`define AND 10'b0000000111;
//`define OR  10'b0000000110;
//`define ADD 10'b0000000000;
//`define SUB 10'b0100000000;
//`define MUL 10'b0000001000;


always @(*)
begin
    case(funct_i)
        10'b0000000111: ALUCtrl_o = 3'b000;
        10'b0000000110: ALUCtrl_o = 3'b001;
        10'b0000000000: ALUCtrl_o = 3'b010;
        10'b0100000000: ALUCtrl_o = 3'b110;
        10'b0000001000: ALUCtrl_o = 3'b011;
    endcase

    if(ALUOp_i == 2'b01)
        ALUCtrl_o = 3'b010;
end

endmodule
