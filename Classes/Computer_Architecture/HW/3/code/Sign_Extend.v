module Sign_Extend(data_i, data_o);

// Interface
input       [11:0] data_i;
output      [31:0] data_o;

// Calculation

assign data_o[31:0] = { {20{data_i[11]}}, data_i[11:0] };

endmodule
