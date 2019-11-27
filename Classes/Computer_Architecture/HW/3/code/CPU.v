`include "Adder.v"
`include "MUX5.v"
`include "MUX32.v"
`include "Sign_Extend.v"
`include "Control.v"
`include "ALU_Control.v"
`include "ALU.v"
`include "PC.v"
`include "Registers.v"
`include "Instruction_Memory.v"

module CPU
(
    clk_i, 
    rst_i,
    start_i
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;

// Define wires
wire    [31:0] pc;
wire    [31:0] four;
wire    [31:0] instrAddr;
wire    [31:0] instr;
wire    [ 6:0] opCode;
wire    [ 4:0] rsAddr;
wire    [ 4:0] rtAddr;
wire    [ 4:0] rdAddr;
wire    [ 4:0] readAddr;
wire    [31:0] aluResult;
wire    [31:0] rsData;
wire    [31:0] rtData;
wire    [11:0] immData;
wire    [31:0] immExtended;
wire    [ 9:0] funct;
wire    [ 1:0] aluOp;
wire    [ 0:0] aluSrc;
wire    [ 2:0] aluCtrl;
wire    [ 0:0] regWrite;
wire    [ 0:0] regDst;
wire    [31:0] mux32_o;
wire    [ 0:0] zero;

assign four = 32'b0100;
assign opCode = instr[ 6: 0];
assign rsAddr = instr[19:15];
assign rtAddr = instr[24:20];
assign rdAddr = instr[11: 7];
assign immData = instr[31:20];
assign funct = {instr[31:25], instr[14:12]};


Control Control(
    .Op_i       (opCode),
    .RegDst_o   (regDst),
    .ALUOp_o    (aluOp),
    .ALUSrc_o   (aluSrc),
    .RegWrite_o (regWrite)
);



Adder Add_PC(
    .data1_in   (instrAddr),
    .data2_in   (four),
    .data_o     (pc)
);



PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .pc_i       (pc),
    .pc_o       (instrAddr)
);


Instruction_Memory Instruction_Memory(
    .addr_i     (instrAddr), 
    .instr_o    (instr)
);


Registers Registers(
    .clk_i      (clk_i),
    .RSaddr_i   (rsAddr),
    .RTaddr_i   (rtAddr),
    .RDaddr_i   (rdAddr), 
    .RDdata_i   (aluResult),
    .RegWrite_i (regWrite), 
    .RSdata_o   (rsData), 
    .RTdata_o   (rtData) 
);


MUX5 MUX_RegDst(
    .data1_i    (rtAddr),
    .data2_i    (rdAddr),
    .select_i   (regDst),
    .data_o     (readAddr)
);



MUX32 MUX_ALUSrc(
    .data1_i    (rtData),
    .data2_i    (immExtended),
    .select_i   (aluSrc),
    .data_o     (mux32_o)
);



Sign_Extend Sign_Extend(
    .data_i     (immData),
    .data_o     (immExtended)
);

  

ALU ALU(
    .data1_i    (rsData),
    .data2_i    (mux32_o),
    .ALUCtrl_i  (aluCtrl),
    .data_o     (aluResult),
    .Zero_o     (zero)
);



ALU_Control ALU_Control(
    .funct_i    (funct),
    .ALUOp_i    (aluOp),
    .ALUCtrl_o  (aluCtrl)
);


endmodule

