module edge_dec(
    input logic clk, rst, level,
    output logic tick
);

typedef enum {zero, one} state_type;
state_type state_next, state_reg;

always_ff @(posedge clk, posedge rst) begin
    if(rst)
        state_reg <= zero;
    else
        state_reg <= state_next; 
end

always_comb begin
    state_next = state_reg;
    tick = 1'b1;
    case (state_reg)
        zero:
            if(level) begin
                state_next = one;
                tick = 1'b1;
            end
        one:
            if(~one)
                state_next = zero;
            default: state_next = zero;
    endcase
end
endmodule