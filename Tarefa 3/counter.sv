module counter #(parameter N = 8) (
    input logic clk,
    input logic rst,
    input logic load,
    input logic en,
    input logic up_down,
    input logic [N-1:0] data_in,
    output logic [N-1:0] data_out,
    output logic end_count
);

    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            data_out <= 0;
        else if (load)
            data_out <= data_in;
        else if (en) begin
            if (up_down)
                data_out <= data_out + 1;
            else
                data_out <= data_out - 1;
        end
    end

    assign end_count = (data_out == 0);

endmodule
