module Forwarding_Unit
(
	EX_rsAddr_i,
	EX_rtAddr_i,
	MEM_wbAddr_i,
	MEM_regWrite_i,	
	WB_wbAddr_i,
	WB_regWrite_i,

	Forward_A_o,
	Forward_B_o,
);

input          		MEM_regWrite_i;
input  		   		WB_regWrite_i;

input  		[4 : 0] MEM_wbAddr_i;
input  		[4 : 0] WB_wbAddr_i;
input  		[4 : 0] EX_rsAddr_i;
input  		[4 : 0] EX_rtAddr_i;
output reg 	[1 : 0] Forward_A_o = 0;
output reg 	[1 : 0] Forward_B_o = 0;


always @(*) 
begin

	if (MEM_regWrite_i && (MEM_wbAddr_i != 5'b0) && (MEM_wbAddr_i == EX_rsAddr_i)) begin
		Forward_A_o = 2'b10;
	end else if (WB_regWrite_i && (WB_wbAddr_i!= 5'b0) && (WB_wbAddr_i == EX_rsAddr_i)) begin
		Forward_A_o = 2'b01;
	end else begin
		Forward_A_o = 2'b00;
	end

	if (MEM_regWrite_i && (MEM_wbAddr_i != 5'b0) && (MEM_wbAddr_i == EX_rtAddr_i)) begin
		Forward_B_o = 2'b10;
	end else if (WB_regWrite_i && (WB_wbAddr_i != 5'b0) && (WB_wbAddr_i == EX_rtAddr_i)) begin
		Forward_B_o = 2'b01;
	end else begin
		Forward_B_o = 2'b00;
	end

end

endmodule