module DFF16_chain15(clk, rst, data_valid, din, 
					dout00, dout01, dout02, dout03, dout04, dout05, dout06, dout07,
					dout08,	dout09, dout10, dout11, dout12, dout13, dout14, dout15);
					
input clk, rst, data_valid;

input [15:0] din;

output [15:0]	dout00, dout01, dout02, dout03, dout04, dout05, dout06, dout07,
				dout08, dout09, dout10, dout11, dout12, dout13, dout14, dout15;
				
reg  [15:0]	dout00, dout01, dout02, dout03, dout04, dout05, dout06, dout07,
				dout08, dout09, dout10, dout11, dout12, dout13, dout14, dout15;
				
wire [15:0]	din00, din01, din02, din03, din04, din05, din06, din07,
				din08, din09, din10, din11, din12, din13, din14, din15;
			
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


endmodule