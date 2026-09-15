//	lab2_rk_tb.sv
//	Rebecca Kong
//	rkong@hmc.edu
//	9/14/2026
//
//	A testbench used to verify that top module exercises multiplexing functionality and LED driving functionality

`timescale 1 ns/1 ns

module lab2_rk_tb();
  logic           reset;  // active low reset
  logic 		  enable; // active low enable
  logic   [3:0]   sL;     // 4-bit input switches left display
  logic   [3:0]   sR;     // 4-bit input switches right display  
  logic   [3:0]   led;    // 3 output leds
  logic   [6:0]   seg;    // 6 output segments
  logic   [3:0]   col;    // 4 columns as inputs 
  logic   [3:0]   row;    // 4 row ouputs from the scanning
  logic   [1:0]   power;  // 2 input power display


    lab2_rk dut (
        .reset(reset),
        .switchL(sL),
		.switchR(sR),
        .led(led),
		.seg(seg),
		.cols(col),
		.rows(row),
		.enable(enable),
		.power(power)
    );


  // apply stimuli and check outputs
  initial begin
	  reset = 0;
	  #30;
	  reset = 1;
	  #30;
	  enable = 0;
	  #30;
	  enable = 1;
	  #30;
	  
	// Check for multiplexer logic for switch logic
		sR = 4'b0000;				// set initial switch values for testing purposes
		sL = 4'b1111;
		#8333334;		
		assert (dut.choosen_switch == sR)       
            $display("PASSED! The multiplexer behaves as desired at time: %0t.", $time);
        else 
            $error("FAILED! The multiplexer behaves incorrectly at time: %0t.", $time);

		reset = 0;  				// set initial clock values to 0 where the clock should be at 0 --> left swtich on
		#10;    					// time for command to run
		assert (dut.choosen_switch == sL)       
            $display("PASSED! The multiplexer behaves as desired at time: %0t.", $time);
        else 
            $error("FAILED! The multiplexer behaves incorrectly at time: %0t.", $time);
			
	// Check power asserting matches the given switches
		assert (power[0] == 0)       
            $display("PASSED! The power behaves as desired at time: %0t.", $time);
        else 
            $error("FAILED! The power behaves incorrectly at time: %0t.", $time); 
		assert (power[1] == 1)       
            $display("PASSED! The power behaves as desired at time: %0t.", $time);
        else 
            $error("FAILED! The power behaves incorrectly at time: %0t.", $time); 
			
	// led verification
		#10
		col = 4'b1111;
		#10
		assert (led == 4'b0000)       
            $display("PASSED! The leds behaves as desired at time: %0t.", $time);
        else 
            $error("FAILED! The leds behaves incorrectly at time: %0t.", $time); 
			
		#10
		col = 4'b0000;
		#10	
		assert (led == 4'b1111)       
            $display("PASSED! The leds behaves as desired at time: %0t.", $time);
        else 
            $error("FAILED! The leds behaves incorrectly at time: %0t.", $time); 

			
    #100 $stop;
  end
endmodule