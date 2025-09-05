`timescale 1ns/1ps

module tb_ula_74181;
  reg [3:0] a, b, s;    // operandos A, B e seletor de função S[3:0]
  reg m, c_in;    // modo (0=aritmético, 1=lógico) e carry-in

  wire [3:0] f;  // saída de 4 bits
  wire a_eq_b;  // flag “A igual B”
  wire c_out;  // carry-out

  ula_74181 uut (
    .a(a), .b(b), .s(s),
    .m(m), .c_in(c_in),
    .f(f), .a_eq_b(a_eq_b), .c_out(c_out)
  );

  integer mode_i, func_i;

  initial begin
    $dumpfile("ula_74181.vcd");
    $dumpvars(0, tb_ula_74181);

    for (mode_i = 0; mode_i < 2; mode_i = mode_i + 1) begin
      m = mode_i;  
      
      // Imprime no console qual modo está ativo
      if (m)
        $display("\n------------MODO LOGICO---------------");
      else
        $display("\n------------MODO ARITMETICO---------------");

      for (func_i = 0; func_i < 16; func_i = func_i + 1) begin
        s = func_i;

        $display("------- OPERACAO (S) = BITS: %b ---------", s);
        
        // Caso 1: A=0000, B=0000, Cin=0
        a    = 4'b0000; 
        b    = 4'b0000; 
        c_in = 1'b0; 
        #10;  // espera 10 ns para estabilização
        $display(" a=%b b=%b c_in=%b f=%b c_out=%b a_eq_b=%b",
                 a, b, c_in, f, c_out, a_eq_b);

        // Caso 2: A=1111, B=1111, Cin=1 (testa overflow e comparação)
        a    = 4'b1111; 
        b    = 4'b1111; 
        c_in = 1'b1; 
        #10;
        $display(" a=%b b=%b c_in=%b f=%b c_out=%b a_eq_b=%b",
                 a, b, c_in, f, c_out, a_eq_b);

        // Caso 3: A=1010, B=0101, Cin=0 (padrão misto)
        a    = 4'b1010; 
        b    = 4'b0101; 
        c_in = 1'b0; 
        #10;
        $display(" a=%b b=%b c_in=%b f=%b c_out=%b a_eq_b=%b",
                 a, b, c_in, f, c_out, a_eq_b);

        // Caso 4: A=0110, B=1001, Cin=1
        a    = 4'b0110; 
        b    = 4'b1001; 
        c_in = 1'b1; 
        #10;
        $display(" a=%b b=%b c_in=%b f=%b c_out=%b a_eq_b=%b",
                 a, b, c_in, f, c_out, a_eq_b);

        // Caso 5: A=1100, B=0011, Cin=0
        a    = 4'b1100; 
        b    = 4'b0011; 
        c_in = 1'b0; 
        #10;
        $display(" a=%b b=%b c_in=%b f=%b c_out=%b a_eq_b=%b",
                 a, b, c_in, f, c_out, a_eq_b);

        // Caso 6: A=0011, B=1100, Cin=1
        a    = 4'b0011; 
        b    = 4'b1100; 
        c_in = 1'b1; 
        #10;
        $display(" a=%b b=%b c_in=%b f=%b c_out=%b a_eq_b=%b",
                 a, b, c_in, f, c_out, a_eq_b);
      end
    end
    // Atraso extra antes de encerrar
    #100;
    $finish;  // encerra a simulação
  end
endmodule
