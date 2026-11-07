`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.10.2026 11:08:45
// Design Name: 
// Module Name: prefix_adder
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

module logica_triestado #(
    parameter ancho = 32
)(
    input  logic [ancho-1:0] a,
    input  logic [ancho-1:0] b,
    input  logic [2:0]       alu_control,
    output logic [ancho-1:0] out_and,
    output logic [ancho-1:0] out_or
);

    logic enable_and;
    logic enable_or;
// asinacion de estados 
    assign enable_and = (alu_control == 3'b010);
    assign enable_or  = (alu_control == 3'b011);
// alta imperancia
    assign out_and = enable_and ? (a & b) : {ancho{1'bz}};
    assign out_or  = enable_or  ? (a | b) : {ancho{1'bz}};

endmodule




