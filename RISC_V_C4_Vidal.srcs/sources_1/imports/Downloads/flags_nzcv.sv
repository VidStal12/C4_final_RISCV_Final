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
`timescale 1ns / 1ps

module flags_nzcv #(
    parameter int ancho = 32
)(
    input  logic [ancho-1:0] a,
    input  logic [ancho-1:0] b,
    input  logic [ancho-1:0] sum,
    input  logic [ancho-1:0] result,
    input  logic             cout,
    input  logic [2:0]       alu_control,
    output logic             flag_n,
    output logic             flag_z,
    output logic             flag_c,
    output logic             flag_v
);

    logic is_add_sub;
    logic is_sub_op;

    // Válido en Suma (000), Resta (001) y comparación SLT por resta (100)
    assign is_add_sub = (alu_control == 3'b000) || (alu_control == 3'b001) || (alu_control == 3'b100);
    assign is_sub_op  = (alu_control == 3'b001) || (alu_control == 3'b100);

    // N: Bit de signo del resultado
    assign flag_n = result[ancho-1];

    // Z: Reducción NOR de todos los bits (1 cuando result == 0, usado por BEQ en RISC-V)
    assign flag_z = (result == {ancho{1'b0}});

    // C: Acarreo de salida en operaciones aritméticas
    assign flag_c = cout & is_add_sub;

    // V: Overflow en complemento a 2
    assign flag_v = is_add_sub &
                    ~(a[ancho-1] ^ b[ancho-1] ^ is_sub_op) &
                    (a[ancho-1] ^ sum[ancho-1]);

endmodule