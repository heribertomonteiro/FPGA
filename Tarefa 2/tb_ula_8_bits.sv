`timescale 1ns/1ps

module tb_ula_8_bits;
  reg [7:0] a, b;
  reg [3:0] s;   
  reg m, c_in;   

  wire [7:0] f;  
  wire a_eq_b;   
  wire c_out;     

  ula_8_bits uut (
    .a(a),
    .b(b),
    .s(s),
    .m(m),
    .c_in(c_in),
    .f(f),
    .a_eq_b(a_eq_b),
    .c_out(c_out)
  );

  integer mode_i, func_i;

  initial begin
    $dumpfile("ula_8_bits.vcd");
    $dumpvars(0, tb_ula_8_bits);

    // Percorre modo Aritmético e Lógico
    for (mode_i = 0; mode_i < 2; mode_i = mode_i + 1) begin
      m = mode_i;
      if (m)
        $display("\n------------MODO LOGICO------------");
      else
        $display("\n------------MODO ARITMETICO------------");

      // Varre todas as 16 funções possíveis
      for (func_i = 0; func_i < 16; func_i = func_i + 1) begin
        s = func_i;
        $display("-- OPERACAO (S) BIT: = %b --", s);

        // 6 casos de teste representativos
        a = 8'b00000000; b = 8'b00000000; c_in = 1'b0; #10;
        $display(" a=%b b=%b c_in=%b f=%b c_out=%b a_eq_b=%b",
                 a, b, c_in, f, c_out, a_eq_b);

        a = 8'b11111111; b = 8'b11111111; c_in = 1'b1; #10;
        $display(" a=%b b=%b c_in=%b f=%b c_out=%b a_eq_b=%b",
                 a, b, c_in, f, c_out, a_eq_b);

        a = 8'b10101010; b = 8'b01010101; c_in = 1'b0; #10;
        $display(" a=%b b=%b c_in=%b f=%b c_out=%b a_eq_b=%b",
                 a, b, c_in, f, c_out, a_eq_b);

        a = 8'b01100110; b = 8'b10011001; c_in = 1'b1; #10;
        $display(" a=%b b=%b c_in=%b f=%b c_out=%b a_eq_b=%b",
                 a, b, c_in, f, c_out, a_eq_b);

        a = 8'b11001100; b = 8'b00110011; c_in = 1'b0; #10;
        $display(" a=%b b=%b c_in=%b f=%b c_out=%b a_eq_b=%b",
                 a, b, c_in, f, c_out, a_eq_b);

        a = 8'b00110011; b = 8'b11001100; c_in = 1'b1; #10;
        $display(" a=%b b=%b c_in=%b f=%b c_out=%b a_eq_b=%b",
                 a, b, c_in, f, c_out, a_eq_b);
      end
    end

    #100;
    $finish;
  end
endmodule
