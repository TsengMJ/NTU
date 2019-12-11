module Sign_Extend
(
    instr_i,
    immExtended_o
);
// Interface
input [31 : 0] instr_i;
output reg [31 : 0] immExtended_o = 0;

reg [11:0] tmp = 11'b0;

// Calculate
always @(instr_i) begin
    //addi lw
    if (instr_i[6 : 0] == 7'b0010011 || instr_i[6 : 0] == 7'b0000011) begin
        tmp[11 : 0] = instr_i[31 : 20];
    end

    //sw
    else if (instr_i[6 : 0] == 7'b0100011) begin
        tmp[4 : 0] = instr_i[11 : 7];
        tmp[11 : 5] = instr_i[31 : 25];
    end

    //beq
    else if (instr_i[6 : 0] == 7'b1100011) begin
        tmp[3 : 0] = instr_i[11 : 8];
        tmp[9 : 4] = instr_i[30 : 25];
        tmp[10] = instr_i[7];
        tmp[11] = instr_i[31];
    end

    // immExtended_o = tmp[11]? {{20'b1},tmp[11:0]}: {{20'b0},tmp[11:0]};
    immExtended_o = { {20{tmp[11]}}, tmp[11:0]};

end

endmodule