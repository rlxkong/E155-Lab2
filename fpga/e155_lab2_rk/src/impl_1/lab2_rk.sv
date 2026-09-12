 //	lab2_rk.sv
//	Rebecca Kong
//	rkong@hmc.edu
//	9/10/2026
//
//	The top level module consisting only of instantiated modules and switch-to-LED logic.
 
 module lab2_rk(
	 input   logic       reset,
	 input   logic       enable,
	 input   logic [3:0] switch,
	 input   logic [3:0] switch2,
	 output  logic [6:0] segL,
	 output  logic [6:0] segR,
	 output  logic [1:0] power
);

   logic 	   int_osc;
   logic 	   seg_clk;
   logic   	   segL;
   logic  	   segR;
   logic 	   count;
   logic [1:0] power;
   logic 	   choosen_switch;

   // Internal high-speed oscillator
   HSOSC #(.CLKHF_DIV(2'b00))
         hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));
		 
  // Segments Logic

  // Instantiate counter and seven segments
  lab1_counter_rk counter #(100000) (int_osc, enable, reset, seg_clk, count);		// Set counter to output at 120Hz (one period)
  lab1_sevenseg_rk sevensegL(switch, segL);										// Left display switches
  lab1_sevenseg_rk sevensegR(switch2, segR);										// Right display switches
  
  // Multiplexer
  assign choosen_switch = seg_clk ? power[1] : power[0];							//drives power based on which segment should be on
  
  
  // Keyboard Logic
  
  

endmodule