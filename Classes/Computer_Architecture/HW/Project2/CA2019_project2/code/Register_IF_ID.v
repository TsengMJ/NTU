module Register_IF_ID
(
    clk_i,
    stall_i,
    
    instr_i,
    instrAddr_i,
    hazardDetected_i,
    IFFlush_i,
    instr_o,
    instrAddr_o
);

// Interface
input               clk_i;
input               stall_i;

input               IFFlush_i;
input       [31:0]  instr_i;
input       [31:0]  instrAddr_i;
input               hazardDetected_i;

output reg  [31:0]  instr_o = 0;
output reg  [31:0]  instrAddr_o = 0;

// Calculate
always @ (posedge clk_i) begin
 
  if (!clk_i) begin
    instr_o <= instr_reg;
    instrAddr_o <= instrAddr_reg;
  end
  

  if (IFFlush_i) begin
    instr_o <= 32'b0;
    instrAddr_o <= 32'b0;
  end

  else if (~hazardDetected_i) begin
      instr_o <= instr_i;
      instrAddr_o <= instrAddr_i;
    end
end

endmodule
