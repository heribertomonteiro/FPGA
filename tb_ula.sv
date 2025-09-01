module tb_ula;

    // Sinais para conectar à ULA
    logic [3:0] a, b;
    logic [2:0] op;
    logic [3:0] r;
    logic zero;

    // Instancia o módulo ULA
    ula uut (
        .a(a),
        .b(b),
        .op(op),
        .r(r),
        .zero(zero)
    );

    // Procedimento de teste
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_ula);
        $display("Teste da ULA");
        $display("------------------------------");
        $display("| op  |  a  |  b  |  r  | zero |");
        $display("------------------------------");

        // Teste: Soma (op = 000)
        a = 4'd3; b = 4'd2; op = 3'b000;
        #1 $display("| %b | %2d | %2d | %2d |   %b   |", op, a, b, r, zero);

        // Teste: Subtração (op = 001)
        a = 4'd7; b = 4'd5; op = 3'b001;
        #1 $display("| %b | %2d | %2d | %2d |   %b   |", op, a, b, r, zero);

        // Teste: AND (op = 010)
        a = 4'b1100; b = 4'b1010; op = 3'b010;
        #1 $display("| %b | %b | %b | %b |   %b   |", op, a, b, r, zero);

        // Teste: OR (op = 011)
        a = 4'b0101; b = 4'b0011; op = 3'b011;
        #1 $display("| %b | %b | %b | %b |   %b   |", op, a, b, r, zero);

        // Teste: XOR (op = 100)
        a = 4'b1111; b = 4'b0101; op = 3'b100;
        #1 $display("| %b | %b | %b | %b |   %b   |", op, a, b, r, zero);

        // Teste: Igualdade (op = 101), iguais
        a = 4'd9; b = 4'd9; op = 3'b101;
        #1 $display("| %b | %2d | %2d | %b |   %b   |", op, a, b, r, zero);

        // Teste: Igualdade (op = 101), diferentes
        a = 4'd9; b = 4'd8; op = 3'b101;
        #1 $display("| %b | %2d | %2d | %b |   %b   |", op, a, b, r, zero);

        // Teste: Operação inválida (default)
        a = 4'd1; b = 4'd1; op = 3'b111;
        #1 $display("| %b | %2d | %2d | %2d |   %b   |", op, a, b, r, zero);

        $display("------------------------------");
        $finish;
    end
endmodule
