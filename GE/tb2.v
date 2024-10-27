`timescale 1ns/100ps
`include "stage2.v"
`define pat_len 1048576

module tb2();

	reg pass1;
	reg [1:0] bonus1;
	reg [6:0] effort;
	reg [4:0] hard, random2;
	wire pass2;
	wire [1:0] bonus2;

	reg [19:0] ipt_pattern[0:`pat_len-1] ;
	reg [2:0] golden_out_pattern[0:`pat_len-1];
	reg [19:0] fail;
	
	stage2 g2(pass2, bonus2, pass1, bonus1, effort, hard, random2);
	integer i;

	initial begin
		for (i=0; i<`pat_len; i=i+1) begin
			{pass1, bonus1, effort, hard, random2} <= ipt_pattern[i];
			if (golden_out_pattern[i] != {bonus2, pass2}) begin
				fail = fail + 1;
				$display("Fail at %d golden_out_pattern is %b, ckt output is %b%b, current input is %b", i, golden_out_pattern[i], bonus2,pass2, ipt_pattern[i]);
			end
			//#10;
		end
	end
	
	initial begin
		fail = 20'd0;
		$readmemb("stage2_input.txt", ipt_pattern);
		$readmemb("stage2_output.txt", golden_out_pattern);
	end

	initial begin
		# 1048576;
		if (fail == 0) begin
			$display("Test passed, %d pattern in total", `pat_len);
		end
		else
			$display("There're %d fails", fail);
		$finish;
	end

endmodule
