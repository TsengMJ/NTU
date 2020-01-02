module MUX5
(
    source1_i,
    source2_i,
    signal_i,
    output_o
);


// Interface
input       [4:0]   source1_i;
input       [4:0]   source2_i;
input               signal_i;

output  reg [4:0]   output_o = 0;

// Calculate
always @(*) begin
    output_o = (signal_i)? source2_i: source1_i;
end

endmodule