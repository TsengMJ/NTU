`include "PC.v"
`include "Instruction_Memory.v"
`include "Registers.v"
`include "Data_Memory.v"
`include "Adder.v"
`include "MUX32.v"
`include "MUX5.v"
`include "MUX_MemToReg.v"
`include "MUX_AluSrc.v"
`include "MUX_Stall.v"
`include "ALU.v"
`include "Control.v"
`include "ALU_Control.v"
`include "Register_IF_ID.v"
`include "Register_ID_EX.v"
`include "Register_EX_MEM.v"
`include "Register_MEM_WB.v"
`include "Sign_Extend.v"
`include "Shift.v"
`include "Branch_Equal.v"
`include "Forwarding_Unit.v"
`include "Hazard_Detection_Unit.v"

module CPU
(
    clk_i, 
    start_i
);

// Ports
input         clk_i;
input         start_i;

// Wires 專區
// IF Section
wire    [31:0]  IF_pc;
wire    [31:0]  IF_instrAddr;
wire    [31:0]  IF_instrSize;
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
wire    [4  :0]   ID_wbAddr;
wire    [0:0]   ID_zero;
wire    [0:0]   ID_branch;
wire    [0:0]   ID_equal;
wire    [0:0]   ID_wbDst;
wire    [1:0]   ID_aluOp;
wire    [1:0]   ID_aluOpMux;
wire    [4:0]   ID_rsAddr;
wire    [4:0]   ID_rtAddr;
wire    [4:0]   ID_rdAddr;
wire    [6:0]   ID_opCode;
wire    [9:0]   ID_funct;
wire    [11:0]  ID_imm;
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
wire    [31:0]  EX_aluForwarding;
wire    [31:0]  EX_memForwarding;
wire    [31:0]  EX_aluSrc1;
wire    [31:0]  EX_aluSrc2;
wire    [31:0]  EX_aluResult;


// MEM Section
wire    [0:0]   MEM_memRead;
wire    [0:0]   MEM_memWrite;
wire    [0:0]   MEM_memToReg;
wire    [0:0]   MEM_regWrite;
wire    [4:0]   MEM_wbAddr;
wire    [31:0]  MEM_aluResult;
wire    [31:0]  MEM_aluSrc2;
wire    [31:0]  MEM_memData;


// WB Section
wire    [0:0]   WB_memToReg;
wire    [0:0]   WB_regWrite;
wire    [4:0]   WB_wbAddr;
wire    [31:0]  WB_memData;
wire    [31:0]  WB_aluResult;
wire    [31:0]  WB_wbData;


// Assign wires
assign IF_instrSize = 32'b0100;
assign ID_zero = 1'b0;
assign ID_opCode = ID_instr[6:0];
assign ID_rsAddr = ID_instr[19:15];
assign ID_rtAddr = ID_instr[24:20];
assign ID_rdAddr = ID_instr[11:7];
assign ID_imm    = ID_instr[31:20];
assign ID_funct  = {ID_instr[31:25], ID_instr[14:12]};




