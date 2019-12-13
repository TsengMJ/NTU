module Hazard_Detection_Unit
(
    ID_rsAddr_i,
    ID_rtAddr_i,
    EX_memRead_i,
    EX_wbAddr_i,
    hazardDetected_o
);

// Interface

input [4:0]     ID_rsAddr_i;
input [4:0]     ID_rtAddr_i;
input [4:0]     EX_wbAddr_i;
input           EX_memRead_i;
input           hazardDetected_o

output reg         mux_select_o;
output reg         hazardDetected_o;


// Calculation

//load use data hazard
always @(ID_rsAddr_ior ID_rtAddr_i or EX_wbAddr_i or EX_memRead_i)
begin
	hazardDetected_o = (EX_memRead_i && (ID_rsAddr_i == EX_wbAddr_i || ID_rtAddr_i == EX_wbAddr_i))? 1'b0 : 1'b1;
end
endmodule