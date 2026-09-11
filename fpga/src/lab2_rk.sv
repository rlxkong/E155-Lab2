 //	lab1_rk.sv
//	Rebecca Kong
//	rkong@hmc.edu
//	9/4/2026
//
//	The top level module consisting only of instantiated modules and switch-to-LED logic.
 
 module lab1_rk(
	 input   logic       reset,
	 input   logic       enable,
	 input   logic [3:0] switch,
     output  logic [2:0] led,
	 output  logic [6:0] seg
);

   logic int_osc;
   logic [3:0] s;

   // Internal high-speed oscillator
   HSOSC #(.CLKHF_DIV(2'b00))
         hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));

  // Instantiate counter and seven segments
  lab1_counter_rk lab1_counter_rk(int_osc, enable, reset, led[2]);
  lab1_sevenseg_rk lab1_sevenseg_rk(switch, seg);
  
  // LED switch logic
  assign s = ~switch;
  assign led[0] = s[1] ^ s[0];
  assign led[1] = s[3] & s[2]; 

endmodule