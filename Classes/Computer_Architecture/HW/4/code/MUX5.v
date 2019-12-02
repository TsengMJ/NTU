module MUX5
(
    source1_i,
    source2_i,
    signal_i,
    output_o
);


// Interface
input  [4:0] source1_i;
input  [4:0] source2_i;
input  [0:0] signal_i;

output [4:0] output_o ;

// Calculate
assign output_o = (signal_i)? source2_i: source1_i;
endmodule