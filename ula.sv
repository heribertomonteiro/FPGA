module ula(
    input logic[3:0] a, b,
    input logic[2:0] op,
    output logic[3:0] r,
    output logic zero
);

always_comb begin
    case(op)
        3'b000: r = a + b;
        3'b001: r = a - b;
        3'b010: r = a & b;
        3'b011: r = a | b;
        3'b100: r = a ^ b;
        3'b101: r = (a == b) ? 4'b0001 : 4'b0000;
        default: r = 4'b000;
    endcase
end

assign zero = (r == 0);
endmodule