module tb_porta_and;
    logic a,b,y;
    porta_and uut(
        .a(a),
        .b(b),
        .y(y)
    );

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0,a,b,y);
        a = 0;
        b = 0;
        #10 a = 1
        #10 b = 1
        #10 $finish;
    end
endmodule