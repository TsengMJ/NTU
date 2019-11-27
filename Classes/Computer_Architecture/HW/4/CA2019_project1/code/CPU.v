module CPU
(
    clk_i, 
    start_i
);

// Ports
input         clk_i;
input         start_i;

PC PC(
    .clk_i          (),
    .start_i        (),
    .PCWrite_i      (),
    .pc_i           (),
    .pc_o           ()
);

Instruction_Memory Instruction_Memory(
    .addr_i         (),
    .instr_o        ()
);

Registers Registers(
    .clk_i          (),
    .RS1addr_i      (),
    .RS2addr_i      (),
    .RDaddr_i       (),
    .RDdata_i       (),
    .RegWrite_i     (),
    .RS1data_o      (),
    .RS2data_o      ()
);

Data_Memory Data_Memory(
    .clk_i          (),

    .addr_i         (),
    .MemWrite_i     (),
    .data_i         (),
    .data_o         ()
);

endmodule

