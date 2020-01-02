// `include "PC.v"
// `include "Instruction_Memory.v"
// `include "Registers.v"
// `include "Adder.v"
// `include "MUX32.v"
// `include "MUX5.v"
// `include "MUX_MemToReg.v"
// `include "MUX_AluSrc.v"
// `include "MUX_Stall.v"
// `include "ALU.v"
// `include "Control.v"
// `include "ALU_Control.v"
// `include "Register_IF_ID.v"
// `include "Register_ID_EX.v"
// `include "Register_EX_MEM.v"
// `include "Register_MEM_WB.v"
// `include "Sign_Extend.v"
// `include "Shift.v"
// `include "Branch_Equal.v"
// `include "Forwarding_Unit.v"
// `include "Hazard_Detection_Unit.v"

// `include "dcache_top.v"
// `include "dcache_data_sram.v"
// `include "dcache_tag_sram.v"

module CPU
(
	clk_i,
	rst_i,
	start_i,
   
	mem_data_i, 
	mem_ack_i, 	
	mem_data_o, 
	mem_addr_o, 	
	mem_enable_o, 
	mem_write_o
);

//input
input clk_i;
input rst_i;
input start_i;

//
// to Data Memory interface		
//
input	[256-1:0]	mem_data_i; 
input			    mem_ack_i; 	
output	[256-1:0]	mem_data_o; 
output	[32-1:0]	mem_addr_o; 	
output			    mem_enable_o; 
output			    mem_write_o; 




// Project1 here!
// Wires 專區
// IF Section
wire    [31:0]  IF_pc;
wire    [31:0]  IF_instrAddr;
wire    [31:0]  IF_instr;
wire    [31:0]  IF_pcNext;

// ID Section
wire    [0:0]   ID_hazardDetected;
wire    [0:0]   ID_aluSrcMux;
wire    [0:0]   ID_wbDstMux;
wire    [0:0]   ID_memReadMux;
wire    [0:0]   ID_memWriteMux;
wire    [0:0]   ID_memToRegMux;
wire    [0:0]   ID_regWriteMux;
wire    [0:0]   ID_IFFlush;
wire    [0:0]   ID_aluSrc;
wire    [0:0]   ID_memRead;
wire    [0:0]   ID_memWrite;
wire    [0:0]   ID_memToReg;
wire    [0:0]   ID_regWrite;
wire    [4:0]   ID_wbAddr;
wire    [0:0]   ID_branch;
wire    [0:0]   ID_equal;
wire    [0:0]   ID_wbDst;
wire    [1:0]   ID_aluOp;
wire    [1:0]   ID_aluOpMux;
wire    [9:0]   ID_funct;
wire    [31:0]  ID_rsData;
wire    [31:0]  ID_rtData;
wire    [31:0]  ID_immShifted;
wire    [31:0]  ID_immExtended;
wire    [31:0]  ID_instrAddr;
wire    [31:0]  ID_pcBranch;
wire    [31:0]  ID_instr;


// EX Section
wire    [0:0]   EX_aluSrc;
wire    [0:0]   EX_wbDst;
wire    [1:0]   EX_aluOp;
wire    [0:0]   EX_memRead;
wire    [0:0]   EX_memWrite;
wire    [0:0]   EX_memToReg;
wire    [0:0]   EX_regWrite;
wire    [1:0]   EX_forwardingA;
wire    [1:0]   EX_forwardingB;
wire    [1:0]   EX_forwardingC;
wire    [31:0]  EX_rtForward;
wire    [3:0]   EX_aluCtrl;
wire    [4:0]   EX_rsAddr;
wire    [4:0]   EX_rtAddr;
wire    [4:0]   EX_rdAddr;
wire    [4:0]   EX_wbAddr;
wire    [9:0]   EX_funct;
wire    [31:0]  EX_rsData;
wire    [31:0]  EX_rtData;
wire    [31:0]  EX_immExtended;
wire    [31:0]  EX_rt_immMuxOutput;
wire    [31:0]  EX_aluSrc1;
wire    [31:0]  EX_aluSrc2;
wire    [31:0]  EX_memWriteData;
wire    [31:0]  EX_aluResult;


// MEM Section
wire    [0:0]   MEM_memRead;
wire    [0:0]   MEM_memWrite;
wire    [0:0]   MEM_memToReg;
wire    [0:0]   MEM_regWrite;
wire    [4:0]   MEM_wbAddr;
wire    [31:0]  MEM_aluResult;
wire    [31:0]  MEM_memData;
wire    [31:0]  MEM_rtData;
wire            MEM_stall;

// WB Section
wire    [0:0]   WB_memToReg;
wire    [0:0]   WB_regWrite;
wire    [4:0]   WB_wbAddr;
wire    [31:0]  WB_memData;
wire    [31:0]  WB_aluResult;
wire    [31:0]  WB_wbData;


// Assign wires
assign ID_funct  = {ID_instr[31:25], ID_instr[14:12]};


