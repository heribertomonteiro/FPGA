module shift_add_multiplier (
    input  logic clk,
    input  logic rst,
    input  logic [7:0] A,  // Multiplicador
    input  logic [7:0] B,  // Multiplicando
    output logic [15:0] result,  // Agora 17 bits para conter carry extra
    output logic done
);
    typedef enum logic [2:0] {IDLE, CHECK, ADD, SHIFT, DONE} state_t;
    state_t state, next_state;

    // Acomulador A com 9 bits (8 bits + carry)
    logic [8:0] a_reg_out;
    logic [7:0] b_reg_out, q_reg_out;

    // ULA 8 bits e carry_in
    logic [7:0] ula_result;
    logic ula_carry;

    logic [1:0] ctrl_a, ctrl_q;
    logic [8:0] parallel_a;  // 9 bits agora
    logic [7:0] parallel_q;
    logic ser_a, ser_q;

    logic [7:0] counter_out;
    logic load_counter, enable_counter, end_count;

    // Q bit 0 combinado
    logic q0_bit_comb;

    // Reg para guardar carry entre somas
    logic carry_reg;

    // -------------------------------
    // Instancia shift_register para 9 bits (A)
    // -------------------------------
    shift_register #(9) regA (
        .clk(clk),
        .rst(rst),
        .ctrl(ctrl_a),
        .parallel_in(parallel_a),
        .ser_in(1'b0),   // shift right insere zero no MSB
        .parallel_out(a_reg_out),
        .ser_out(ser_a)
    );

    // Registrador B (8 bits)
    shift_register #(8) regB (
        .clk(clk),
        .rst(rst),
        .ctrl(2'b11),
        .parallel_in(B),
        .ser_in(1'b0),
        .parallel_out(b_reg_out),
        .ser_out()
    );

    // Registrador Q (8 bits)
    shift_register #(8) regQ (
        .clk(clk),
        .rst(rst),
        .ctrl(ctrl_q),
        .parallel_in(parallel_q),
        .ser_in(a_reg_out[0]),  // bit 0 de A vai para Q no shift
        .parallel_out(q_reg_out),
        .ser_out(ser_q)
    );

    // Contador
    counter #(8) count (
        .clk(clk),
        .rst(rst),
        .load(load_counter),
        .en(enable_counter),
        .up_down(1'b0),
        .data_in(8'd7),
        .data_out(counter_out),
        .end_count(end_count)
    );

    // ULA só opera nos 8 bits inferiores de A + carry_reg
    ula_8_bits ula (
        .a(a_reg_out[7:0]),
        .b(b_reg_out),
        .s(4'b0001),        // soma
        .m(1'b0),
        .c_in(1'b0),
        .f(ula_result),
        .a_eq_b(),
        .c_out(ula_carry)
    );

    assign q0_bit_comb = q_reg_out[0];

    // Atualiza carry_reg no clock só no estado ADD ou reset
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            carry_reg <= 0;
        else if (state == ADD)
            carry_reg <= ula_carry;
        else if (state == IDLE)
            carry_reg <= 0;
    end

    // Máquina de estados
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            state <= IDLE;
        else
            state <= next_state;
    end

    always_comb begin
        next_state = state;
        ctrl_a = 2'b00;
        ctrl_q = 2'b00;
        parallel_a = 9'b0;
        parallel_q = 8'b0;
        load_counter = 0;
        enable_counter = 0;
        done = 0;

        case(state)
            IDLE: begin
                ctrl_a = 2'b11;       // Load paralelo A=0
                ctrl_q = 2'b11;       // Load paralelo Q = multiplicador A
                parallel_a = 9'b0;
                parallel_q = A;
                load_counter = 1;
                next_state = CHECK;
            end

            CHECK: begin
                if (q0_bit_comb)
                    next_state = ADD;
                else
                    next_state = SHIFT;
            end

            ADD: begin
                ctrl_a = 2'b11;       // Load resultado da ULA no A (8 bits + carry)
                parallel_a = {ula_carry, ula_result};  // concatena carry MSB
                next_state = SHIFT;
            end

            SHIFT: begin
                ctrl_a = 2'b01;       // Shift right A (9 bits)
                ctrl_q = 2'b01;       // Shift right Q (8 bits)
                enable_counter = 1;

                if (end_count)
                    next_state = DONE;
                else
                    next_state = CHECK;
            end

            DONE: begin
                done = 1;
            end
        endcase
    end

    // Resultado final 17 bits: A (9 bits) + Q (8 bits)
    assign result = {a_reg_out[7:0], q_reg_out};  // descarta carry extra

endmodule
