module Register_IF_ID
(
    clk_i,

    instr_i,
    instrAddr_i,
    hazardDetected_i,
    IFFlush_i,
    instr_o,
    instrAddr_o
);

// Interface
    input           clk_i;

    input       [31:0]  instr_i;
    input       [31:0]  instrAddr_i;
    input       [0:0]   hazardDetected_i;

    output reg  [31:0]  instr_o;
    output reg  [31:0]  instrAddr_o;

// Calculate
  always @ (posedge clk_i) begin
    instr_o = instr_i;
    instrAddr_o = instrAddr_i;
  end



endmodule
