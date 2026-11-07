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

module Mux_instancia #(
parameter  ancho = 32
)(
input logic [ancho-1:0]d0,
input logic [ancho-1:0]d1,
input logic sel,
output logic [ancho-1:0] y
);
// operador ternario 
assign y = sel ? d1:d0;

endmodule 