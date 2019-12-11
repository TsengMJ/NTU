
  module Forward
(
	EX_MEM_RegWrite_i,
	EX_MEM_RegisterRd_i,
	MEM_WB_RegWrite_i,
	MEM_WB_RegisterRd_i,
	ID_EX_RegisterRs1_i,
	ID_EX_RegisterRs2_i,

	Forward_A_o,
	Forward_B_o,
);
input  [4 : 0] ID_EX_RegisterRs1_i;
input  [4 : 0] ID_EX_RegisterRs2_i;
input  [4 : 0] EX_MEM_RegisterRd_i;
input  [4 : 0] MEM_WB_RDaddr_i;
input          EX_MEM_RegWrite_i;
input          MEM_WB_RegisterRd_i;
output reg [1 : 0] Forward_A_o;
output reg [1 : 0] Forward_B_o;



always @(EX_MEM_RegWrite_i or MEM_WB_RegWrite_i or EX_MEM_RegisterRd_i or MEM_WB_RegisterRd_i or ID_EX_RegisterRs1_i or ID_EX_RegisterRs2_i) 
begin
	if (EX_MEM_RegWrite_i and(EX_MEM_RegisterRd_i!=0)and(EX_MEM_RegisterRd_i == ID_EX_RegisterRs1_i)) 
		begin
			Forward_A_o = 2'b10;
		end

	else if (EX_MEM_RegWrite_i and(EX_MEM_RegisterRd_i != 0) and( EX_MEM_RegisterRd_i == ID_EX_RegisterRs2_i )) 
		begin
			Forward_B_o = 2'b10
		end

	if(MEM_WB_RegWrite_i and(MEM_WB_RegisterRd_i !=0) and ~(EX_MEM_RegWrite_i and(EX_MEM_RegisterRd_i != 0) and (MEM_WB_RegisterRd_i == ID_EX_RegisterRs1_i) and (MEM_WB_RegisterRd_i == ID_EX_RegisterRs1_i))
		begin
			Forward_B_o = 2'b01
		end

	if(MEM_WB_RegWrite_i and(MEM_WB_RegisterRd_i != 0 ) and !(EX_MEM_RegWrite_i and(EX_MEM_RegisterRd_i !=0)and (EX_MEM_RegisterRd_i == ID_EX_RegisterRs2_i)) and (MEM_WB_RegisterRd_i == ID_EX_RegisterRs2_i))
		begin
			Forward_B_o = 2'b01
		end




end