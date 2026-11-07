`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2026 22:50:19
// Design Name: 
// Module Name: Top_RISCV
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

module Top_RISCV (
    input  logic        clk,
    input  logic        reset,
    output logic [31:0] WriteData,
    output logic [31:0] DataAdr,
    output logic        MemWrite
);

    logic [31:0] PC;
    logic [31:0] Instr;
    logic [31:0] ReadData;

    riscv_core u_riscv_core (
        .clk       (clk),
        .reset     (reset),
        .pc        (PC),
        .instr     (Instr),
        .memwrite  (MemWrite),
        .aluresult (DataAdr),
        .writedata (WriteData),
        .readdata  (ReadData)
    );

    imem u_imem (
        .a  (PC),
        .rd (Instr)
    );

    dmem u_dmem (
        .clk (clk),
        .we  (MemWrite),
        .a   (DataAdr),
        .wd  (WriteData),
        .rd  (ReadData)
    );

endmodule