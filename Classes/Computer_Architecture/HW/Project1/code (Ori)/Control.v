module Control
(
    opCode_i,
    equal_i,

    branch_o,
    flush_o,
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

output  reg         branch_o = 0; 
output  reg [1:0]   aluOp_o = 0;
output  reg         aluSrc_o = 0;
output  reg         wbDst_o = 0;
output  reg         memRead_o = 0;
output  reg         memWrite_o = 0;
output  reg         memToReg_o = 0;
output  reg         regWrite_o = 0;
output  reg         flush_o = 0;

// Calculation

always @(*) begin
    branch_o = (opCode_i == 7'b1100011 && equal_i)? 1'b1: 1'b0;
    flush_o  = (opCode_i == 7'b1100011 && equal_i)? 1'b1: 1'b0;
    aluOp_o = (opCode_i == 7'b0110011)? 2'b10: (opCode_i == 7'b0010011)? 2'b01: 2'b00;
    aluSrc_o = (opCode_i == 7'b0110011 )? 1'b0: 1'b1; 
    wbDst_o = (opCode_i == 7'b0100011)? 1'b0: 1'b1; // access mem -> 0 else 1 
    memRead_o = (opCode_i == 7'b0000011)? 1'b1: 1'b0;
    memWrite_o = (opCode_i == 7'b0100011)? 1'b1: 1'b0;
    memToReg_o = (opCode_i == 7'b0000011)? 1'b1: 1'b0;
    regWrite_o = (opCode_i == 7'b0100011 || opCode_i == 7'b1100011 )? 1'b0: 1'b1;
end

endmodule

