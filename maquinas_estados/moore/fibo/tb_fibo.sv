module tb_fibo;

localparam T = 20;
logic clk, rst, start, ready, done_tick;
logic[4:0] i;
logic[19:0] f;

fibo uut (.*);

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

initial begin
    $dumpfile("waveform.vcd");
    $dumpvars(0, tb_fibo);
    start = 1;
    i = 5;
    repeat(20) @(negedge clk);
    $finish;
end

endmodule