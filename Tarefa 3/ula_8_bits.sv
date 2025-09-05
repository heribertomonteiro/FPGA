module ula_8_bits (
    input  logic [7:0] a,b,
    input  logic [3:0] s,
    input  logic m, c_in,
    output logic [7:0] f,
    output logic a_eq_b, c_out
);

    logic c_mid;
    logic [3:0] f_low, f_high;
    logic eq_low, eq_high;

    ula_74181 lower (
        .a(a[3:0]),
        .b(b[3:0]),
        .s(s),
        .m(m),
        .c_in(c_in),
        .f(f_low),
        .a_eq_b(eq_low),
        .c_out(c_mid)
    );

    ula_74181 upper (
        .a(a[7:4]),
        .b(b[7:4]),
        .s(s),
        .m(m),
        .c_in(c_mid),
        .f(f_high),
        .a_eq_b(eq_high),
        .c_out(c_out)
    );

    assign f = {f_high, f_low};
    assign a_eq_b = eq_low & eq_high;
endmodule
