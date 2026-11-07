`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.10.2026 20:28:42
// Design Name: 
// Module Name: Top_ALU
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

module Top_ALU #(
    parameter int width = 32
)(
    input  logic [width-1:0] a,
    input  logic [width-1:0] b,
    input  logic [2:0]       alu_control,

    output logic [width-1:0] result,
    output logic             flag_n,
    output logic             flag_z,
    output logic             flag_c,
    output logic             flag_v
);

    // Cables internos de interconexión
    logic             is_sub;
    logic [width-1:0] b_inverted;
    logic [width-1:0] b_mux_out;
    logic [width-1:0] sum_out;
    logic             cout_out;

    logic [width-1:0] and_tri_out;
    logic [width-1:0] or_tri_out;
    logic [width-1:0] and_resolved;
    logic [width-1:0] or_resolved;

    logic [width-1:0] div_cociente;
    logic [width-1:0] div_residuo;
    logic [width-1:0] slt_result;

    // Activar modo resta en el sumador tanto para SUB/BEQ (001) como para SLT (100)
    assign is_sub     = (alu_control == 3'b001) || (alu_control == 3'b100);

    // 1. Inversión de B para resta (Complemento a 1)
    assign b_inverted = ~b;

    // 2. Mux 2:1 para seleccionar B o ~B (Controlado por is_sub)
    Mux_instancia #(.ancho(width)) u_mux_b (
        .d0  (b),
        .d1  (b_inverted),
        .sel (is_sub),
        .y   (b_mux_out)
    );

    // 3. Sumador de Prefijo Paralelo (Kogge-Stone de 32 bits)
    prefix_adder #(.ancho(width)) u_adder (
        .a    (a),
        .b    (b_mux_out),
        .cin  (is_sub),        // Si es resta (001) o SLT (100), cin = 1 (Complemento a 2)
        .sum  (sum_out),
        .cout (cout_out)
    );

    // 4. Lógica Tri-Estado para AND y OR
    logica_triestado #(.ancho(width)) u_logic_tristate (
        .a           (a),
        .b           (b),
        .alu_control (alu_control),
        .out_and     (and_tri_out),
        .out_or      (or_tri_out)
    );

    // Resolver señales tri-estado
    assign and_resolved = (alu_control == 3'b010) ? and_tri_out : {width{1'b0}};
    assign or_resolved  = (alu_control == 3'b011) ? or_tri_out  : {width{1'b0}};

    // 5. Divisor de 32 bits (Cociente y Residuo)
    divisor #(.WIDTH(width)) u_divisor (
        .a        (a),
        .b        (b),
        .cociente (div_cociente),
        .residuo  (div_residuo)
    );

    // Cálculo de SLT (Set Less Than con signo): 1 si (a < b), es decir (sum_out[MSB] ^ flag_v)
    assign slt_result = {{(width-1){1'b0}}, (sum_out[width-1] ^ flag_v)};

    // 6. Multiplexor de Selección Final (Mux 8:1)
    Mux_decision #(.ancho(width)) u_mux_final (
        .d0  (sum_out),          // 000: Suma (add, addi, lw/ldr, sw)
        .d1  (sum_out),          // 001: Resta (sub, beq)
        .d2  (and_resolved),     // 010: AND (and, andi)
        .d3  (or_resolved),      // 011: OR (or, ori)
        .d4  (slt_result),       // 100: SLT (slt, slti - Set Less Than)
        .d5  (div_cociente),     // 101: Cociente de División (div)
        .d6  (div_residuo),      // 110: Residuo de División (rem)
        .d7  ({width{1'b0}}),    // 111: Todos los bits en 0
        .sel (alu_control),
        .y   (result)
    );

    // 7. Generador de Banderas de Estado NZCV
    flags_nzcv #(.ancho(width)) u_flags (
        .a           (a),
        .b           (b),
        .sum         (sum_out),
        .result      (result),
        .cout        (cout_out),
        .alu_control (alu_control),
        .flag_n      (flag_n),
        .flag_z      (flag_z),
        .flag_c      (flag_c),
        .flag_v      (flag_v)
    );

endmodule