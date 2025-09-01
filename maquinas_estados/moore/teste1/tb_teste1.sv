module tb_seqdetector;
    localparam T = 20;
    logic clk, rst, din, dout;

    seq_detect uut(.*);

    always begin
        clk = 1'b0;
        # (T/2);
        clk = 1'b1;
        # (T/2);
    end

    initial begin
        rst = 1'b1;
        # (T) 
        rst = 1'b0;
    end

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_seqdetector);
        din = 1;

        @(negedge rst)
        repeat(10) begin
            @(negedge clk);
            din = 0;
            @(negedge clk);
            din = 1;
            @(negedge clk);
            din = 0;
        end
        $finish;
    end
endmodule