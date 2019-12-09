module Forwarding_Unit
(
	EX_MEM_RegWrite_i,
	MEM_WB_RegWrite_i,
	EX_MEM_RegisterRd_i,
	MEM_WB_RegisterRd_i,
	ID_EX_RegisterRs1_i,
	ID_EX_RegisterRs2_i,
	Forward_A_o,
	Forward_B_o,
);

input          EX_MEM_RegWrite_i;
input  		   MEM_WB_RegWrite_i;

input  [4 : 0] EX_MEM_RegisterRd_i;
input  [4 : 0] MEM_WB_RegisterRd_i;
input  [4 : 0] ID_EX_RegisterRs1_i;
input  [4 : 0] ID_EX_RegisterRs2_i;
output reg [1 : 0] Forward_A_o;
output reg [1 : 0] Forward_B_o;



always @(EX_MEM_RegWrite_i || MEM_WB_RegWrite_i || EX_MEM_RegisterRd_i || MEM_WB_RegisterRd_i || ID_EX_RegisterRs1_i || ID_EX_RegisterRs2_i) 
begin
	if (EX_MEM_RegWrite_i && EX_MEM_RegisterRd_i && (EX_MEM_RegisterRd_i == ID_EX_RegisterRs1_i)) begin
		Forward_A_o = 2'b10;
	end else if (MEM_WB_RegWrite_i && (MEM_WB_RegisterRd_i!=0) && (MEM_WB_RegisterRd_i == ID_EX_RegisterRs1_i)) begin
		Forward_A_o = 2'b01;
	end else begin
		Forward_A_o = 2'b00;
	end

	if (EX_MEM_RegWrite_i && EX_MEM_RegisterRd_i && (EX_MEM_RegisterRd_i == ID_EX_RegisterRs2_i)) begin
		Forward_B_o = 2'b10;
	end else if (MEM_WB_RegWrite_i && (MEM_WB_RegisterRd_i!=0) && (MEM_WB_RegisterRd_i == ID_EX_RegisterRs2_i)) begin
		Forward_B_o = 2'b01;
	end else begin
		Forward_B_o = 2'b00;
	end

	// if (EX_MEM_RegWrite_i && (EX_MEM_RegisterRd_i!=0) && (EX_MEM_RegisterRd_i == ID_EX_RegisterRs1_i)) 
	// 	begin
	// 		Forward_A_o = 2'b10;
	// 	end

	// else if (EX_MEM_RegWrite_i && (EX_MEM_RegisterRd_i != 0) && ( EX_MEM_RegisterRd_i == ID_EX_RegisterRs2_i )) 
	// 	begin
	// 		Forward_B_o = 2'b10;
	// 	end

	// if(MEM_WB_RegWrite_i && (MEM_WB_RegisterRd_i !=0) &&  !(EX_MEM_RegWrite_i && (EX_MEM_RegisterRd_i != 0) && (MEM_WB_RegisterRd_i == ID_EX_RegisterRs1_i) &&  (MEM_WB_RegisterRd_i == ID_EX_RegisterRs1_i)))
	// 	begin
	// 		Forward_B_o = 2'b01;
	// 	end

	// if(MEM_WB_RegWrite_i && (MEM_WB_RegisterRd_i != 0 ) && !(EX_MEM_RegWrite_i && (EX_MEM_RegisterRd_i !=0) && (EX_MEM_RegisterRd_i == ID_EX_RegisterRs2_i)) &&  (MEM_WB_RegisterRd_i == ID_EX_RegisterRs2_i))
	// 	begin
	// 		Forward_B_o = 2'b01;
	// 	end
end

endmodule