// Original
PC PC(
    .clk_i          (clk_i), 
    .rst_i          (rst_i),
    .start_i        (start_i),
    .PCWrite_i      (1'b1),
    .pc_i           (IF_pc),
    .pc_o           (IF_instrAddr)
);

Instruction_Memory Instruction_Memory(
    .addr_i         (IF_instrAddr),
    .instr_o        (IF_instr)
);

Registers Registers(
    .clk_i          (clk_i),
    .RS1addr_i      (ID_rsAddr),
    .RS2addr_i      (ID_rtAddr),
    .RDaddr_i       (ID_rdAddr),
    .RDdata_i       (WB_wbData),
    .RegWrite_i     (WB_regWrite),
    .RS1data_o      (ID_rsData),
    .RS2data_o      (ID_rtData)
);

Data_Memory Data_Memory(
    .clk_i          (clk_i),

    .addr_i         (MEM_aluResult),
    .MemWrite_i     (MEM_memWrite),
    .data_i         (MEM_aluSrc2),
    .data_o         (MEM_memData)
);


// Start HERE!!

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


// MUX 專區    放反了........source and sorce2
MUX32 PC_Dst_MUX(
    .source1_i      (IF_pcNext),
    .source2_i      (ID_pcBranch),
    .signal_i       (ID_branch),
    .output_o       (IF_pc)
);

MUX32 RT_IMM_MUX(
    .source1_i      (EX_rtData),
    .source2_i      (EX_immExtended),
    .signal_i       (EX_aluSrc),
    .output_o       (EX_rt_immMuxOutput)
);


MUX5 WB_Addr_MUX(
    .source1_i       (ID_rtAddr),
    .source2_i       (ID_rdAddr),
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
    .aluForward_i    (EX_aluForwarding),
    .memForward_i    (EX_memForwarding),
    .forwarSignal_i  (EX_forwardingA),
    .output_o        (EX_aluSrc1)
);

MUX_AluSrc MUX_AluSrc2(
    .currentData_i   (EX_rt_immMuxOutput),
    .aluForward_i    (EX_aluForwarding),
    .memForward_i    (EX_memForwarding),
    .forwarSignal_i  (EX_forwardingB),
    .output_o        (EX_aluSrc2)
);

MUX_Stall MUX_Stall(
    .hazardDetected_i   (ID_hazardDetected),
    .aluOp_i            (ID_aluOp),
    .aluSrc_i           (ID_aluSrc),
    // .wbDst_i            (ID_wbDst),
    .memRead_i          (ID_memRead),
    .memWrite_i         (ID_memWrite),
    .memToReg_i         (ID_memToReg),
    .regWrite_i         (ID_regWrite),
    .zero_i             (ID_zero),
    
    .aluOp_o            (ID_aluOpMux),
    .aluSrc_o           (ID_aluSrcMux),
    // .wbDst_o            (ID_wbDstMux),
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
    .opCode_i       (ID_opCode),
    .equal_i        (ID_equal),

    // ID use
    .branch_o       (ID_branch),
    .flush_o        (ID_IFFlush),
    // EX use
    .aluOp_o        (ID_aluOp),
    .aluSrc_o       (ID_aluSrc),
    .wbDst_o        (ID_wbDst),

    // MEM use
    .memRead_o      (ID_memRead),
    .memWrite_o     (ID_memWrite),

    // WB use
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

    .instr_i            (IF_instr),
    .instrAddr_i        (IF_instrAddr),
    .hazardDetected_i   (ID_hazardDetected),
    .IFFlush_i          (ID_IFFlush),
    .instr_o            (ID_instr),
    .instrAddr_o        (ID_instrAddr)
);

Register_ID_EX Register_ID_EX(
    .clk_i              (clk_i),

    .aluOp_i            (ID_aluOpMux),
    .aluSrc_i           (ID_aluSrcMux),
    // .wbDst_i            (ID_wbDstMux),    // Use to control WB_Addr_MUX
    .memRead_i          (ID_memReadMux),
    .memWrite_i         (ID_memWriteMux),
    .memToReg_i         (ID_memToRegMux),
    .regWrite_i         (ID_regWriteMux),
    .rsData_i           (ID_rsData),
    .rtData_i           (ID_rtData),
    .immExtended_i      (ID_immExtended),
    .rsAddr_i           (ID_rsAddr),
    .rtAddr_i           (ID_rtAddr),
    .rdAddr_i           (ID_rdAddr),
    .wbAddr_i           (ID_wbAddr),
    .funct_i            (ID_funct),

    .aluOp_o            (EX_aluOp),
    .aluSrc_o           (EX_aluSrc),
    // .wbDst_o            (EX_wbDst),
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
    .clk_i              (clk_i),

    .memRead_i          (EX_memRead),
    .memWrite_i         (EX_memWrite),
    .memToReg_i         (EX_memToReg),
    .regWrite_i         (EX_regWrite),
    .aluResult_i        (EX_aluResult),
    .aluSrc2_i          (EX_aluSrc2),
    .wbAddr_i           (EX_wbAddr),

    .memRead_o          (MEM_memRead),
    .memWrite_o         (MEM_memWrite),
    .memToReg_o         (MEM_memToReg),
    .regWrite_o         (MEM_regWrite),
    .aluResult_o        (MEM_aluResult),
    .aluSrc2_o          (MEM_aluSrc2),
    .wbAddr_o           (MEM_wbAddr)
);

Register_MEM_WB Register_MEM_WB(
    .clk_i              (clk_i),

    .memToReg_i         (MEM_memToReg),
    .regWrite_i         (MEM_regWrite),
    .memData_i          (MEM_memData),
    .aluResult_i        (MEM_aluResult),
    .wbAddr_i           (MEM_wbAddr),

    .memToReg_o         (WB_memToReg),
    .regWrite_o         (WB_regWrite),
    .memData_o          (WB_memData),
    .aluResult_o        (WB_aluResult),
    .wbAddr_o           (WB_wbAddr)
);



// OTHER 專區
Sign_Extend Sign_Extend(
    .imm_i          (ID_imm),
    .immExtended_o  (ID_immExtended)
);

Shift Shift(
    .immExtended_i  (ID_immExtended),
    .immShifted_o   (ID_immShifted)
);

Branch_Equal Branch_Equal(
    .rsData_i    (ID_rsData),
    .rtData_i    (ID_rtData),
    .equal_o     (ID_equal)
);

Forwarding_Unit Forwarding_Unit(
    .ID_EX_RegisterRs2_i        (EX_rtAddr),
    .ID_EX_RegisterRs1_i        (EX_rsAddr),
    .EX_MEM_RegWrite_i          (MEM_regWrite),
    .EX_MEM_RegisterRd_i        (MEM_wbAddr),
    .MEM_WB_RegWrite_i          (WB_regWrite),
    .MEM_WB_RegisterRd_i        (WB_wbAddr),  

    .Forward_A_o                (EX_forwardingA),
    .Forward_B_o                (EX_forwardingB)
);

Hazard_Detection_Unit Hazard_Detection_Unit(
    .ID_rsAddr_i        (ID_rsAddr),
    .ID_rtAddr_i        (ID_rtAddr),
    .EX_memRead_i       (EX_memRead),
    .EX_wbAddr_i        (EX_wbAddr),
    .hazardDetected_o   (ID_hazardDetected)
);

endmodule