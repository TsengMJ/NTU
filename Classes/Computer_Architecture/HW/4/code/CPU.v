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
    .PCWrite_i      (hazardDetected),
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
    .aluInput1_o        (EX_aluInput1)
);

ALU_Input2_MUX ALU_Input2_MUX(
    .rt_immMuxOutput_i  (EX_rt_immMuxOutput),
    .aluForwarding_i    (EX_aluForwarding),
    .memForwarding_i    (EX_memForwarding),
    .fowardingB_i       (EX_forwardingB),
    .aluInput2_o        (EX_aluInput2)
);

RT_IMM_MUX RT_IMM_MUX(
    .rtData_i               (EX_rtData),
    .immExtended_i          (EX_immExtended),
    .aluRst_i               (EX_alu_Rst),
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
);



// ALU 專區
ALU ALU(
    .aluInput1_i    (EX_aluInput1),
    .aluInput2_i    (EX_aluInput2),
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
    .wbDst_i            (ID_wbDstMux),
    .memRead_i          (ID_memReadMux),
    .memWrite_i         (ID_memWriteMux),
    .memToReg_i         (ID_memToRegMux),
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
    .rsData_o           (EX_rsData),
    .rtData_o           (EX_rtData),
    .immExtended_o      (EX_immExtended),
    .rsAddr_o           (EX_reAddr),
    .rtAddr_o           (EX_rtAddr),
    .rdAddr_o           (EX_rdAddr)
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

endmodule

