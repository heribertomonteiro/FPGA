module ula_74181 (
    input  logic [3:0] a,b,s,
    input  logic m, c_in,
    output logic [3:0] f,
    output logic a_eq_b, c_out
);

    logic [4:0] ar;   // operação aritmética + carry
    logic [3:0] lo;   // resultado lógico
    logic eq;  // igualdade

    always_comb begin
        ar    = 5'b00000;
        lo    = 4'b0000;
        eq    = 1'b0;

        if (m) begin
            // Modo Lógico (Tabela ativa-alta)
            case (s)
                4'b0000: lo = a;             // A
                4'b0001: lo = a | b;         // A OR B
                4'b0010: lo = a & b;         // A AND B
                4'b0011: lo = 4'b0000;       // 0
                4'b0100: lo = ~(a & b);      // NAND
                4'b0101: lo = ~b;            // NOT B
                4'b0110: lo = a ^ b;         // XOR
                4'b0111: lo = a & ~b;        // A AND NOT B
                4'b1000: lo = ~a | b;        // OR invertido
                4'b1001: lo = ~(a ^ b);      // XNOR
                4'b1010: lo = b;             // B
                4'b1011: lo = a & b;         // repetido por design
                4'b1100: lo = 4'b1111;       // 1
                4'b1101: lo = ~(a | b);      // NOR
                4'b1110: lo = a | ~b;        // A OR NOT B
                4'b1111: lo = a;             // A
                default: lo = 4'bxxxx;
            endcase

        end else begin
            // Modo Aritmético (Tabela ativa-alta)
            case (s)
                4'b0000: ar = {1'b0, a} + 5'b01111 + c_in;  // A – 1
                4'b0001: ar = {1'b0, a} + {1'b0, b} + c_in; // A + B
                4'b0010: ar = {1'b0, a} + ~{1'b0, b} + 1'b1;// A – B – 1
                4'b0011: ar = 5'b00000 + 5'b00001 + c_in;   // 0 – 1
                4'b0100: ar = {1'b0, a} + (a & b) + c_in;
                4'b0101: ar = {1'b0, a} + {1'b0, b} + (a & b) + c_in;
                4'b0110: ar = {1'b0, a} + ~{1'b0, b} + c_in;// A – B – 1
                4'b0111: ar = {1'b0, a ^ b}       + c_in; // XOR + carry
                4'b1000: ar = {1'b0, a} + (a & b) + c_in;
                4'b1001: ar = {1'b0, a} + {1'b0, b} + c_in;
                4'b1010: ar = {1'b0, a} + {1'b0, b} + (a & b) + c_in;
                4'b1011: ar = {1'b0, (a & b)}     + 5'b01111 + c_in;
                4'b1100: ar = {1'b0, a} + {1'b0, a} + c_in;
                4'b1101: ar = {1'b0, (a | b)} + {1'b0, a} + c_in; // SHIFT LEFT
                4'b1110: ar = {1'b0, (a | b)} + {1'b0, a} + c_in;
                4'b1111: ar = {1'b0, a} + 5'b01111 + c_in;        // A – 1
                default: ar = 5'bxxxxx;
            endcase

            eq = (a == b);
        end
    end

    assign f = m ? lo : ar[3:0];
    assign c_out = m ? 1'b0 : ar[4];
    assign a_eq_b = eq;

endmodule
