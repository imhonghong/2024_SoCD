`timescale 1ns/100ps
`include "stage1.v"
`define pat_len = 524288;

module tb1();
	reg [6:0]	speed, random1;
	reg [1:0] 	breakfast, movement;
	reg 		weather;
	wire [1:0]	bonus1;
	wire	  	pass1;
	
	reg [18:0] ipt_pattern[0:pat_len-1] ;
	reg [2:0] golden_out_pattern[0:pat_len-1]; 
	
	stage1 g1(.speed(speed), .random1(random1), .breakfast(breakfast), .movement(movement), .weather(weather), 
			  .bonus1(bonus1), .pass1(pass1));
	
	integer i;
	initial begin
		for (i=0; i<524287; i++) begin
			{speed, random1, breakfast, movement, weather} = ipt_pattern[i];	// 7,7,2,2,1 bits
			#10;
		end
	end
	
	initial begin
		if ()
	end
	
	
	initial begin
		# ;	$finish;
	end

endmodule
