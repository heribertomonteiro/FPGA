module shift_register #(parameter N = 8) (
    input  logic clk,
    input  logic rst,
    input  logic [1:0] ctrl,
    input  logic [N-1:0] parallel_in,
    input  logic ser_in,
    output logic [N-1:0] parallel_out,
    output logic ser_out
);

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            parallel_out <= '0;
            ser_out <= 1'b0;
        end else begin
            case (ctrl)
                2'b00: begin
                    parallel_out <= parallel_out;
                    ser_out <= 1'b0;
                end
                2'b01: begin // shift right
                    parallel_out <= {ser_in, parallel_out[N-1:1]};
                    ser_out <= parallel_out[0];
                end
                2'b10: begin // shift left
                    parallel_out <= {parallel_out[N-2:0], ser_in};
                    ser_out <= parallel_out[N-1];
                end
                2'b11: begin
                    parallel_out <= parallel_in;
                    ser_out <= 1'b0;
                end
            endcase
        end
    end

endmodule
