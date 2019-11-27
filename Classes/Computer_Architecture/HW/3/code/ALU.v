module ALU(data1_i, data2_i, ALUCtrl_i, data_o, Zero_o);

// Interface
input       [31:0] data1_i;
input       [31:0] data2_i;
input       [2:0]  ALUCtrl_i;
output reg  [31:0] data_o;
output      [0:0]  Zero_o;


always @ (*)
begin
    case (ALUCtrl_i)
        3'b000: data_o = data1_i & data2_i;
        3'b001: data_o = data1_i | data2_i;
        3'b010: data_o = data1_i + data2_i;
        3'b110: data_o = data1_i - data2_i;
        3'b011: data_o = data1_i * data2_i;
    endcase 
end

assign Zero_o = (data_o == 32'b0)? 1'b1: 1'b0;

endmodule