// ADDER 專區
Adder PC_Adder(
    .operand1_i     (IF_instrAddr),
    .operand2_i     (32'b0100),
    .result_o       (IF_pcNext)
);

Adder Branch_Adder(
    .operand1_i     (ID_immShifted),
    .operand2_i     (ID_instrAddr),
    .result_o       (ID_pcBranch)
);


// MUX 專區   
MUX32 PC_Dst_MUX(
    .source1_i      (IF_pcNext),
    .source2_i      (ID_pcBranch),
    .signal_i       (ID_branch),
    .output_o       (IF_pc)
);

MUX32 RT_IMM_MUX(
    .source1_i      (EX_rtForward),
    .source2_i      (EX_immExtended),
    .signal_i       (EX_aluSrc),
    .output_o       (EX_aluSrc2)
);

MUX5 WB_Addr_MUX(
    .source1_i       (ID_instr[24:20]),
    .source2_i       (ID_instr[11:7]),
    .signal_i        (ID_wbDst),
    .output_o        (ID_wbAddr)
);

//  反的
MUX_MemToReg MUX_MemToReg(
    .memData_i     (WB_memData),
    .aluResult_i   (WB_aluResult),
    .memToReg_i    (WB_memToReg),
    .wbData_o      (WB_wbData)
);

MUX_AluSrc MUX_AluSrc1(
    .currentData_i   (EX_rsData),
    .aluForward_i    (MEM_aluResult),
    .memForward_i    (WB_wbData),
    .forwarSignal_i  (EX_forwardingA),
    .output_o        (EX_aluSrc1)
);

MUX_AluSrc MUX_AluSrc2(
    .currentData_i   (EX_rtData),
    .aluForward_i    (MEM_aluResult),
    .memForward_i    (WB_wbData),
    .forwarSignal_i  (EX_forwardingB),
    .output_o        (EX_rtForward)
);

MUX_Stall MUX_Stall(
    .hazardDetected_i   (ID_hazardDetected),
    .aluOp_i            (ID_aluOp),
    .aluSrc_i           (ID_aluSrc),
    .memRead_i          (ID_memRead),
    .memWrite_i         (ID_memWrite),
    .memToReg_i         (ID_memToReg),
    .regWrite_i         (ID_regWrite),
    .zero_i             (1'b0),
    
    .aluOp_o            (ID_aluOpMux),
    .aluSrc_o           (ID_aluSrcMux),
    .memRead_o          (ID_memReadMux),
    .memWrite_o         (ID_memWriteMux),
    .memToReg_o         (ID_memToRegMux),
    .regWrite_o         (ID_regWriteMux)
);


// ALU 專區
ALU ALU(
    .aluSrc1_i      (EX_aluSrc1),
    .aluSrc2_i      (EX_aluSrc2),
    .aluCtrl_i      (EX_aluCtrl),
    .aluResult_o    (EX_aluResult)
);


// CONTROLER 專區
Control Control(
    .opCode_i       (ID_instr[6:0]),
    .equal_i        (ID_equal),

    .branch_o       (ID_branch),
    .flush_o        (ID_IFFlush),
    .aluOp_o        (ID_aluOp),
    .aluSrc_o       (ID_aluSrc),
    .wbDst_o        (ID_wbDst),
    .memRead_o      (ID_memRead),
    .memWrite_o     (ID_memWrite),
    .memToReg_o     (ID_memToReg),
    .regWrite_o     (ID_regWrite)
);

ALU_Control ALU_Control(
    .funct_i        (EX_funct),
    .aluOp_i        (EX_aluOp),
    .aluCtrl_o      (EX_aluCtrl)
);


// PIPELINE REGISTER 專區
Register_IF_ID Register_IF_ID(
    .clk_i              (clk_i),
    .stall_i            (MEM_stall),

    .instr_i            (IF_instr),
    .instrAddr_i        (IF_instrAddr),
    .hazardDetected_i   (ID_hazardDetected),
    .IFFlush_i          (ID_IFFlush),
    .instr_o            (ID_instr),
    .instrAddr_o        (ID_instrAddr)
);

Register_ID_EX Register_ID_EX(
    .clk_i              (clk_i),
    .stall_i            (MEM_stall),

    .aluOp_i            (ID_aluOpMux),
    .aluSrc_i           (ID_aluSrcMux),
    .memRead_i          (ID_memReadMux),
    .memWrite_i         (ID_memWriteMux),
    .memToReg_i         (ID_memToRegMux),
    .regWrite_i         (ID_regWriteMux),
    .rsData_i           (ID_rsData),
    .rtData_i           (ID_rtData),
    .immExtended_i      (ID_immExtended),
    .rsAddr_i           (ID_instr[19:15]),
    .rtAddr_i           (ID_instr[24:20]),
    .rdAddr_i           (ID_instr[11:7]),
    .wbAddr_i           (ID_wbAddr),
    .funct_i            (ID_funct),

    .aluOp_o            (EX_aluOp),
    .aluSrc_o           (EX_aluSrc),
    .memRead_o          (EX_memRead),
    .memWrite_o         (EX_memWrite),
    .memToReg_o         (EX_memToReg),
    .regWrite_o         (EX_regWrite),
    .rsData_o           (EX_rsData),
    .rtData_o           (EX_rtData),
    .immExtended_o      (EX_immExtended),
    .rsAddr_o           (EX_rsAddr),
    .rtAddr_o           (EX_rtAddr),
    .rdAddr_o           (EX_rdAddr),
    .wbAddr_o           (EX_wbAddr),    
    .funct_o            (EX_funct)
);

Register_EX_MEM Register_EX_MEM(
    .clk_i          (clk_i),
    .stall_i        (MEM_stall),

    .memRead_i      (EX_memRead),
    .memWrite_i     (EX_memWrite),
    .memToReg_i     (EX_memToReg),
    .regWrite_i     (EX_regWrite),
    .aluResult_i    (EX_aluResult),
    .rtData_i       (EX_rtForward),
    .wbAddr_i       (EX_wbAddr),

    .memRead_o      (MEM_memRead),
    .memWrite_o     (MEM_memWrite),
    .memToReg_o     (MEM_memToReg),
    .regWrite_o     (MEM_regWrite),
    .aluResult_o    (MEM_aluResult),
    .rtData_o       (MEM_rtData),
    .wbAddr_o       (MEM_wbAddr)
);

Register_MEM_WB Register_MEM_WB(
    .clk_i          (clk_i),
    .stall_i        (MEM_stall),

    .memToReg_i     (MEM_memToReg),
    .regWrite_i     (MEM_regWrite),
    .memData_i      (MEM_memData),
    .aluResult_i    (MEM_aluResult),
    .wbAddr_i       (MEM_wbAddr),

    .memToReg_o     (WB_memToReg),
    .regWrite_o     (WB_regWrite),
    .memData_o      (WB_memData),
    .aluResult_o    (WB_aluResult),
    .wbAddr_o       (WB_wbAddr)
);



// OTHER 專區
Sign_Extend Sign_Extend(
    .instr_i        (ID_instr),
    .immExtended_o  (ID_immExtended)
);

Shift Shift(
    .immExtended_i  (ID_immExtended),
    .immShifted_o   (ID_immShifted)
);

Branch_Equal Branch_Equal(
    .rsData_i       (ID_rsData),
    .rtData_i       (ID_rtData),
    .equal_o        (ID_equal)
);

Forwarding_Unit Forwarding_Unit(
    .EX_rsAddr_i    (EX_rsAddr),
    .EX_rtAddr_i    (EX_rtAddr),
    .MEM_regWrite_i (MEM_regWrite),
    .MEM_wbAddr_i   (MEM_wbAddr),
    .WB_regWrite_i  (WB_regWrite),
    .WB_wbAddr_i    (WB_wbAddr),  

    .Forward_A_o    (EX_forwardingA),
    .Forward_B_o    (EX_forwardingB)
);

Hazard_Detection_Unit Hazard_Detection_Unit(
    .ID_rsAddr_i        (ID_instr[19:15]),
    .ID_rtAddr_i        (ID_instr[24:20]),
    .EX_memRead_i       (EX_memRead),
    .EX_wbAddr_i        (EX_wbAddr),
    .opCode_i           (ID_instr[6:0]),
    .hazardDetected_o   (ID_hazardDetected)
);

// Project1 here!


PC PC
(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.start_i(start_i),
	.stall_i(MEM_stall), 
	.PCWrite_i(~ID_hazardDetected),
	.pc_i(IF_pc),
	.pc_o(IF_instrAddr)
);

Instruction_Memory Instruction_Memory(
	.addr_i(IF_instrAddr), 
	.instr_o(IF_instr)
);

Registers Registers(
    .clk_i          (clk_i),
    .RS1addr_i      (ID_instr[19:15]),
    .RS2addr_i      (ID_instr[24:20]),
    .RDaddr_i       (WB_wbAddr),
    .RDdata_i       (WB_wbData),
    .RegWrite_i     (WB_regWrite),
    .RS1data_o      (ID_rsData),
    .RS2data_o      (ID_rtData)
);

//data cache
dcache_top dcache(
    // System clock, reset and stall
	.clk_i(clk_i), 
	.rst_i(rst_i),
	
	// to Data Memory interface		
	.mem_data_i(mem_data_i), 
	.mem_ack_i(mem_ack_i), 	
	.mem_data_o(mem_data_o), 
	.mem_addr_o(mem_addr_o), 	
	.mem_enable_o(mem_enable_o), 
	.mem_write_o(mem_write_o), 
	
	// to CPU interface	
	.p1_data_i(MEM_rtData), 
	.p1_addr_i(MEM_aluResult), 	
	.p1_MemRead_i(MEM_memRead), 
	.p1_MemWrite_i(MEM_memWrite), 
	.p1_data_o(MEM_memData), 
	.p1_stall_o(MEM_stall)
);

endmodule
