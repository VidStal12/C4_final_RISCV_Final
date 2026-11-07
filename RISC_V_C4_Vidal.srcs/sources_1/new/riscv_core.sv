`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2026 22:41:48
// Design Name: 
// Module Name: riscv_core
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module riscv_core (
    input  logic        clk,
    input  logic        reset,
    output logic [31:0] pc,
    input  logic [31:0] instr,
    output logic        memwrite,
    output logic [31:0] aluresult,
    output logic [31:0] writedata,
    input  logic [31:0] readdata
);

    logic       alusrc;
    logic       regwrite;
    logic       jump;
    logic       zero;
    logic       pcsrc;
    logic [1:0] resultsrc;
    logic [1:0] immsrc;
    logic [2:0] alucontrol;

    controller u_controller (
        .op         (instr[6:0]),
        .funct3     (instr[14:12]),
        .funct7b5   (instr[30]),
        .funct7b0   (instr[25]),
        .zero       (zero),
        .resultsrc  (resultsrc),
        .memwrite   (memwrite),
        .pcsrc      (pcsrc),
        .alusrc     (alusrc),
        .regwrite   (regwrite),
        .jump       (jump),
        .immsrc     (immsrc),
        .alucontrol (alucontrol)
    );

    datapath u_datapath (
        .clk        (clk),
        .reset      (reset),
        .resultsrc  (resultsrc),
        .pcsrc      (pcsrc),
        .alusrc     (alusrc),
        .regwrite   (regwrite),
        .immsrc     (immsrc),
        .alucontrol (alucontrol),
        .zero       (zero),
        .pc         (pc),
        .instr      (instr),
        .aluresult  (aluresult),
        .writedata  (writedata),
        .readdata   (readdata)
    );

endmodule