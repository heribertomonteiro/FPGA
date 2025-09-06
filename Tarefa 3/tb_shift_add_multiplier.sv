module tb_shift_add_multiplier;

    logic clk, rst;
    logic [7:0] A, B;
    logic [15:0] result;
    logic done;

    shift_add_multiplier uut (
        .clk(clk),
        .rst(rst),
        .A(A),
        .B(B),
        .result(result),
        .done(done)
    );

    // Clock 10ns
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $dumpfile("tb_shift_add_multiplier.vcd"); 
        $dumpvars(0, tb_shift_add_multiplier);
    end

    // Tarefa para rodar o teste
    task run_test(input [7:0] multiplicador, input [7:0] multiplicando, input [15:0] esperado);
        begin
            A = multiplicador;
            B = multiplicando;
            rst = 1;
            @(posedge clk);
            rst = 0;
            @(posedge clk);

            wait(done == 1);  // espera a flag done

            if (result == esperado)
                $display("TESTE: %0d x %0d = %0d CORRETO", A, B, result);
            else
                $display("TESTE: %0d x %0d = %0d ERRO! Esperado: %0d", A, B, result, esperado);

            @(posedge clk);
        end
    endtask

    initial begin
        // Testes
        run_test(8'd0,    8'd0,    16'd0);        
        run_test(8'd1,    8'd255,  16'd255);     
        run_test(8'd255,  8'd1,    16'd255);   
        run_test(8'd10,   8'd30,   16'd300);   
        run_test(8'd50,   8'd50,   16'd2500);   
        run_test(8'd127,  8'd201,  16'd25527);   
        run_test(8'd255,  8'd255,  16'd65025);  
        run_test(8'd128,  8'd2,    16'd256);  
        run_test(8'd128,   8'd128,    16'd16384); 
        run_test(8'd170,   8'd170,   16'd28900); 
        run_test(8'd255,   8'd255,    16'd65025);  


        $finish;
    end

endmodule
