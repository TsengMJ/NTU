`include "PC.v"
`include "Instruction_Memory.v"
`include "Registers.v"
`include "Data_Memory.v"
`include "PC_Adder.v"
`include "Branch_Adder.v"
`include "PC_Dst_MUX.v"
`include "WB_Addr_MUX.v"
`include "WB_MUX.v"
`include "ALU_Input1_MUX.v"
`include "ALU_Input2_MUX.v"
`include "RT_IMM_MUX.v"
`include "Stall_MUX.v"
`include "ALU.v"
`include "Control.v"
`include "ALU_Control.v"
`include "IF_ID_Register.v"
`include "ID_EX_Register.v"
`include "EX_MEM_Register.v"
`include "MEM_WB_Register.v"
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


// Original
PC PC(
    .clk_i          (clk_i),
    .start_i        (start_i),
    .PCWrite_i      (ID_hazardDetected),
    .pc_i           (IF_pc),
    .pc_o           (IF_instrAddr)
);

Instruction_Memory Instruction_Memory(
    .addr_i         (),
    .instr_o        ()
);

Registers Registers(
    .clk_i          (clk_i),
    .RS1addr_i      (),
    .RS2addr_i      (),
    .RDaddr_i       (),
    .RDdata_i       (),
    .RegWrite_i     (),
    .RS1data_o      (),
    .RS2data_o      ()
);

Data_Memory Data_Memory(
    .clk_i          (clk_i),

    .addr_i         (),
    .MemWrite_i     (),
    .data_i         (),
    .data_o         ()
);


// Start HERE!!

// ADDER 專區
PC_Adder PC_Adder(
    .instrAddr_i    (IF_instrAddr),
    .instrSize_i    (IF_instrSize),
    .pcNext_o       (IF_pcNext)
);

Branch_Adder Branch_Adder(
    .immShifted_i   (ID_immShifted),
    .instrAddr_i    (ID_instrAddr),
    .pcBranch_o     (ID_pcBranch),
)


// MUX 專區
PC_Dst_MUX PC_Dst_MUX(
    .pcBranch_i     (ID_pcBranch),
    .pcNext_i       (IF_pcNext),
    .branchSignal_i (ID_branch)
    .pc_o           (IF_pc)
);

WB_Addr_MUX WB_Addr_MUX(
    .rtAddr_i       (EX_rtAddr),
    .rdAddr_i       (EX_rdAddr),
    .wbDst_i        (EX_wbDst),
    .wbAddr_o       (EX_wbAddr)
);

WB_MUX WB_MUX(
    .memData_i     (WB_memData),
    .aluResult_i   (WB_aluResult),
    .memToReg_i    (WB_memToReg),
    .wbData_o      (WB_wbData)
);

ALU_Input1_MUX ALU_Input1_MUX(
    .rsData_i           (EX_rsData),
    .aluForwarding_i    (EX_aluForwarding),
    .memForwarding_i    (EX_memForwarding),
    .forwardingA_i      (EX_forwardingA),
    .aluSrc1_o          (EX_aluSrc1)
);

ALU_Input2_MUX ALU_Input2_MUX(
    .rt_immMuxOutput_i  (EX_rt_immMuxOutput),
    .aluForwarding_i    (EX_aluForwarding),
    .memForwarding_i    (EX_memForwarding),
    .forwardingB_i       (EX_forwardingB),
    .aluSrc2_o          (EX_aluSrc2)
);

RT_IMM_MUX RT_IMM_MUX(
    .rtData_i               (EX_rtData),
    .immExtended_i          (EX_immExtended),
    .aluSrc_i               (EX_aluSrc),
    .rt_immMuxOutput_o      (EX_rt_immMuxOutput)
);

Stall_MUX Stall_MUX(
    // EX use
    .aluOp_i            (ID_aluOp),
    .aluSrc_i           (ID_aluSrc),
    .wbDst_i            (ID_wbDst),
    // MEM use
    .memRead_i          (ID_memRead),
    .memWrite_i         (ID_memWrite),
    // WB use
    .memToReg_i         (ID_memToReg),
    .regWrite_i         (ID_regWrite),
    .hazardDetected     (ID_hazardDetected),
    .zero_i             (zero),
    
    // EX use
    .aluOp_o            (ID_aluOpMux),
    .aluSrc_o           (ID_aluSrcMux),
    .wbDst_o            (ID_wbDstMux),
    // MEM use
    .memRead_o          (ID_memReadMux),
    .memWrite_o         (ID_memWriteMux),
    // WB use
    .memToReg_o         (ID_memToRegMux),
    .regWrite_o         (ID_regWriteMux),
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
    .funct_i        (funct),
    .aluOp_i        (aluOp),
    .aluCtrl_o      (aluCtrl)
);


// PIPELINE REGISTER 專區
IF_ID_Register IF_ID_Register(
    .instr_i            (IF_instr),
    .instrAddr_i        (IF_instrAddr),
    .hazardDetected_i   (hazardDetected),
    .IFFlush_i          (IFFlush),
    .instr_o            (ID_instr),
    .instrAddr_o        (ID_instrAddr)
);

ID_EX_Register ID_EX_Register(
    .aluOp_i            (ID_aluOpMux),
    .aluSrc_i           (ID_aluSrcMux),
    .wbDst_i            (ID_wbDstMux),    // Use to control WB_Addr_MUX
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

    .aluOp_o            (EX_aluOp),
    .aluSrc_o           (EX_aluSrc),
    .wbDst_o            (EX_wbDst),
    .memRead_o          (EX_memRead),
    .memWrite_o         (EX_memWrite),
    .memToReg_o         (EX_memToReg),
    .regWrite_o         (EX_regWrite),
    .rsData_o           (EX_rsData),
    .rtData_o           (EX_rtData),
    .immExtended_o      (EX_immExtended),
    .rsAddr_o           (EX_rsAddr),
    .rtAddr_o           (EX_rtAddr),
    .rdAddr_o           (EX_rdAddr)
);

EX_MEM_Register EX_MEM_Register(
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

MEM_WB_Register MEM_WB_Register(
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
    .immExtended_o  (ID_immExtended),
);

Shift Shift(
    .immExtended_i  (ID_immExtended),
    .immShifted_o   (ID_immShifted)
);

Branch_Equal Branch_Equal(
    .rsData_i    (ID_rsData),
    .rtData_i    (ID_rtData),
    .equal_o        (ID_equal)
);

Forwarding_Unit Forwarding_Unit(
    .EX_rsAddr_i        (EX_rsAddr),
    .EX_rtAddr_i        (EX_rtAddr),
    .MEM_regWrite_i     (MEM_regWrite),
    .MEM_wbAddr_i       (MEM_wbAddr),
    .WB_regWrite_i      (WB_regWrite),
    .WB_wbAddr_i        (WB_wbAddr),  

    .forwardingA_o      (EX_forwardingA),
    .forwardingB_o      (EX_forwardingB)
);

Hazard_Detection_Unit Hazard_Detection_Unit(
    .ID_rsAddr_i        (ID_rsAddr),
    .ID_rtAddr_I        (ID_rtAddr),
    .EX_memRead_i       (EX_memRead),
    .EX_wbAddr_i        (EX_wbAddr),
    .hazardDetected_i   (ID_hazardDetected)
);

endmodule