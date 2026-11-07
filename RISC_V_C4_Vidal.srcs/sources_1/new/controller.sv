`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2026 22:40:14
// Design Name: 
// Module Name: controller
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

module controller (
    input  logic [6:0] op,
    input  logic [2:0] funct3,
    input  logic       funct7b5,
    input  logic       funct7b0,
    input  logic       zero,
    output logic [1:0] resultsrc,
    output logic       memwrite,
    output logic       pcsrc,
    output logic       alusrc,
    output logic       regwrite,
    output logic       jump,
    output logic [1:0] immsrc,
    output logic [2:0] alucontrol
);

    logic [1:0] aluop;
    logic       branch;

    main_decoder u_main_decoder (
        .op        (op),
        .resultsrc (resultsrc),
        .memwrite  (memwrite),
        .branch    (branch),
        .alusrc    (alusrc),
        .regwrite  (regwrite),
        .jump      (jump),
        .immsrc    (immsrc),
        .aluop     (aluop)
    );

    alu_decoder u_alu_decoder (
        .opb5       (op[5]),
        .funct3     (funct3),
        .funct7b5   (funct7b5),
        .funct7b0   (funct7b0),
        .aluop      (aluop),
        .alucontrol (alucontrol)
    );

    assign pcsrc = (branch & zero) | jump;

endmodule