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
	 output  logic [6:0] segL,
	 output  logic [6:0] segR,
	 output  logic [1:0] power,
	 output  logic [3:0] led
);

   logic 	   int_osc;
   logic 	   seg_clk;
   logic 	   count;
   logic 	   choosen_switch;
   logic [3:0] rows;

   // Internal high-speed oscillator
   HSOSC #(.CLKHF_DIV(2'b00))
         hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));
		 
  // Segments Logic

  // Instantiate counter and seven segments
  lab1_counter_rk #(.maxcount(400000), .N(19)) counter (int_osc, enable, reset, seg_clk, count);		// Set counter to output at 120Hz (one period) 
  lab1_sevenseg_rk sevensegL(switch, segL);										// Left display switches
  lab1_sevenseg_rk sevensegR(switch2, segR);										// Right display switches
  
  // Multiplexer
  assign choosen_switch = seg_clk ? power[1] : power[0];							//drives power based on which segment should be on
  
 
  // Keyboard Logic
  lab2_scanning_rk(reset, enable, int_osc, rows);									//scanning rows
  assign led[3] = ~cols[3];
  assign led[2] = ~cols[2];  
  assign led[1] = ~cols[1];
  assign led[0] = ~cols[0];

endmodule