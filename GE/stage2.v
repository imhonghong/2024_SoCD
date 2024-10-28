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
