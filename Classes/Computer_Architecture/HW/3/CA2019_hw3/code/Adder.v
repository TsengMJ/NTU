module Adder(pc, pc_dst);

// Interface
parameter instr_len = 32'b100;

input       [31:0] pc;
output      [31:0] pc_dst;

// Calculation
always @(pc, pc_dst) begin
    assign pc_dst = pc +  instr_len;

end

endmodule
