module MUX5(data1_i, data2_i, select_i, data_o);

// Interface
input       [4:0] data1_i;
input       [4:0] data2_i;
input       [0:0] select_i;
output      [4:0] data_o;

// Calculation
assign data_o = (select_i == 1'b0)? data1_i: data2_i;
 
endmodule
