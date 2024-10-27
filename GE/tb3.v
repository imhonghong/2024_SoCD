`timescale 1ns/100ps
`include "stage3.v"
`define pat_len 4096

module tb3();

    
    wire          pass3;
	reg   [2:0]   slide, timing, luck3;
    reg   [1:0]   bonus2;
    reg           pass2;	

	reg [11:0] ipt_pattern[0:`pat_len-1] ;
	reg golden_out_pattern[0:`pat_len-1];
	reg [11:0] fail;
	
	stage3 g3(pass3, luck3, slide, timing, bonus2, pass2);

	integer i;
	initial begin
		for (i=0; i<`pat_len; i=i+1) begin
			{slide, timing, luck3,bonus2, pass2} = ipt_pattern[i];	
			if (golden_out_pattern[i] != pass3) begin
				fail = fail + 1;
				$display("Fail at %d golden_out_pattern is %b, ckt output is %b, current input is %b", i, golden_out_pattern[i], pass3, ipt_pattern[i]);
				end
			#10;
		end
	end
	
	initial begin
		fail = 12'd0;
		$readmemb("stage3_input.txt", ipt_pattern);
		$readmemb("stage3_output.txt", golden_out_pattern);
	end

	initial begin
		# 40960;
		if (fail == 0) begin
			$display("Test passed, %d pattern in total", `pat_len);
		end
		else
			$display("There're %d fails", fail);
		$finish;
	end

endmodule
