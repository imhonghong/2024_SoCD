module top(speed, random1, effort, random2, slide, timing, luck3,breakfast, movement, hard, weather, pass3);
	input [6:0] speed, random1, effort;
	input [2:0] slide, timing, luck3;
	input [1:0] breakfast, movement;
	input [4:0] hard, random2;
	input weather;
	output pass3;
	wire [1:0] bonus1, bonus2;
	wire pass1, pass2;
	stage1 g1(.speed(speed), .random1(random1), .breakfast(breakfast), .movement(movement), .weather(weather), .bonus1(bonus1), .pass1(pass1));
	stage2 g2(.pass2(pass2), .bonus2(bonus2), .pass1(pass1), .bonus1(bonus1), .effort(effort), .hard(hard), .random2(random2));
	stage3 g3(.pass3(pass3), .luck3(luck3), .slide(slide), .timing(timing), .bonus2(bonus2), .pass2(pass2));
endmodule
module stage1(speed, random1,breakfast, movement,weather,bonus1,pass1);
input [6:0]	speed, random1;
input [1:0] breakfast, movement;
input 		weather;
output reg[1:0]bonus1;
output  	pass1;
wire [6:0] speed_UpperBound, speed_LowerBound;
wire late, car_accident,no_parking, over_speed, turtle_speed;
assign speed_LowerBound = (weather)? 7'd30 : 7'd20;	//set speed upper bound by weather
assign speed_UpperBound = (weather)? 7'd70 : 7'd50; //set speed lower bound by weather
assign over_speed = (speed > speed_UpperBound)? 1'd1: 1'd0;
assign turtle_speed = (speed < speed_LowerBound)? 1'd1: 1'd0;
assign late = (turtle_speed)? (random1[2] ^ random1[3]) : 1'd0; //set too-slow punishment
assign car_accident = (over_speed)? (random1[0] | random1[1]) : 1'd0; //set too-fast punishment
assign no_parking = random1[4] & random1[2] & random1[0]; //finding no parking space
assign pass1 = ~(car_accident | no_parking | late); //RT
always@(*)	//monkey steal your breakfast, breakfast can get a bonus point
	case(breakfast)
		2'b01: bonus1 <= (over_speed)? {1'b0,movement[0]|movement[1]}: {1'b0, movement[0] ^ movement[1] };
		2'b10: bonus1 <= (over_speed)? {|movement, 1'b0}: (turtle_speed)? {movement[1]&random1[2],1'b0} : {movement[1]^movement[0]^random1[0], 1'b0}; 
		2'b11: bonus1 <= (movement=={random1[3], random1[5]})? 2'b11: 2'b00;
		default: bonus1 <= 2'b00;
	endcase
endmodule
module stage2(pass2, bonus2, pass1, bonus1, effort, hard, random2);
	input pass1;
	input [1:0] bonus1;
	input [6:0] effort;
	input [4:0] hard, random2;
	output pass2;
	output [1:0] bonus2;
	reg [2:0] additional_point;
	wire very_hard = hard[4] & 1'b1; //hard>=16
	wire notso_hard = ~(hard[4] | hard[3] | hard[2]); //hard<3
	wire medium_hard = ~(very_hard | notso_hard);
	wire [1:0] hard_rate = {very_hard, medium_hard};
	always@(*)
		case(hard_rate)
			2'b10: additional_point <= (random2[0] | random2[1])? 3'd7 : 3'd0;
			2'b01: additional_point <= {random2[3], 1'b0, random2[4]};
			default: additional_point<= 3'd0;
		endcase
	wire [6:0] score = effort - {2'b00, hard} + {4'b0000, additional_point};
	wire pass_test = (score >= 7'd70)? 1'b1: 1'b0;
	wire pass_liver = (effort - {3'b000, bonus1, 2'b00} > 7'd80)? (random2[0] | random2[4]) :1'b1;
	assign pass2 = pass_test & pass_liver & pass1;
	assign bonus2 = (score > 7'd94)? 2'b11 :(score > 7'd87)? 2'b10 :(score > 7'd80)? 2'b01 : 2'b00;
endmodule
module stage3(pass3, luck3, slide, timing, bonus2, pass2);
   	output          pass3;
	input   [2:0]   slide, timing, luck3;
   	input   [1:0]   bonus2;
    	input           pass2;
    	wire            accident0, accident1, accident2, accident3, fail0, fail1;
	wire	[2:0]	bad;
	reg				bonus3;
	assign 	fail0 = (slide == 3'd0)? 1'b1 : 1'b0;
	assign	fail1 = (timing == 3'd0)? 1'b1 : 1'b0;
	assign	accident0 = (~((slide < 3'd3)||(slide == 3'd3)))? 1'b0: (~(slide^(luck3[2:0]) == 3'b000))? 1'b0 : (bonus2==2'd3)? 1'b0 : 1'b1;
	assign	accident1 = (slide > 3'd4)? ((slide^(luck3[2:0]) == 3'b001)? 1'b1 : 1'b0): 1'b0;
	assign 	accident2 = (~((timing < 3'd3)||(timing == 3'd3)))? 1'b0: (~(timing^(luck3[2:0]) == 3'b010))? 1'b0: (bonus2>=2'd1)? 1'b0 : 1'b1;
	assign	accident3 = (~((timing > 3'd4)||(timing == 3'd4)))? 1'b0: (~(timing^(luck3[2:0]) == 3'b100))? 1'b0: (bonus2>=2'd2)? 1'b0 : 1'b1;
	always@(*)begin
		if((slide>3'd4)&&(accident1==1'b0))
			bonus3 = 1'b1;
		else
			bonus3 = 1'b0;
	end
	assign bad = accident0*2 + accident1 + accident2*2 + accident3;
    assign pass3 = ((~pass2) | fail0 | fail1)? 1'b0 : ((bad <= 3'd1)? 1'b1 :((bonus3)?1'b1 : 1'b0));
endmodule
