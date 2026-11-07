`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2026 22:48:41
// Design Name: 
// Module Name: dmem
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


module dmem (
    input  logic        clk,
    input  logic        we,
    input  logic [31:0] a,
    input  logic [31:0] wd,
    output logic [31:0] rd
);

    logic [31:0] RAM [0:63];

    initial begin
        for (int i = 0; i < 64; i++) begin
            RAM[i] = 32'd0;
        end
    end

    assign rd = RAM[a[7:2]];

    always_ff @(posedge clk) begin
        if (we) begin
            RAM[a[7:2]] <= wd;
        end
    end

endmodule