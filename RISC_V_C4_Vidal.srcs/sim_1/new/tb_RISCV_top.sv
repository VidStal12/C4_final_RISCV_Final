`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2026 22:53:40
// Design Name: 
// Module Name: tb_RISCV_top
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

module tb_Top_RISCV_Single_Cycle;

    logic        clk;
    logic        reset;
    logic [31:0] WriteData;
    logic [31:0] DataAdr;
    logic        MemWrite;

    Top_RISCV uut (
        .clk       (clk),
        .reset     (reset),
        .WriteData (WriteData),
        .DataAdr   (DataAdr),
        .MemWrite  (MemWrite)
    );

    // Reloj de 10 ns (100 MHz)
    always begin
        clk = 1'b1; #5;
        clk = 1'b0; #5;
    end

    // Volcado de ondas para Synopsys Verdi (.fsdb) o Vivado/Icarus (.vcd)
    initial begin
        `ifdef VCS
            $fsdbDumpfile("dump_riscv.fsdb");
            $fsdbDumpvars(0, tb_Top_RISCV_Single_Cycle, "+all");
        `else
            $dumpfile("dump_riscv.vcd");
            $dumpvars(0, tb_Top_RISCV_Single_Cycle);
        `endif
    end

    initial begin
        $display(" INICIANDO SIMULACION RISC-V SINGLE-CYCLE CON TOP_ALU DE 32 BITS");
        reset = 1'b1;
        #22;
        reset = 1'b0;

        #600;
        $display("[TIMEOUT] La simulacion excedio el tiempo limite.");
        $finish;
    end

    always @(negedge clk) begin
        if (!reset) begin
            $display("T=%0t ns | PC=0x%02h | Instr=0x%08h | ALUCtrl=%b | DataAdr=%0d | WriteData=%0d | MemWrite=%b",
                     $time, uut.PC, uut.Instr, uut.u_riscv_core.alucontrol, DataAdr, WriteData, MemWrite);

            if (MemWrite) begin
                if (DataAdr === 32'd80 && WriteData === 32'd7) begin
                    $display(" ---> [PASS 1/4] sw intermedio correcto: Mem[80] = %0d (Esperado: 7)", WriteData);
                end else if (DataAdr === 32'd100 && WriteData === 32'd25) begin
                    $display(" ---> [PASS 2/4] Programa Harris & Harris correcto: Mem[100] = %0d (Esperado: 25)", WriteData);
                end else if (DataAdr === 32'd104 && WriteData === 32'd3) begin
                    $display(" ---> [PASS 3/4] Division (25 / 7) correcta: Mem[104] = %0d (Esperado: 3)", WriteData);
                end else if (DataAdr === 32'd108 && WriteData === 32'd4) begin
                    $display(" ---> [PASS 4/4] Residuo  (25 %% 7) correcto: Mem[108] = %0d (Esperado: 4)", WriteData);
                    $display(" [EXITO TOTAL] TODAS LAS INSTRUCCIONES RV32I + DIV/REM VERIFICADAS!");
                    #10;
                    $finish;
                end else begin
                    $display(" [FAIL] Escritura inesperada: Mem[%0d] = %0d", DataAdr, WriteData);
                    #10;
                    $finish;
                end
            end
        end
    end

endmodule