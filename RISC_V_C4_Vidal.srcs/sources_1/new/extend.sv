`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2026 22:37:08
// Design Name: 
// Module Name: extend
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


module extend (
    input  logic [31:7] instr,
    input  logic [1:0]  immsrc,
    output logic [31:0] immext
);

    always_comb begin
        case (immsrc)
            // Tipo I (lw, addi, slti, andi, ori)
            2'b00:   immext = {{20{instr[31]}}, instr[31:20]};
            // Tipo S (sw)
            2'b01:   immext = {{20{instr[31]}}, instr[31:25], instr[11:7]};
            // Tipo B (beq)
            2'b10:   immext = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
            // Tipo J (jal)
            2'b11:   immext = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
            default: immext = 32'd0;
        endcase
    end

endmodule