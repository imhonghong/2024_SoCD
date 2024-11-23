module DFF16_chain31(clk, rst, data_valid, din, 
					dout00, dout01, dout02, dout03, dout04, dout05, dout06, dout07,
					dout08,	dout09, dout10, dout11, dout12, dout13, dout14, dout15,
					dout16, dout17, dout18, dout19, dout20, dout21, dout22, dout23,
					dout24, dout25, dout26, dout27, dout28, dout29, dout30, dout31);
input clk, rst, data_valid;
input [15:0] din;
output [15:0]	dout00, dout01, dout02, dout03, dout04, dout05, dout06, dout07,
				dout08, dout09, dout10, dout11, dout12, dout13, dout14, dout15,
				dout16, dout17, dout18, dout19, dout20, dout21, dout22, dout23,
				dout24, dout25, dout26, dout27, dout28, dout29, dout30, dout31;
reg signed [15:0]	dout00, dout01, dout02, dout03, dout04, dout05, dout06, dout07,
				dout08, dout09, dout10, dout11, dout12, dout13, dout14, dout15,
				dout16, dout17, dout18, dout19, dout20, dout21, dout22, dout23,
				dout24, dout25, dout26, dout27, dout28, dout29, dout30, dout31;
				
wire signed [15:0]	din00, din01, din02, din03, din04, din05, din06, din07,
				din08, din09, din10, din11, din12, din13, din14, din15,
				din16, din17, din18, din19, din20, din21, din22, din23,
				din24, din25, din26, din27, din28, din29, din30, din31;
			
// seq part
always@(posedge clk or posedge rst) begin
	if (rst) begin
		dout00 <= 16'h0;
		dout01 <= 16'h0;
		dout02 <= 16'h0;
		dout03 <= 16'h0;
		dout04 <= 16'h0;
		dout05 <= 16'h0;
		dout06 <= 16'h0;
		dout07 <= 16'h0;
		dout08 <= 16'h0;
		dout09 <= 16'h0;
		dout10 <= 16'h0;
		dout11 <= 16'h0;
		dout12 <= 16'h0;
		dout13 <= 16'h0;
		dout14 <= 16'h0;
		dout15 <= 16'h0;
		dout16 <= 16'h0;
		dout17 <= 16'h0;
		dout18 <= 16'h0;
		dout19 <= 16'h0;
		dout20 <= 16'h0;
		dout21 <= 16'h0;
		dout22 <= 16'h0;
		dout23 <= 16'h0;
		dout24 <= 16'h0;
		dout25 <= 16'h0;
		dout26 <= 16'h0;
		dout27 <= 16'h0;
		dout28 <= 16'h0;
		dout29 <= 16'h0;
		dout30 <= 16'h0;
		dout31 <= 16'h0;
		end
	else begin
		dout00 <= din00;
		dout01 <= din01;
		dout02 <= din02;
		dout03 <= din03;
		dout04 <= din04;
		dout05 <= din05;
		dout06 <= din06;
		dout07 <= din07;
		dout08 <= din08;
		dout09 <= din09;
		dout10 <= din10;
		dout11 <= din11;
		dout12 <= din12;
		dout13 <= din13;
		dout14 <= din14;
		dout15 <= din15;
		dout16 <= din16;
		dout17 <= din17;
		dout18 <= din18;
		dout19 <= din19;
		dout20 <= din20;
		dout21 <= din21;
		dout22 <= din22;
		dout23 <= din23;
		dout24 <= din24;
		dout25 <= din25;
		dout26 <= din26;
		dout27 <= din27;
		dout28 <= din28;
		dout29 <= din29;
		dout30 <= din30;
		dout31 <= din31;
		end

end
// comb part
assign din00 = (data_valid)? din : dout00;
assign din01 = (data_valid)? dout00 : dout01;
assign din02 = (data_valid)? dout01 : dout02;
assign din03 = (data_valid)? dout02 : dout03;
assign din04 = (data_valid)? dout03 : dout04;
assign din05 = (data_valid)? dout04 : dout05;
assign din06 = (data_valid)? dout05 : dout06;
assign din07 = (data_valid)? dout06 : dout07;
assign din08 = (data_valid)? dout07 : dout08;
assign din09 = (data_valid)? dout08 : dout09;

assign din10 = (data_valid)? dout09 : dout10;
assign din11 = (data_valid)? dout10 : dout11;
assign din12 = (data_valid)? dout11 : dout12;
assign din13 = (data_valid)? dout12 : dout13;
assign din14 = (data_valid)? dout13 : dout14;
assign din15 = (data_valid)? dout14 : dout15;
assign din16 = (data_valid)? dout15 : dout16;
assign din17 = (data_valid)? dout16 : dout17;
assign din18 = (data_valid)? dout17 : dout18;
assign din19 = (data_valid)? dout18 : dout19;

assign din20 = (data_valid)? dout19 : dout20;
assign din21 = (data_valid)? dout20 : dout21;
assign din22 = (data_valid)? dout21 : dout22;
assign din23 = (data_valid)? dout22 : dout23;
assign din24 = (data_valid)? dout23 : dout24;
assign din25 = (data_valid)? dout24 : dout25;
assign din26 = (data_valid)? dout25 : dout26;
assign din27 = (data_valid)? dout26 : dout27;
assign din28 = (data_valid)? dout27 : dout28;
assign din29 = (data_valid)? dout28 : dout29;

assign din30 = (data_valid)? dout29 : dout30;
assign din31 = (data_valid)? dout30 : dout31;

endmodule