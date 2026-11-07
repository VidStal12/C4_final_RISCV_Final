`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2026 22:47:57
// Design Name: 
// Module Name: imem
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


module imem (
    input  logic [31:0] a,
    output logic [31:0] rd
);

    logic [31:0] RAM [0:63];

    initial begin
        for (int i = 0; i < 64; i++) begin
            RAM[i] = 32'h00000013; // NOP (addi x0, x0, 0)
        end

        // Programa de prueba de Harris & Harris Cap. 7 + División/Residuo en tu Top_ALU
        RAM[0]  = 32'h00500113; // 0x00: addi x2, x0, 5        -> x2 = 5
        RAM[1]  = 32'h00C00193; // 0x04: addi x3, x0, 12       -> x3 = 12
        RAM[2]  = 32'hFF718393; // 0x08: addi x7, x3, -9       -> x7 = 12 - 9 = 3
        RAM[3]  = 32'h0023E233; // 0x0C: or   x4, x7, x2       -> x4 = 3 | 5 = 7
        RAM[4]  = 32'h0041F2B3; // 0x10: and  x5, x3, x4       -> x5 = 12 & 7 = 4
        RAM[5]  = 32'h004282B3; // 0x14: add  x5, x5, x4       -> x5 = 4 + 7 = 11
        RAM[6]  = 32'h02728863; // 0x18: beq  x5, x7, end      -> No salta (11 != 3)
        RAM[7]  = 32'h0041A233; // 0x1C: slt  x4, x3, x4       -> x4 = (12 < 7) = 0
        RAM[8]  = 32'h00020463; // 0x20: beq  x4, x0, around   -> Salta a 0x28 (0 == 0)
        RAM[9]  = 32'h00000293; // 0x24: addi x5, x0, 0        -> (Omitida por beq)
        RAM[10] = 32'h0023A233; // 0x28: slt  x4, x7, x2       -> x4 = (3 < 5) = 1
        RAM[11] = 32'h005203B3; // 0x2C: add  x7, x4, x5       -> x7 = 1 + 11 = 12
        RAM[12] = 32'h402383B3; // 0x30: sub  x7, x7, x2       -> x7 = 12 - 5 = 7
        RAM[13] = 32'h0471AA23; // 0x34: sw   x7, 68(x3)       -> Mem[12 + 68] = Mem[80] = 7
        RAM[14] = 32'h05002103; // 0x38: lw   x2, 80(x0)       -> x2 = Mem[80] = 7
        RAM[15] = 32'h008001EF; // 0x3C: jal  x3, end          -> x3 = 0x40 (64), salta a 0x44
        RAM[16] = 32'h00100113; // 0x40: addi x2, x0, 1        -> (Omitida por jal)
        RAM[17] = 32'h00510133; // 0x44: add  x2, x2, x5       -> x2 = 7 + 11 = 18
        RAM[18] = 32'h00710133; // 0x48: add  x2, x2, x7       -> x2 = 18 + 7 = 25
        RAM[19] = 32'h0221A223; // 0x4C: sw   x2, 36(x3)       -> Mem[64 + 36] = Mem[100] = 25
        RAM[20] = 32'h02714333; // 0x50: div  x6, x2, x7       -> x6 = 25 / 7 = 3 (usa divisor.sv)
        RAM[21] = 32'h02716433; // 0x54: rem  x8, x2, x7       -> x8 = 25 % 7 = 4 (usa divisor.sv)
        RAM[22] = 32'h0261A423; // 0x58: sw   x6, 40(x3)       -> Mem[64 + 40] = Mem[104] = 3
        RAM[23] = 32'h0281A623; // 0x5C: sw   x8, 44(x3)       -> Mem[64 + 44] = Mem[108] = 4
    end

    assign rd = RAM[a[7:2]];

endmodule