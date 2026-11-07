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


module prefix_adder #( parameter ancho =32 )(
input logic [ancho-1:0]a,
input logic [ancho-1:0]b,
input logic cin,
output logic [ancho-1:0]sum,
output logic cout 
); 
// cantidad minima de bits , Log2 (N) - cantidad de bits necesarios para una operacion
localparam estados = $clog2(ancho);

//Matriz para generar y propagar las señales
logic [ancho-1:0] g[estados:0];
logic [ancho-1:0] p[estados:0];
logic [ancho:0] c;
 
 //generacion y propagacion del bit
 always_comb begin 
    for(int i=0;i<ancho;i++) begin 
        g[0][i] = a[i]& b[i];
        p[0][i] = a[i]^ b[i];
        end 
 end
 
 //prefijos del sumador 
 generate
    for (genvar s =0;s<estados;s++)begin : gen_estados
    localparam int offset = (1<<s);
    always_comb begin
        for (int i =0;i<ancho;i++)begin 
            if (i>=offset) begin
                g[s+1][i]=g[s][i]|(p[s][i]&g[s][i-offset]);
                p[s+1][i]=p[s][i]&p[s][i-offset];
            end else begin
                g[s+1][i]=g[s][i];
                p[s+1][i]=p[s][i];
            end
        end
    end
end
endgenerate

//calcular accareo final de la suma 
always_comb begin 
    c[0]=cin;
    for (int i=0;i<ancho;i++)begin 
        c[i+1]=g[estados][i]|(p[estados][i]&cin);
        sum[i]= p[0][i] ^ c[i];
     end
end

assign cout = c[ancho];
endmodule
