module tb_edge;

logic clk, rst, level, tick;
localparam T = 20;

edge_dec uut(.*);

always begin
clk = 1'b0;
# (T/2);
clk = 1'b1;
# (T/2);
end

initial begin
rst = 1'b1;
# (T);
rst = 1'b0;
end

initial
begin
    $dumpfile("waveform.vcd");
    $dumpvars(0, tb_edge);
    level = 0;
    repeat(20) begin
        @(negedge clk);
        @(negedge clk);
        level = 1;
        @(negedge clk);
        level = 0;
    end
    $finish;
end

endmodule