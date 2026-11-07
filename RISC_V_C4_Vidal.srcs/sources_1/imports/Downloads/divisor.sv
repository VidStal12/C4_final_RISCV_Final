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

module divisor #(
    parameter int WIDTH = 32
)(
    input  logic [WIDTH-1:0] a,
    input  logic [WIDTH-1:0] b,
    output logic [WIDTH-1:0] cociente,
    output logic [WIDTH-1:0] residuo
);

    always_comb begin
        logic [WIDTH-1:0] q_temp;
        logic [WIDTH:0]   r_temp;
        logic [WIDTH:0]   diff;

        q_temp = '0;
        r_temp = '0;
        diff   = '0;

        if (b == '0) begin
            // Manejo de división por cero
            cociente = '0;
            residuo  = a;
        end else begin
            for (int i = WIDTH - 1; i >= 0; i--) begin
                r_temp = {r_temp[WIDTH-1:0], a[i]};
                diff   = r_temp - {1'b0, b};

                if (~diff[WIDTH]) begin
                    r_temp    = {1'b0, diff[WIDTH-1:0]};
                    q_temp[i] = 1'b1;
                end else begin
                    q_temp[i] = 1'b0;
                end
            end
            cociente = q_temp;
            residuo  = r_temp[WIDTH-1:0];
        end
    end

endmodule              
              
       
      


