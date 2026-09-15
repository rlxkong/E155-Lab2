
//  lab1_sevenseg_mux_rk.sv
//  Rebecca Kong
//
//  Time-multiplexes one seven-segment decoder between two
//  4-bit inputs. The decoder drives a common-anode display,
//  so the segment outputs are active-low.
//
//  digit0 and digit1 are the two sets of seven segment outputs.
//  Only one set is enabled at a time, but switching occurs
//  rapidly enough that both displays appear continuously lit.

module lab1_sevenseg_mux_rk #(
    parameter integer MUX_COUNT = 10000
) (
    input  logic       reset,
    input  logic [3:0] switch0,
    input  logic [3:0] switch1,

    output logic [6:0] digit0,
    output logic [6:0] digit1
);

    // Internal high-speed oscillator
    logic int_osc;

    // Counter used to determine when to switch displays
    logic [$clog2(MUX_COUNT)-1:0] mux_count;

    // Selects which input is currently being decoded
    logic mux_select;

    // Input to the single seven-segment decoder
    logic [3:0] decoder_input;

    // Output of the single seven-segment decoder
    logic [6:0] decoder_output;


    //------------------------------------------------------------------
    // Internal high-speed oscillator
    //------------------------------------------------------------------
    HSOSC #(.CLKHF_DIV(2'b00))
        hf_osc (
            .CLKHFPU(1'b1),
            .CLKHFEN(1'b1),
            .CLKHF(int_osc)
        );


    //------------------------------------------------------------------
    // Multiplexing counter
    //------------------------------------------------------------------
    always_ff @(posedge int_osc) begin
        if (reset == 0) begin
            mux_count  <= '0;
            mux_select <= 1'b0;
        end
        else begin
            if (mux_count == MUX_COUNT - 1) begin
                mux_count  <= '0;
                mux_select <= ~mux_select;
            end
            else begin
                mux_count <= mux_count + 1'b1;
            end
        end
    end


    //------------------------------------------------------------------
    // Select which 4-bit input is sent to the ONE decoder
    //------------------------------------------------------------------
    always_comb begin
        if (mux_select == 1'b0)
            decoder_input = switch0;
        else
            decoder_input = switch1;
    end


    //------------------------------------------------------------------
    // Single seven-segment decoder
    //------------------------------------------------------------------
    lab1_sevenseg_rk sevenseg_decoder (
        .switch(decoder_input),
        .segments_abc_defg(decoder_output)
    );


    //------------------------------------------------------------------
    // Route decoder output to the selected display
    //
    // Because this is a common-anode display, the segment outputs
    // are active-low. A value of 0 turns a segment ON.
    //------------------------------------------------------------------
    always_comb begin

        // Default: both displays OFF
        digit0 = 7'b111_1111;
        digit1 = 7'b111_1111;

        if (mux_select == 1'b0)
            digit0 = decoder_output;
        else
            digit1 = decoder_output;

    end

endmodule

