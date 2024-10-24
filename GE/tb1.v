`timescale 1ns/100ps
`include "stage1.v"
`define pat_len 524288

module tb1();
	reg [6:0]	speed, random1;
	reg [1:0] 	breakfast, movement;
	reg 		weather;
	wire [1:0]	bonus1;
	wire	  	pass1;

	reg [18:0] ipt_pattern[0:`pat_len-1] ;
	reg [2:0] golden_out_pattern[0:`pat_len-1];
	reg [18:0] fail;
	
	stage1 g1(speed, random1, breakfast, movement, weather, bonus1, pass1);
	integer i;

	initial begin
		for (i=0; i<`pat_len; i=i+1) begin
			{speed,random1,breakfast,movement,weather} <= ipt_pattern[i];
			if (golden_out_pattern[i] != {bonus1, pass1}) begin
				fail = fail + 1;
				$display("Fail at %d golden_out_pattern is %b, ckt output is %b%b, current input is %b", i, golden_out_pattern[i], bonus1,pass1, ipt_pattern[i]);
			end
			#10;
		end
	end
	
	initial begin
		fail = 19'd0;
		$readmemb("stage1_input.txt", ipt_pattern);
		$readmemb("stage1_output.txt", golden_out_pattern);
	end

	initial begin
		#5242880;
		if (fail == 0) begin
			$display("Test passed");
		end
		else
			$display("There're %d fails", fail);
		$finish;
	end

endmodule
