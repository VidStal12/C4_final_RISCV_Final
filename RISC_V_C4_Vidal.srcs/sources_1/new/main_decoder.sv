`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2026 22:39:09
// Design Name: 
// Module Name: main_decoder
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


module main_decoder (
    input  logic [6:0] op,
    output logic [1:0] resultsrc,
    output logic       memwrite,
    output logic       branch,
    output logic       alusrc,
    output logic       regwrite,
    output logic       jump,
    output logic [1:0] immsrc,
    output logic [1:0] aluop
);

    logic [10:0] controls;

    assign {regwrite, immsrc, alusrc, memwrite,
            resultsrc, branch, aluop, jump} = controls;

    always_comb begin
        case (op)
            // RegWrite_ImmSrc_ALUSrc_MemWrite_ResultSrc_Branch_ALUOp_Jump
            7'b0000011: controls = 11'b1_00_1_0_01_0_00_0; // lw
            7'b0100011: controls = 11'b0_01_1_1_00_0_00_0; // sw
            7'b0110011: controls = 11'b1_00_0_0_00_0_10_0; // R-type (incluye div/rem)
            7'b1100011: controls = 11'b0_10_0_0_00_1_01_0; // beq
            7'b0010011: controls = 11'b1_00_1_0_00_0_10_0; // I-type ALU
            7'b1101111: controls = 11'b1_11_0_0_10_0_00_1; // jal
            default:    controls = 11'b0_00_0_0_00_0_00_0; // NOP
        endcase
    end

endmodule