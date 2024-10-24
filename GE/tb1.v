`timescale 1ns/100ps
`include "stage1.v"
module tb1();
	reg [6:0]	speed, random1;
	reg [1:0] 	breakfast, movement;
	reg 		weather;
	wire [1:0]	bonus1;
	wire	  	pass1;

	stage1 g1(.speed(speed), .random1(random1), .breakfast(breakfast), .movement(movement), .weather(weather), 
			  .bonus1(bonus1), .pass1(pass1));

endmodule
