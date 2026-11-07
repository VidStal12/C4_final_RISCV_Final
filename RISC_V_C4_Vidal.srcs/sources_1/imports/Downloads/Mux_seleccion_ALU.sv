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

module Mux_decision #(parameter ancho =32)(
input logic [ancho-1:0]d0,
input logic [ancho-1:0]d1,
input logic [ancho-1:0]d2,
input logic [ancho-1:0]d3,
input logic [ancho-1:0]d4,
input logic [ancho-1:0]d5,
input logic [ancho-1:0]d6,
input logic [ancho-1:0]d7,
input logic [2:0] sel,
output logic [ancho-1:0] y 
);

assign y = (sel == 3'b000)? d0:
           (sel == 3'b001)? d1:
           (sel == 3'b010)? d2:
           (sel == 3'b011)? d3:
           (sel == 3'b100)? d4:
           (sel == 3'b101)? d5:
           (sel == 3'b110)? d6:d7;

endmodule
           