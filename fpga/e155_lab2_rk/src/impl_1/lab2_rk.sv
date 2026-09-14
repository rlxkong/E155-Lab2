 //	lab2_rk.sv
//	Rebecca Kong
//	rkong@hmc.edu
//	9/10/2026
//
//	The top level module consisting only of instantiated modules and switch-to-LED logic.
 
 module lab2_rk(
	 input   logic       reset,
	 input   logic       enable,
	 input   logic [3:0] switchL,
	 input   logic [3:0] switchR,
	 input   logic [3:0] cols,
	 output  logic [3:0] rows,
	 output  logic [6:0] seg,
	 output  logic [1:0] power,
	 output  logic [3:0] led
);

   logic 	    int_osc;
   logic 	    seg_clk;
   logic [3:0]  choosen_switch;
   logic [18:0] count;

   // Internal high-speed oscillator
   HSOSC #(.CLKHF_DIV(2'b00))
         hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));
		 
  // Segments Logic

  // Instantiate counter and seven segments
  lab1_counter_rk #(.maxcount(400000), .N(19)) counter (int_osc, enable, reset, seg_clk, count);		// Set counter to output at 120Hz (one period) 
  // Multiplexer segment choosing
  assign choosen_switch = seg_clk ? switchR : switchL;							//chooses switch based on which segment should be on
  
  lab1_sevenseg_rk sevenseg(choosen_switch, seg);								// Display based on switches
  assign power[0] = seg_clk;													// Left display turns
  assign power[1] = ~seg_clk; 													// Right display turns on
 
  // Keyboard Logic
  lab2_scanning_rk(reset, enable, int_osc, rows);								//scanning rows
  assign led[3] = ~cols[3];
  assign led[2] = ~cols[2];  
  assign led[1] = ~cols[1];
  assign led[0] = ~cols[0];

endmodule