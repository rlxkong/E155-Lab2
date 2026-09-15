//	lab2_scannimg_rk_tb.sv
//	Rebecca Kong
//	rkong@hmc.edu
//	9/14/2026
//
//	A testbench used to verify that it transititons through all the row outputs and enable and reset
// apply stimuli and check outputs


`timescale 1 ns/1 ns

module lab2_scanning_rk_tb();
  logic           reset;  // active low reset
  logic 		  enable; // active low enable
  logic           clk;    // input HSOSC clock
  logic   [3:0]   row;    // row outputs


    lab2_scanning_rk dut (
        .reset(reset),
		.enable(enable),
		.clk(clk),
		.row(row)
    );
	
  // generate clock
  always begin
      clk = 0; #10;
      clk = 1; #10;
  end

  initial begin
    reset = 0;
    #20; 			// initial set all values to 0
	reset = 1; 
	#20; 			// resume the code (one cycle)

	// enable and reset verification
		enable = 0;								// set enable to 0 should freeze the code
        #60000000;                       			
        assert (row[0])    
            $display("PASSED! The enable behaves as desired at time: %0t.", $time);
        else 
            $error("FAILED! The enable behaves incorrectly at time: %0t.", $time);
			
		enable = 1;
		#120000000;			// wait a cycle for enable to occur (continue counting)
		assert (row[1])    
            $display("PASSED! The enable behaves as desired at time: %0t.", $time);
        else 
            $error("FAILED! The enable behaves incorrectly at time: %0t.", $time); 
			
		enable = 0;
		#60000000; 			// check that count freezes when enable is low
		assert (row[1])    
            $display("PASSED! The enable behaves as desired at time: %0t.", $time);
        else 
            $error("FAILED! The enable behaves incorrectly at time: %0t.", $time); 
		
		reset = 0;
		#60000000;			// reset all initial values to 0
		assert (row[0])  
            $display("PASSED! The reset behaves as desired at time: %0t.", $time);
        else 
            $error("FAILED! The reset behaves incorrectly at time: %0t.", $time);

		enable = 1;
		#60000000;			// reset all initial values to 0
		assert (row[0])  
            $display("PASSED! The enable behaves as desired at time: %0t.", $time);
        else 
            $error("FAILED! The enable behaves incorrectly at time: %0t.", $time);
			
	// reset verification 
		reset = 1;
		#20;			// wait a cycle for reset to occur
		
		
	// row outputs
		assert ((dut.count < 6000000) & (row[0]))
            $display("PASSED! The led behaves as desired at time: %0t.", $time);
        else 
            $error("FAILED! The led behaves incorrectly at time: %0t.", $time); 
			
		#120000000;  	// 20ns per cycle 
		assert ((dut.count >= 6000000) & (dut.count < 12000000) & (row[1]))
            $display("PASSED! The led behaves as desired at time: %0t.", $time);
        else 
            $error("FAILED! The led behaves incorrectly at time: %0t.", $time); 

		#120000000;  	// 20ns per cycle 
		assert ((dut.count >= 12000000) & (dut.count < 18000000)  & (row[2]))
            $display("PASSED! The led behaves as desired at time: %0t.", $time);
        else 
            $error("FAILED! The led behaves incorrectly at time: %0t.", $time); 

		#120000000;  	// 20ns per cycle 
		assert ((dut.count > 18000000) & (row[3]))
            $display("PASSED! The led behaves as desired at time: %0t.", $time);
        else 
            $error("FAILED! The led behaves incorrectly at time: %0t.", $time); 
		#110000000;  	// 20ns per cycle

			
    #100 $stop;
  end
endmodule