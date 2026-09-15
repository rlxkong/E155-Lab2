module seven_segment_mux (
    input  logic       clk,
    input  logic [3:0] digit0,
    input  logic [3:0] digit1,

    output logic [6:0] seg0,
    output logic [6:0] seg1
);

    logic       select;
    logic [3:0] decoder_input;
    logic [6:0] decoder_output;

    // Divide the clock to create the multiplexing rate.
    // Adjust COUNTER_MAX for the desired refresh frequency.
    localparam int COUNTER_MAX = 50_000;

    logic [$clog2(COUNTER_MAX)-1:0] counter;

    // Multiplex between the two 4-bit inputs.
    always_ff @(posedge clk) begin
        if (counter == COUNTER_MAX - 1) begin
            counter <= '0;
            select  <= ~select;
        end
        else begin
            counter <= counter + 1'b1;
        end
    end

    // Select which input is presented to the single decoder.
    always_comb begin
        if (select)
            decoder_input = digit1;
        else
            decoder_input = digit0;
    end

    // Single 4-bit to 7-segment decoder.
    // Common-anode display: 0 = segment ON, 1 = segment OFF.
    always_comb begin
        case (decoder_input)
            4'h0: decoder_output = 7'b1000000;
            4'h1: decoder_output = 7'b1111001;
            4'h2: decoder_output = 7'b0100100;
            4'h3: decoder_output = 7'b0110000;
            4'h4: decoder_output = 7'b0011001;
            4'h5: decoder_output = 7'b0010010;
            4'h6: decoder_output = 7'b0000010;
            4'h7: decoder_output = 7'b1111000;
            4'h8: decoder_output = 7'b0000000;
            4'h9: decoder_output = 7'b0010000;
            4'hA: decoder_output = 7'b0001000;
            4'hB: decoder_output = 7'b0000011;
            4'hC: decoder_output = 7'b1000110;
            4'hD: decoder_output = 7'b0100001;
            4'hE: decoder_output = 7'b0000110;
            4'hF: decoder_output = 7'b0001110;
            default: decoder_output = 7'b1111111;
        endcase
    end

    // Store the decoder result into the selected output.
    always_ff @(posedge clk) begin
        if (select)
            seg1 <= decoder_output;
        else
            seg0 <= decoder_output;
    end

endmodule