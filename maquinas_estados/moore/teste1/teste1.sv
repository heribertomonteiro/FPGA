module seq_detect(
input logic clk, rst, din,
output logic dout
);
    typedef enum { s0, s1, s2, s3} state_type;
    state_type state_next, state_reg;

    always_ff @(posedge clk, posedge rst) begin
        if (rst)
            state_reg <= s0;
        else
            state_reg <= state_next;
        end

    always_comb begin
    state_next = state_reg;
    dout = 1'b0;
    case (state_reg)
        s0:
            if (din)
                state_next = s1;
        s1:
            if (~din)
                state_next = s2;
        s2:
            if (din)
                state_next = s3;

        s3:
            begin
                if (din)
                    state_next = s1;
                else
                    state_next = s0;
                dout = 1'b1;
            end
        endcase
    end
endmodule
