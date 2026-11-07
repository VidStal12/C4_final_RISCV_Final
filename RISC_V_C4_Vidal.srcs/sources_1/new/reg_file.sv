`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2026 22:35:59
// Design Name: 
// Module Name: reg_file
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

module reg_file (
    input  logic        clk,
    input  logic        we3,
    input  logic [4:0]  a1,
    input  logic [4:0]  a2,
    input  logic [4:0]  a3,
    input  logic [31:0] wd3,
    output logic [31:0] rd1,
    output logic [31:0] rd2
);

    logic [31:0] rf [31:0];

    initial begin
        for (int i = 0; i < 32; i++) begin
            rf[i] = 32'd0;
        end
    end

    always_ff @(posedge clk) begin
        if (we3 && (a3 != 5'd0)) begin
            rf[a3] <= wd3;
        end
    end

    assign rd1 = (a1 != 5'd0) ? rf[a1] : 32'd0;
    assign rd2 = (a2 != 5'd0) ? rf[a2] : 32'd0;

endmodule