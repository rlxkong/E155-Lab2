//	lab2_scanning_rk.sv
//	Rebecca Kong
//	rkong@hmc.edu
//	9/12/2026
//
//	This module implements the row scanning and button pressing to send a signal for the corresponding led to work

module lab2_scanning_rk(
	input  logic 	   reset,
	input  logic       enable,
	input  logic       clk,
	output logic [3:0] row
);

    logic [25:0] count;
	logic        period_2hz;
	

	// Instantiate counter
	lab1_counter_rk #(.maxcount(24000000), .N(33)) counter (clk, enable, reset, period_2hz, count);		// Set counter to output at 2Hz (1/2 period) 

	// Use count to track row states
	assign row[3] = (count >= 18000000);
	assign row[2] = ((count >= 12000000) & (count < 18000000));
	assign row[1] = ((count >= 6000000) & (count < 12000000));
	assign row[0] = (count < 6000000);

	
endmodule