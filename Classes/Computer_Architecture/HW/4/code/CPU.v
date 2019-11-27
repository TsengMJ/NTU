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
    .instrAddr_i    (instrAddr),
    .instrSize_i    (instrSize),
    .pcNext_o       (pcNext)
);

Branch_Adder Branch_Adder(
    .immShifted_i   (immShifted),
    .instrAddr_i    (instrAddr),
    .pcBranch_o     (pcBranch),
)


// MUX 專區
PC_Dst_MUX PC_Dst_MUX(
    .pcBranch_i     (pcBranch),
    .pcNext_i       (pcNext),
    .pc_o           (pc)
);

WB_MUX WB_MUX(
    .memData_i      (memData),
    .aluResult_i    (aluResult),
    .wbData_o       (wbData)
);

ALU_Input1_MUX ALU_Input1_MUX(
    .rsData_i           (rsData),
    .aluForwarding_i    (aluForwarding),
    .memForwarding_i    (memForwarding),
    .forwardingA_i      (forwardingA),
    .aluInput1_o        (aluInput1)
);

ALU_Input2_MUX ALU_Input2_MUX(
    .rt_immMuxOutput_i  (rt_immMuxOutput),
    .aluForwarding_i    (aluForwarding),
    .memForwarding_i    (memForwarding),
    .fowardingB_i       (forwardingB),
    .aluInput2_o        (aluInput2)
);

RT_IMM_MUX RT_IMM_MUX(
    .rtData_i               (rtData),
    .immExtended_i          (immExtended),
    .alu_rtimmResource_i    (alu_rtimmResource),
    .rt_immMuxOutput_o      (rt_immMuxOutput)
);



// ALU 專區
ALU ALU(
    .aluInput1_i    (aluInput1),
    .aluInput2_i    (aluInput2),
    .aluCtrl_i      (aluCtrl),
    .aluResult_o    (aluResult)
);


// CONTROLER 專區
ALU_Control ALU_Control(
    .funct_i        (funct),
    .aluOp_i        (aluOp),
    .aluCtrl_o      (aluCtrl)
);


// PIPELINE REGISTER 專區



// OTHER 專區
Sign_Extend Sign_Extend(
    .imm_i          (imm),
    .immExtended_o  (immExtended),
);

Shift Shift(
    .immExtended_i  (immExtended),
    .immShifted_o   (immShifted)
);

endmodule

