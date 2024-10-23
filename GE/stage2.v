module stage2(pass2, bonus2, pass1, bonus1, effort, hard, random2);
	input pass1;
	input [1:0] bonus1;
	input [6:0] effort, random2;
	input [4:0] hard;
	output pass2;
	output [1:0] bonus2;
	reg [2:0] additional_point;
	assign very_hard = hard[4] & 1'b1; //hard>=16
	assign notso_hard = ~(hard[4] | hard[3] | hard[2]); //hard<3
	assign medium_hard = ~(very_hard | notso_hard);
	wire [1:0] hard_rate = {very_hard, medium_hard};
	always@(*)
		case(hard_rate)
			2'b10: additional_point <= (random2[0] | random2[1])? 3'd8 : 3'd0;
			2'b01: additional_point <= {random2[3], 1'b0, random2[4]};
			default: additional_point<= 3'd0;
		endcase
	wire [6:0] score;
	assign score = effort - {2'b00, hard} + {4'b0000, additional_point};
	assign pass_test = (score >= 7'd70)? 1'b1: 1'b0;
	assign pass_liver = (effort - {3'b000, bonus1, 2'b00} > 7'd80)? (random2[4] | random2[5]) :1'b1;
	assign pass2 = pass_test & pass_liver & pass1;
	assign bonus2 = (score > 7'd94)? 2'b11 :
		(score > 7'd87)? 2'b10 :
		(score > 7'd80)? 2'b01 : 2'b00;
endmodule
