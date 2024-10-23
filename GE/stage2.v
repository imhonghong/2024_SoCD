module stage2(pass1, bonus1, hard, luck, pass2, bonus2);
input pass1;
input [1:0] bonus1;
// stage input
input [6:0] work;// 0~100
// random parameter
input [6:0] hard;// 0~100
input [1:0] luck;
output reg pass2;
output reg [1:0] bonus2;

wire [6:0] b1,b2,total,score;
wire [1:0] count;

assign b1 = {3'd0,bonus1,2'd0};
assign b2 = {3'd0,luck,2'd0};
assign total = work + b1 + b2;// max: 100+12+12=124 < 127 , no overflow

assign score = (total>7'd100)?(7'd100):(7'd0);
assign count = total[6:5];//  /32

always@(*)
	if( (score>hard)&pass )
		begin
			pass2 <= 1'd1;
			bonus2 <= count;
		end
	else
		begin
			pass2 <= 1'd0;
			bonus2 <= 2'd0;
		end
endmodule		

module stage2(pass2, bonus2, pass1, bonus1, effort, hard, random2);
	input pass1;
	input [1:0] bonus1;
	input [6:0] effort;
	input [4:0] hard, random2;
	output pass2;
	output bonus2;
	wire [4:0] additional_point;
	wire [6:0] energy
	assign very_hard = hard[4] & 1'b1; //hard>=16
	assign notso_hard = ~(hard[4] | hard[3] | hard[2]); //hard<3
	assign medium_hard = ~(very_hard | medium_hard);
	always@(*) begin // additional point logic
		case(hard)
			
		endcase
	end
	assign pass_test = (effort - hard + additional_point >= 7'd70)? 1'b1: 1'b0;
	assign pass_liver = 
	
/*
student: effort-> pass/fail
	too much effort-> stick liver(Cirrhosis)
teacher: hard -> 	easy/hard to pass
	too hard -> additional point
 */
