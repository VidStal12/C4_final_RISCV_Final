`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2026 22:21:22
// Design Name: 
// Module Name: ALU_decoder
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

module alu_decoder (
    input  logic       opb5,
    input  logic [2:0] funct3,
    input  logic       funct7b5,
    input  logic       funct7b0,
    input  logic [1:0] aluop,
    output logic [2:0] alucontrol
);

    logic RtypeSub;
    logic is_M_ext;

    assign RtypeSub = funct7b5 & opb5;
    assign is_M_ext = funct7b0 & opb5 & (~funct7b5);

    always_comb begin
        case (aluop)
            2'b00:   alucontrol = 3'b000; // lw, sw (Suma Base + Offset)
            2'b01:   alucontrol = 3'b001; // beq (Resta para comparar igualdad con flag_z)
            default: begin
                if (is_M_ext) begin
                    case (funct3)
                        3'b100:  alucontrol = 3'b101; // div -> Cociente en Top_ALU (101)
                        3'b110:  alucontrol = 3'b110; // rem -> Residuo en Top_ALU (110)
                        default: alucontrol = 3'b000;
                    endcase
                end else begin
                    case (funct3)
                        3'b000:  alucontrol = RtypeSub ? 3'b001 : 3'b000; // sub (001) / add, addi (000)
                        3'b010:  alucontrol = 3'b100;                     // slt, slti (100 en Top_ALU)
                        3'b110:  alucontrol = 3'b011;                     // or, ori   (011 en Top_ALU)
                        3'b111:  alucontrol = 3'b010;                     // and, andi (010 en Top_ALU)
                        default: alucontrol = 3'b000;
                    endcase
                end
            end
        endcase
    end

endmodule