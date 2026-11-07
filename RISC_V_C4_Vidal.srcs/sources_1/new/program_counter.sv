`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2026 22:32:18
// Design Name: 
// Module Name: program_counter
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

module program_counter #(
    parameter int WIDTH = 32
)(
    input  logic             clk,
    input  logic             reset,
    input  logic [WIDTH-1:0] pc_next,
    output logic [WIDTH-1:0] pc
);

    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            pc <= '0;
        else
            pc <= pc_next;
    end

endmodule