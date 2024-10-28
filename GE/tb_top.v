`timescale 1ns/100ps
`include "top.v"
`define pat_len 150000

module tb_top();
	reg [6:0]   speed, random1, effort;
	reg [2:0]   slide, timing, luck3;
	reg [1:0]   breakfast, movement;
	reg [4:0]   hard, random2;
	reg         weather;
	wire        pass3;

	reg [44:0]  ipt_pattern[0:`pat_len-1] ;
	reg         golden_out_pattern[0:`pat_len-1];
	reg [17:0]  fail;
	
	top t1( .speed(speed), .random1(random1), .effort(effort), .random2(random2),
            .slide(slide), .timing(timing), .luck3(luck3), .breakfast(breakfast),
            .movement(movement), .hard(hard), .weather(weather), .pass3(pass3));
	integer i;

	initial begin
		for (i=0; i<`pat_len; i=i+1) begin
			{   speed, random1, breakfast, movement, weather,  
                effort, hard ,random2,
                slide, timing, luck3 } <= ipt_pattern[i];
			if (golden_out_pattern[i] != pass3) begin
				fail = fail + 1;
				$display("Fail at %d golden_out_pattern is %b, ckt output is %b, current input is %b", i, golden_out_pattern[i], pass3, ipt_pattern[i]);
			end
			//#10;
		end
	end
	
	initial begin
		fail = 18'd0;
		$readmemb("top_input.txt", ipt_pattern);
		$readmemb("top_output.txt", golden_out_pattern);
	end

	initial begin
		# 1500000 ;
		if (fail == 0) begin
			$display("Test passed, %d pattern in total", `pat_len);
		end
		else
			$display("There're %d fails", fail);
		$finish;
	end

endmodule
