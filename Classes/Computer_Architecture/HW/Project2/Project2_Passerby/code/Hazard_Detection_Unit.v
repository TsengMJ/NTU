module Hazard_Detection_Unit
(
    ID_rsAddr_i,
    ID_rtAddr_i,
    EX_memRead_i,
    EX_wbAddr_i,
    opCode_i,
    hazardDetected_o
);

// Interface

input       [4:0]   ID_rsAddr_i;
input       [4:0]   ID_rtAddr_i;
input       [4:0]   EX_wbAddr_i;
input       [6:0]   opCode_i;
input               EX_memRead_i;


//output reg         mux_select_o;
output reg  [0:0]   hazardDetected_o = 0;

// Calculation

//load use data hazard
always @(*) begin
    if (opCode_i == 7'b0000011)begin
        hazardDetected_o <= (EX_memRead_i && (EX_wbAddr_i != 0) &&(ID_rsAddr_i == EX_wbAddr_i))? 1'b1 : 1'b0;
    end
	else begin
        hazardDetected_o <= (EX_memRead_i && (EX_wbAddr_i != 0) &&(ID_rsAddr_i == EX_wbAddr_i || ID_rtAddr_i == EX_wbAddr_i))? 1'b1 : 1'b0;
    end
end

endmodule