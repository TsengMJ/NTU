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
    .PCWrite_i      (),
    .pc_i           (),
    .pc_o           ()
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
    .pcBranch_o     (IF_pcBranch),
)


// MUX 專區
PC_Dst_MUX PC_Dst_MUX(
    .pcBranch_i     (IF_pcBranch),
    .pcNext_i       (IF_pcNext),
    .pc_o           (IF_pc)
);

WB_MUX WB_MUX(
    .memData_i      (WB_memData),
    .aluResult_i    (WB_aluResult),
    .wbData_o       (WB_wbData)
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



// ALU 專區
ALU ALU(
    .aluInput1_i    (EX_aluInput1),
    .aluInput2_i    (EX_aluInput2),
    .aluCtrl_i      (EX_aluCtrl),
    .aluResult_o    (EX_aluResult)
);


// CONTROLER 專區
ALU_Control ALU_Control(
    .funct_i        (funct),
    .aluOp_i        (aluOp),
    .aluCtrl_o      (aluCtrl)
);


// PIPELINE REGISTER 專區
IF_ID_Register IF_ID_Register(
    .instr_i        (IF_instr),
    .instrAddr_i    (IF_instrAddr),
    .IFIDWrite_i    (IFIDWrite),
    .IFFlush_i      (IFFlush),
    .instr_o        (ID_instr),
    .instrAddr_o    (ID_instrAddr)
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

