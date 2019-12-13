module Control
(
    opCode_i,
    equal_i,


    branch_o,

    aluOp_o,
    aluSrc_o,


    wbDst_o,

    memRead_o,
    memWrite_o,
    memToReg_o,


    regWrite_o
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
input       [6:0]   opCode_i;
input               equal_i;

output              branch_o; //OK
output     [1:0]    aluOP_o;  //OK
output              aluSrc_o;//          TODO  TODO TODO TODO TODO TODO 
output              wbDst_o;  //OK
output              memRead_o;   //OK
output              memWrite_o;  //OK
output              memToReg_o;  //OK
output              regWrite_o;  //OK

// Calculation
assign branch_o = (opCode_i == 7'b1100011 && equal_i)? 1'b1: 1'b0; 
assign aluOP_o = (opCode_i == 7'b0110011)? 2'b10: (opCode_i == 7'b0010011)? 2'b01: 2'b00;
assign aluSrc_o = (opCode_i == 7'b0110011 )? 1'b0: 1'b1; 
assign wbDst_o = (opCode_i == 7'b0000011 ||opCode_i ==7'b0100011)? 1'b0: 1'b1; // access mem -> 0 else 1 
assign memRead_o = (opCode_i == 7'b0000011)? 1'b1: 1'b0;
assign memWrite_o = (opCode_i == 7'b0100011)? 1'b1: 1'b0;
assign memToReg_o = (opCode_i == 7'b0000011)? 1'b1: 1'b0;
assign regWrite_o = (opCode_i == 7'b0110011 || opCode_i == 7'b0010011 )? 1'b1: 1'b0;


endmodule

