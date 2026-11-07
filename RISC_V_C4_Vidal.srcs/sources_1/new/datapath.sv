`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2026 22:24:06
// Design Name: 
// Module Name: datapath
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

module datapath (
    input  logic        clk,
    input  logic        reset,
    input  logic [1:0]  resultsrc,
    input  logic        pcsrc,
    input  logic        alusrc,
    input  logic        regwrite,
    input  logic [1:0]  immsrc,
    input  logic [2:0]  alucontrol,
    output logic        zero,
    output logic [31:0] pc,
    input  logic [31:0] instr,
    output logic [31:0] aluresult,
    output logic [31:0] writedata,
    input  logic [31:0] readdata
);

    logic [31:0] pcnext;
    logic [31:0] pcplus4;
    logic [31:0] pctarget;
    logic [31:0] immext;
    logic [31:0] srca;
    logic [31:0] srcb;
    logic [31:0] result;

    // Banderas adicionales de tu Top_ALU
    logic flag_n_unused, flag_c_unused, flag_v_unused;

    // 1. Lógica del Program Counter (PC)
    program_counter #(32) u_pc_reg (
        .clk     (clk),
        .reset   (reset),
        .pc_next (pcnext),
        .pc      (pc)
    );

    adder #(32) u_pc_plus_4 (
        .a (pc),
        .b (32'd4),
        .y (pcplus4)
    );

    adder #(32) u_pc_target (
        .a (pc),
        .b (immext),
        .y (pctarget)
    );

    Mux_instancia #(.ancho(32)) u_pc_mux (
        .d0  (pcplus4),
        .d1  (pctarget),
        .sel (pcsrc),
        .y   (pcnext)
    );

    // 2. Banco de Registros y Extensión de Inmediatos
    reg_file u_reg_file (
        .clk (clk),
        .we3 (regwrite),
        .a1  (instr[19:15]),
        .a2  (instr[24:20]),
        .a3  (instr[11:7]),
        .wd3 (result),
        .rd1 (srca),
        .rd2 (writedata)
    );

    extend u_extend (
        .instr  (instr[31:7]),
        .immsrc (immsrc),
        .immext (immext)
    );

    // 3. Selección de Operando B y Ejecución en tu Top_ALU de 32 bits
    Mux_instancia #(.ancho(32)) u_srcb_mux (
        .d0  (writedata),
        .d1  (immext),
        .sel (alusrc),
        .y   (srcb)
    );

    Top_ALU #(
        .width (32)
    ) u_alu (
        .a           (srca),
        .b           (srcb),
        .alu_control (alucontrol),
        .result      (aluresult),
        .flag_n      (flag_n_unused),
        .flag_z      (zero),
        .flag_c      (flag_c_unused),
        .flag_v      (flag_v_unused)
    );

    mux3 #(32) u_result_mux (
        .d0 (aluresult),
        .d1 (readdata),
        .d2 (pcplus4),
        .s  (resultsrc),
        .y  (result)
    );

endmodule