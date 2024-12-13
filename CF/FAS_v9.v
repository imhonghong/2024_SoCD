module  FAS (data_valid, data, clk, rst, fir_d, fir_valid, fft_valid, done, freq,
	fft_d1, fft_d2, fft_d3, fft_d4, fft_d5, fft_d6, fft_d7, fft_d8,
	fft_d9, fft_d10, fft_d11, fft_d12, fft_d13, fft_d14, fft_d15, fft_d0);
	input clk, rst;
	input data_valid;
	input [15:0] data; 
	output fir_valid, fft_valid;
	output [15:0] fir_d;
	output [31:0] fft_d1, fft_d2, fft_d3, fft_d4, fft_d5, fft_d6, fft_d7, fft_d8;
	output [31:0] fft_d9, fft_d10, fft_d11, fft_d12, fft_d13, fft_d14, fft_d15, fft_d0;
	output done;
	output [3:0] freq;
	
	FIR_FILTER fas_fir(
		.clk(clk), 
		.rst(rst),
		.data_valid(data_valid),
		.data(data),
		.fir_valid(fir_valid),
		.fir_d(fir_d)
	  );	
	
	FFT  fas_fft
	(.clk(clk),
	 .rst(rst),
	 .fir_valid(fir_valid),
	 .fir_d(fir_d),
	 .dout_valid(fft_valid),
	 .fft_d0(fft_d0),
	 .fft_d1(fft_d1),
	 .fft_d2(fft_d2),
	 .fft_d3(fft_d3),
	 .fft_d4(fft_d4),
	 .fft_d5(fft_d5),
	 .fft_d6(fft_d6),
	 .fft_d7(fft_d7),
	 .fft_d8(fft_d8),
	 .fft_d9(fft_d9),
	 .fft_d10(fft_d10),
	 .fft_d11(fft_d11),
	 .fft_d12(fft_d12),
	 .fft_d13(fft_d13),
	 .fft_d14(fft_d14),
	 .fft_d15(fft_d15));

	ANALYSIS fas_analysis
	(.fft_d0(fft_d0),
    .fft_d1(fft_d1),
    .fft_d2(fft_d2),
    .fft_d3(fft_d3),
    .fft_d4(fft_d4),
    .fft_d5(fft_d5),
    .fft_d6(fft_d6),
    .fft_d7(fft_d7),
    .fft_d8(fft_d8),
    .fft_d9(fft_d9),
    .fft_d10(fft_d10),
    .fft_d11(fft_d11),
    .fft_d12(fft_d12),
    .fft_d13(fft_d13),
    .fft_d14(fft_d14),
    .fft_d15(fft_d15),
    .fft_valid(fft_valid),
    .clk(clk),
    .rst(rst),
    .done(done),
    .freq(freq));	


endmodule


module FIR_FILTER(clk, rst, data_valid, data, fir_d, fir_valid);
 input clk;
 input rst;
 input data_valid;
 input [15:0] data;
 output [15:0] fir_d;
 output fir_valid;
//`include "./dat/FIR_coefficient.dat"
	parameter signed [15:0] FIR_C00 = 16'hFF9E ;    //The FIR_coefficient value 0: -1.495361e-003
	parameter signed [15:0] FIR_C01 = 16'hFF86 ;    //The FIR_coefficient value 1: -1.861572e-003
	parameter signed [15:0] FIR_C02 = 16'hFFA7 ;    //The FIR_coefficient value 2: -1.358032e-003
	parameter signed [15:0] FIR_C03 = 16'h003B ;    //The FIR_coefficient value 3: 9.002686e-004
	parameter signed [15:0] FIR_C04 = 16'h014B ;    //The FIR_coefficient value 4: 5.050659e-003
	parameter signed [15:0] FIR_C05 = 16'h024A ;    //The FIR_coefficient value 5: 8.941650e-003
	parameter signed [15:0] FIR_C06 = 16'h0222 ;    //The FIR_coefficient value 6: 8.331299e-003
	parameter signed [15:0] FIR_C07 = 16'hFFE4 ;    //The FIR_coefficient value 7: -4.272461e-004
	parameter signed [15:0] FIR_C08 = 16'hFBC5 ;    //The FIR_coefficient value 8: -1.652527e-002
	parameter signed [15:0] FIR_C09 = 16'hF7CA ;    //The FIR_coefficient value 9: -3.207397e-002
	parameter signed [15:0] FIR_C10 = 16'hF74E ;    //The FIR_coefficient value 10: -3.396606e-002
	parameter signed [15:0] FIR_C11 = 16'hFD74 ;    //The FIR_coefficient value 11: -9.948730e-003
	parameter signed [15:0] FIR_C12 = 16'h0B1A ;    //The FIR_coefficient value 12: 4.336548e-002
	parameter signed [15:0] FIR_C13 = 16'h1DAC ;    //The FIR_coefficient value 13: 1.159058e-001
	parameter signed [15:0] FIR_C14 = 16'h2F9E ;    //The FIR_coefficient value 14: 1.860046e-001
	parameter signed [15:0] FIR_C15 = 16'h3AA9 ;    //The FIR_coefficient value 15: 2.291412e-001
	
	//counter
	reg  [5:0] cnt, ncnt;
	always @(posedge clk or posedge rst) begin
		if (rst) begin
            cnt <= 6'd0 ;
			end
        else begin
			cnt <= ncnt ;
			end
	end
	always@(*)begin
		if(data_valid & cnt<6'b100001) begin
			ncnt <= cnt + 6'd1;
			end
		else
			ncnt <= cnt;
	end
	
	integer i;
	//shift register
	reg signed [15:0] shift_reg [31:0];
	reg signed [15:0] shift_reg_n [31:0];
    /*
	always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i=0; i<32; i=i+1) begin
                shift_reg[i] <= 16'd0;
            end
        end 
		else begin
            for (i = 0; i < 31; i = i + 1) begin
                shift_reg[i] <= shift_reg_n[i];
            end
		end	
    end
	*/
	always@(*) begin
		if (data_valid) begin
			shift_reg_n[0] <= data;
			for (i = 0; i < 31; i = i + 1) begin
				shift_reg_n[i+1] <= shift_reg[i];
				end
			end
		else begin
			for (i = 0; i < 31; i = i + 1) begin
				shift_reg_n[i] <= shift_reg[i];
				end
			end
	end
	always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i=0; i<32; i=i+1) begin
                shift_reg[i] <= 16'd0;
				end
			end 
		else if (data_valid) begin
			shift_reg[0] <= data;
            for (i = 0; i < 31; i = i + 1) begin
                shift_reg[i+1] <= shift_reg[i];
				end
			end
    end
	//sum
	wire signed [31:0] prod[15:0];
	assign prod[0] = (shift_reg[0] + shift_reg[31]) * FIR_C00;
	assign prod[1] = (shift_reg[1] + shift_reg[30]) * FIR_C01;
	assign prod[2] = (shift_reg[2] + shift_reg[29]) * FIR_C02;
	assign prod[3] = (shift_reg[3] + shift_reg[28]) * FIR_C03;
	assign prod[4] = (shift_reg[4] + shift_reg[27]) * FIR_C04;
	assign prod[5] = (shift_reg[5] + shift_reg[26]) * FIR_C05;
	assign prod[6] = (shift_reg[6] + shift_reg[25]) * FIR_C06;
	assign prod[7] = (shift_reg[7] + shift_reg[24]) * FIR_C07;
	assign prod[8] = (shift_reg[8] + shift_reg[23]) * FIR_C08;
	assign prod[9] = (shift_reg[9] + shift_reg[22]) * FIR_C09;
	assign prod[10] = (shift_reg[10] + shift_reg[21]) * FIR_C10;
	assign prod[11] = (shift_reg[11] + shift_reg[20]) * FIR_C11;
	assign prod[12] = (shift_reg[12] + shift_reg[19]) * FIR_C12;
	assign prod[13] = (shift_reg[13] + shift_reg[18]) * FIR_C13;
	assign prod[14] = (shift_reg[14] + shift_reg[17]) * FIR_C14;
	assign prod[15] = (shift_reg[15] + shift_reg[16]) * FIR_C15;
    wire signed [31:0] sum_level1[7:0];
	assign sum_level1[0] = prod[0] + prod[1];
    assign sum_level1[1] = prod[2] + prod[3];
    assign sum_level1[2] = prod[4] + prod[5];
    assign sum_level1[3] = prod[6] + prod[7];
    assign sum_level1[4] = prod[8] + prod[9];
    assign sum_level1[5] = prod[10] + prod[11];
    assign sum_level1[6]= prod[12] + prod[13];
    assign sum_level1[7] = prod[14] + prod[15];
	wire signed [31:0] sum_level2[3:0];
    assign sum_level2[0] = sum_level1[0] + sum_level1[1];
    assign sum_level2[1] = sum_level1[2] + sum_level1[3];
    assign sum_level2[2] = sum_level1[4] + sum_level1[5];
    assign sum_level2[3] = sum_level1[6] + sum_level1[7];
	wire signed [31:0] sum_level3[1:0];
    assign sum_level3[0] = sum_level2[0] + sum_level2[1];
    assign sum_level3[1] = sum_level2[2] + sum_level2[3];
    wire signed [31:0] SUM = sum_level3[0] + sum_level3[1];
	
	//output
	wire fir_valid = data_valid & cnt[5] & cnt[0];
	wire [15:0] fir_d =(SUM[31])? SUM[31:16]+16'd1:SUM[31:16];	

endmodule

module FFT
(clk,
rst,
fir_valid,
fir_d,
dout_valid,
fft_d0,
fft_d1,
fft_d2,
fft_d3,
fft_d4,
fft_d5,
fft_d6,
fft_d7,
fft_d8,
fft_d9,
fft_d10,
fft_d11,
fft_d12,
fft_d13,
fft_d14,
fft_d15);
	parameter WIDTH = 16;
	parameter WIDTH_but = 24;
	parameter count_bit = 4;
	
	input clk;
	input rst;
	input fir_valid;
	input [WIDTH-1:0] fir_d;
	output reg dout_valid;
	output reg [WIDTH*2-1:0]fft_d0;
	output reg [WIDTH*2-1:0]fft_d1;
	output reg [WIDTH*2-1:0]fft_d2;
	output reg [WIDTH*2-1:0]fft_d3;
	output reg [WIDTH*2-1:0]fft_d4;
	output reg [WIDTH*2-1:0]fft_d5;
	output reg [WIDTH*2-1:0]fft_d6;
	output reg [WIDTH*2-1:0]fft_d7;
	output reg [WIDTH*2-1:0]fft_d8;
	output reg [WIDTH*2-1:0]fft_d9;
	output reg [WIDTH*2-1:0]fft_d10;
	output reg [WIDTH*2-1:0]fft_d11;
	output reg [WIDTH*2-1:0]fft_d12;
	output reg [WIDTH*2-1:0]fft_d13;
	output reg [WIDTH*2-1:0]fft_d14;
	output reg [WIDTH*2-1:0]fft_d15;

	wire signed [WIDTH_but-1:0] dinar_s1,dinai_s1;  //input of but
	wire signed [WIDTH_but-1:0] dinbr_s1,dinbi_s1;
	wire signed [WIDTH_but-1:0] dinar_s2,dinai_s2;
	wire signed [WIDTH_but-1:0] dinbr_s2,dinbi_s2;
		  
	wire signed [WIDTH_but-1:0] doutar_s1,doutai_s1; //output of but
	wire signed [WIDTH_but-1:0] doutbr_s1,doutbi_s1;
	wire signed [WIDTH_but-1:0] doutar_s2,doutai_s2;
	wire signed [WIDTH_but-1:0] doutbr_s2,doutbi_s2;
	
	
	wire  [count_bit-1:0] state; //the state of the counter
	
	counter u1(
	.clk(clk), // clock signal
	.rst(rst), // reset signal
	.valid(fir_valid), // start counting when valid is high
	.counter(state) // output  of the counter
	);

	reg [5:0] counter; 
	reg valid_out;
	parameter DELAY_CYCLES = 47;
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			counter   <= 6'd0;      //  counter
			valid_out <= 1'b0;      //  valid_out
			dout_valid <= 1'b0;     //  dout_valid
		end 
		else begin
			if ((counter < DELAY_CYCLES) && (fir_valid && !valid_out)) 
				counter <= counter + 1;			
			else if (counter >= DELAY_CYCLES) // 
				valid_out <= 1'b1;

			dout_valid <= valid_out & (&state); //  dout_valid
		end
	end
	
	wire [WIDTH-1:0] dinar_16,dinbr_16;
	
	buffer_in  a1(       //the mem between fir and fft
	.clk(clk), 
	.rst(rst), 
	.din(fir_d),         
	.dout1(dinar_16), 
	.dout2(dinbr_16) );
	
	
	wire signed[WIDTH_but-1:0] doutar_8first;
	wire signed[WIDTH_but-1:0] doutai_8first;
	wire signed[WIDTH_but-1:0] doutbr_8first;
	wire signed[WIDTH_but-1:0] doutbi_8first;

	buffer_8  first(
    .clk(clk), // clock signal
    .rst(rst), // reset signal
    .wr_en(~state[count_bit-1]), // write enable signal
    .write_addr(state[count_bit-2:0]), // 3-bit write address
    .dinr(doutar_s1), // 24-bit input data 1
    .dini(doutai_s1), // 24-bit input data 2
    .add_ar({1'b0,state[count_bit-3:0]}), // 3-bit read address 2n+0
    .add_ai({1'b0,state[count_bit-3:0]}), // 3-bit read address 2n+0
    .add_br({1'b1,state[count_bit-3:0]}), // 3-bit read address 2n+1
    .add_bi({1'b1,state[count_bit-3:0]}), // 3-bit read address 2n+1
    .doutar(doutar_8first), // 24-bit output data 1
    .doutai(doutai_8first), // 24-bit output data 2
    .doutbr(doutbr_8first), // 24-bit output data 3
    .doutbi(doutbi_8first) // 24-bit output data 4
	);
	
	wire signed[WIDTH_but-1:0] doutar_8second;
	wire signed[WIDTH_but-1:0] doutai_8second;
	wire signed[WIDTH_but-1:0] doutbr_8second;
	wire signed[WIDTH_but-1:0] doutbi_8second;
	
	buffer_8  second(
    .clk(clk), // clock signal
    .rst(rst), // reset signal
    .wr_en(~state[count_bit-1]), // write enable signal
    .write_addr(state[count_bit-2:0]), // 3-bit write address
    .dinr(doutbr_s1), // 24-bit input data 1
    .dini(doutbi_s1), // 24-bit input data 2
    .add_ar({1'b0,state[count_bit-3:0]}), // 3-bit read address n
    .add_ai({1'b0,state[count_bit-3:0]}), // 3-bit read address n
    .add_br({1'b1,state[count_bit-3:0]}), // 3-bit read address 2n
    .add_bi({1'b1,state[count_bit-3:0]}), // 3-bit read address 2n
    .doutar(doutar_8second), // 24-bit output data 1
    .doutai(doutai_8second), // 24-bit output data 2
    .doutbr(doutbr_8second), // 24-bit output data 3
    .doutbi(doutbi_8second) // 24-bit output data 4
	);

	assign dinar_s1 =(state[3])?(state[2])? doutar_8second:doutar_8first
							   :{dinar_16,8'd0};
	assign dinai_s1 =(state[3])?(state[2])? doutai_8second:doutai_8first
							   :{24'd0};
	assign dinbr_s1 =(state[3])?(state[2])? doutbr_8second:doutbr_8first
							   :{dinbr_16,8'd0};
	assign dinbi_s1 =(state[3])?(state[2])? doutbi_8second:doutbi_8first
							   :{24'd0};


    reg [2:0] ctr1; 

	always @(*)
		if(~state[3])
			ctr1<=state[2:0];
		else
			case (state[1:0])
				2'd0: ctr1<=3'd0;
				2'd1: ctr1<=3'd2;
				2'd2: ctr1<=3'd4;
				default: ctr1<=3'd6;
			endcase
	
	fft_but stage1(
	.din_ar(dinar_s1),
	.din_ai(dinai_s1),
	.din_br(dinbr_s1),
	.din_bi(dinbi_s1),
	.ctr1(ctr1),
	.dout_ar(doutar_s1),
	.dout_ai(doutai_s1),
	.dout_br(doutbr_s1),
	.dout_bi(doutbi_s1));
	
	
	wire signed[WIDTH_but-1:0] doutar_8third;
	wire signed[WIDTH_but-1:0] doutai_8third;
	wire signed[WIDTH_but-1:0] doutbr_8third;
	wire signed[WIDTH_but-1:0] doutbi_8third;
	
	buffer_8  third(
    .clk(clk), // clock signal
    .rst(rst), // reset signal
    .wr_en(state[count_bit-1]), // write enable signal
    .write_addr(state[count_bit-2:0]), // 3-bit write address
    .dinr(doutar_s1), // 24-bit input data 1
    .dini(doutai_s1), // 24-bit input data 2
    .add_ar({state[count_bit-3],1'b0,state[0]}), // 3-bit read address 2n+0
    .add_ai({state[count_bit-3],1'b0,state[0]}), // 3-bit read address 2n+0
    .add_br({state[count_bit-3],1'b1,state[0]}), // 3-bit read address 2n+1
    .add_bi({state[count_bit-3],1'b1,state[0]}), // 3-bit read address 2n+1
    .doutar(doutar_8third), // 24-bit output data 1
    .doutai(doutai_8third), // 24-bit output data 2
    .doutbr(doutbr_8third), // 24-bit output data 3
    .doutbi(doutbi_8third) // 24-bit output data 4
	);	
	
	
	wire signed[WIDTH_but-1:0] doutar_8fourth;
	wire signed[WIDTH_but-1:0] doutai_8fourth;
	wire signed[WIDTH_but-1:0] doutbr_8fourth;
	wire signed[WIDTH_but-1:0] doutbi_8fourth;	

	buffer_8  fourth(
    .clk(clk), // clock signal
    .rst(rst), // reset signal
    .wr_en(state[count_bit-1]), // write enable signal
    .write_addr(state[count_bit-2:0]), // 3-bit write address
    .dinr(doutbr_s1), // 24-bit input data 1
    .dini(doutbi_s1), // 24-bit input data 2
    .add_ar({state[count_bit-3],1'b0,state[0]}), //3-bit read address 0,1,4,5 
    .add_ai({state[count_bit-3],1'b0,state[0]}), //3-bit read address 0,1,4,5 
    .add_br({state[count_bit-3],1'b1,state[0]}), //3-bit read address 2,3,6,7 
    .add_bi({state[count_bit-3],1'b1,state[0]}), //3-bit read address 2,3,6,7 
    .doutar(doutar_8fourth), // 24-bit output data 1
    .doutai(doutai_8fourth), // 24-bit output data 2
    .doutbr(doutbr_8fourth), // 24-bit output data 3
    .doutbi(doutbi_8fourth) // 24-bit output data 4
	);		
	
	

	wire signed[WIDTH_but-1:0] doutar_8fifth;
	wire signed[WIDTH_but-1:0] doutai_8fifth;
	wire signed[WIDTH_but-1:0] doutbr_8fifth;
	wire signed[WIDTH_but-1:0] doutbi_8fifth;		
	
	buffer_8  fifth(
    .clk(clk), // clock signal
    .rst(rst), // reset signal
    .wr_en(~state[count_bit-1]), // write enable signal
    .write_addr({state[count_bit-3],state[count_bit-2],state[0]}), // 3-bit write address
    .dinr(doutar_s2), // 24-bit input data 1
    .dini(doutai_s2), // 24-bit input data 2
    .add_ar({state[count_bit-3:0],1'b0}), // 3-bit read address 2n+0
    .add_ai({state[count_bit-3:0],1'b0}), // 3-bit read address 2n+0
    .add_br({state[count_bit-3:0],1'b1}), // 3-bit read address 2n+1
    .add_bi({state[count_bit-3:0],1'b1}), // 3-bit read address 2n+1
    .doutar(doutar_8fifth), // 24-bit output data 1
    .doutai(doutai_8fifth), // 24-bit output data 2
    .doutbr(doutbr_8fifth), // 24-bit output data 3
    .doutbi(doutbi_8fifth) // 24-bit output data 4
	);	
	
	
	wire signed[WIDTH_but-1:0] doutar_8sixth;
	wire signed[WIDTH_but-1:0] doutai_8sixth;
	wire signed[WIDTH_but-1:0] doutbr_8sixth;
	wire signed[WIDTH_but-1:0] doutbi_8sixth;	

	buffer_8  sixth(
    .clk(clk), // clock signal
    .rst(rst), // reset signal
    .wr_en(~state[count_bit-1]), // write enable signal
    .write_addr({state[count_bit-3],state[count_bit-2],state[0]}), // 3-bit write address
    .dinr(doutbr_s2), // 24-bit input data 1
    .dini(doutbi_s2), // 24-bit input data 2
    .add_ar({state[count_bit-3:0],1'b0}), // 3-bit read address 2n+0
    .add_ai({state[count_bit-3:0],1'b0}), // 3-bit read address 2n+0
    .add_br({state[count_bit-3:0],1'b1}), // 3-bit read address 2n+1
    .add_bi({state[count_bit-3:0],1'b1}), // 3-bit read address 2n+1
    .doutar(doutar_8sixth), // 24-bit output data 1
    .doutai(doutai_8sixth), // 24-bit output data 2
    .doutbr(doutbr_8sixth), // 24-bit output data 3
    .doutbi(doutbi_8sixth) // 24-bit output data 4
	);	

	assign dinar_s2 =(state[3])?(state[2])? doutar_8sixth:doutar_8fifth
							   :(state[2])? doutar_8fourth:doutar_8third;
	assign dinai_s2 =(state[3])?(state[2])? doutai_8sixth:doutai_8fifth
							   :(state[2])? doutai_8fourth:doutai_8third;
	assign dinbr_s2 =(state[3])?(state[2])? doutbr_8sixth:doutbr_8fifth
							   :(state[2])? doutbr_8fourth:doutbr_8third;
	assign dinbi_s2 =(state[3])?(state[2])? doutbi_8sixth:doutbi_8fifth
							   :(state[2])? doutbi_8fourth:doutbi_8third;	

	wire ctr;
	
	assign ctr = (~state[3])&(state[0]); // state=1,3,5,7 use W4

	fft_but_ctr2 stage2(
	.din_ar(dinar_s2),
	.din_ai(dinai_s2),
	.din_br(dinbr_s2),
	.din_bi(dinbi_s2),
	.ctr(ctr),
	.dout_ar(doutar_s2),
	.dout_ai(doutai_s2),
	.dout_br(doutbr_s2),
	.dout_bi(doutbi_s2));
	
	
    always @(posedge clk or posedge rst)   //assign to the output
		begin
			if (rst) 
				begin
				    fft_d0  <= 32'd0;
					fft_d1  <= 32'd0;
					fft_d2  <= 32'd0;
					fft_d3  <= 32'd0;
					fft_d4  <= 32'd0;
					fft_d5  <= 32'd0;
					fft_d6  <= 32'd0;
					fft_d7  <= 32'd0;
					fft_d8  <= 32'd0;
					fft_d9  <= 32'd0;
					fft_d10 <= 32'd0;
					fft_d11 <= 32'd0;
					fft_d12 <= 32'd0;
					fft_d13 <= 32'd0;
					fft_d14 <= 32'd0;
					fft_d15 <= 32'd0;																			  
				end 
			else if (state[count_bit-1])
				begin
					case (state[count_bit-2:0])
					3'b000:begin fft_d0  <= {doutar_s2[WIDTH_but-1:WIDTH_but-16] , doutai_s2[WIDTH_but-1:WIDTH_but-16]}; //case 0					
								 fft_d8  <= {doutbr_s2[WIDTH_but-1:WIDTH_but-16] , doutbi_s2[WIDTH_but-1:WIDTH_but-16]};	
							end 
					3'b001:begin fft_d2  <= {doutar_s2[WIDTH_but-1:WIDTH_but-16] , doutai_s2[WIDTH_but-1:WIDTH_but-16]}; // Case 1
								 fft_d10 <= {doutbr_s2[WIDTH_but-1:WIDTH_but-16] , doutbi_s2[WIDTH_but-1:WIDTH_but-16]};
							end  
					3'b010:begin fft_d1  <= {doutar_s2[WIDTH_but-1:WIDTH_but-16] , doutai_s2[WIDTH_but-1:WIDTH_but-16]}; // Case 2
								 fft_d9  <= {doutbr_s2[WIDTH_but-1:WIDTH_but-16] , doutbi_s2[WIDTH_but-1:WIDTH_but-16]};
							end  
					3'b011:begin fft_d3  <= {doutar_s2[WIDTH_but-1:WIDTH_but-16] , doutai_s2[WIDTH_but-1:WIDTH_but-16]}; // Case 3
								 fft_d11 <= {doutbr_s2[WIDTH_but-1:WIDTH_but-16] , doutbi_s2[WIDTH_but-1:WIDTH_but-16]};
							end  
					3'b100:begin fft_d4  <= {doutar_s2[WIDTH_but-1:WIDTH_but-16] , doutai_s2[WIDTH_but-1:WIDTH_but-16]}; // Case 4
								 fft_d12 <= {doutbr_s2[WIDTH_but-1:WIDTH_but-16] , doutbi_s2[WIDTH_but-1:WIDTH_but-16]};
							end  
					3'b101:begin fft_d6  <= {doutar_s2[WIDTH_but-1:WIDTH_but-16] , doutai_s2[WIDTH_but-1:WIDTH_but-16]}; // Case 5
								 fft_d14 <= {doutbr_s2[WIDTH_but-1:WIDTH_but-16] , doutbi_s2[WIDTH_but-1:WIDTH_but-16]};
							end  
					3'b110:begin fft_d5  <= {doutar_s2[WIDTH_but-1:WIDTH_but-16] , doutai_s2[WIDTH_but-1:WIDTH_but-16]}; // Case 6
								 fft_d13 <= {doutbr_s2[WIDTH_but-1:WIDTH_but-16] , doutbi_s2[WIDTH_but-1:WIDTH_but-16]};
							end  
					3'b111:begin fft_d7  <= {doutar_s2[WIDTH_but-1:WIDTH_but-16] , doutai_s2[WIDTH_but-1:WIDTH_but-16]}; // Case 7
								 fft_d15 <= {doutbr_s2[WIDTH_but-1:WIDTH_but-16] , doutbi_s2[WIDTH_but-1:WIDTH_but-16]};
							end 
					default: ;       
					endcase
				end
			else
			;
		end

endmodule

module ANALYSIS (fft_d0,
                 fft_d1,
                 fft_d2,
                 fft_d3,
                 fft_d4,
                 fft_d5,
                 fft_d6,
                 fft_d7,
                 fft_d8,
                 fft_d9,
                 fft_d10,
                 fft_d11,
                 fft_d12,
                 fft_d13,
                 fft_d14,
                 fft_d15,
				fft_valid,
				clk,
				rst,
				done,
				freq);
parameter width = 32;
parameter depth = 16;
input [width-1:0] fft_d0;				
input [width-1:0] fft_d1;
input [width-1:0] fft_d2;
input [width-1:0] fft_d3;
input [width-1:0] fft_d4;
input [width-1:0] fft_d5;
input [width-1:0] fft_d6;
input [width-1:0] fft_d7;
input [width-1:0] fft_d8;
input [width-1:0] fft_d9;
input [width-1:0] fft_d10;
input [width-1:0] fft_d11;
input [width-1:0] fft_d12;
input [width-1:0] fft_d13;
input [width-1:0] fft_d14;
input [width-1:0] fft_d15;
input fft_valid,clk,rst;
output done;
output wire [3:0] freq;
reg [width-1:0] MEM [0:15];
reg [3:0] count,max; 
reg signed [width-1:0] temp;
reg signed [width/2-1:0] upa,lowa; 
wire signed [width-1:0]tempa_up ,tempa_low ;
wire signed [width-1:0] tempa;
reg  valid;
integer i;
always@(posedge clk or posedge rst)
	begin
		 if (rst) 
			begin
				// Reset 
				for (i = 0; i < depth; i = i + 1) 
					begin
						MEM[i] <= {width{1'b0}};
					end
				count <= 4'b0000;
				max  <= 4'b0000;
				valid <=1'b0;
				upa  <=	16'd0;			
				lowa <=	16'd0;					
				temp <= 32'd0;
			end 
		else 
			begin
				if(fft_valid)		
					begin
						MEM[0]<=fft_d0 ;	
						MEM[1]<=fft_d1 ;
						MEM[2]<=fft_d2 ;
						MEM[3]<=fft_d3 ;
						MEM[4]<=fft_d4 ;
						MEM[5]<=fft_d5 ;
						MEM[6]<=fft_d6 ;
						MEM[7]<=fft_d7 ;
						MEM[8]<=fft_d8 ;
						MEM[9]<=fft_d9 ;
						MEM[10]<=fft_d10;
						MEM[11]<=fft_d11;
						MEM[12]<=fft_d12;
						MEM[13]<=fft_d13;
						MEM[14]<=fft_d14;
						MEM[15]<=fft_d15;
						count <= 4'b0000;
						max  <= 4'b0000;
						valid <= 1'b1;
						upa  <= (fft_d0[width-1:width/2]);
						lowa <= (fft_d0[width/2-1:0]);
						temp <=32'd0;
					end
				else if(valid && ~fft_valid)
					begin
						count <= count+1;
						upa  <= (MEM[count+1][width-1:width/2]);
						lowa <= (MEM[count+1][width/2-1:0]);
						max  <= freq;
						temp <= (tempa >temp)? tempa : temp;						
					end
			end	

    end
	assign tempa = tempa_up + tempa_low;	
	assign freq =( tempa > temp)? count : max; //max=max freq now
	assign done = &count;
	assign tempa_up = upa * upa;
	assign tempa_low = lowa * lowa;
endmodule

module fft_but#(parameter IN_W = 24,parameter Factor_W = 24)
(din_ar,din_ai,din_br,din_bi,ctr1,dout_ar,dout_ai,dout_br,dout_bi);
input signed [IN_W-1:0] din_ar,din_ai,din_br,din_bi;
input [2:0] ctr1;
output signed [IN_W-1:0] dout_ar,dout_ai,dout_br,dout_bi;
wire signed [IN_W-1:0] dout_br_1,dout_bi_1;
wire signed [IN_W+1:0] dout_br_2,dout_bi_2;
wire signed [IN_W-1:0] dout_ar,dout_ai,dout_br,dout_bi,a,a_inv,b,c,d;
wire signed [IN_W+Factor_W-1:0] mul_r,mul_i;

assign dout_ar = din_ar + din_br;
assign dout_ai = din_ai + din_bi;
assign a = din_ar - din_br;
assign b = din_ai - din_bi;

// for W1,W4
assign a_inv = -a;// c-a
assign dout_br_1 = (ctr1==3'd4)?{b[23],b[22:0]}:{a[23],a[22:0]};
assign dout_bi_1 = (ctr1==3'd4)?{a_inv[23],a_inv[22:0]}:{b[23],b[22:0]};

// for opr set 26 ,1357
mul_process m0(a,b,ctr1,mul_r,mul_i);
assign dout_br_2 = mul_r[IN_W+Factor_W-7:Factor_W-8];
assign dout_bi_2 = mul_i[IN_W+Factor_W-7:Factor_W-8];

assign dout_br=(~(ctr1[0]|ctr1[1]))?(dout_br_1):(dout_br_2[IN_W-1:0]);
assign dout_bi=(~(ctr1[0]|ctr1[1]))?(dout_bi_1):(dout_bi_2[IN_W-1:0]);

endmodule

module mul_process #(parameter WIDTH = 24) (
    input signed [WIDTH-1:0] a, // signed input a
    input signed [WIDTH-1:0] b, // signed input b
	input [2:0] ctr1,
	output signed [(2*WIDTH)-1:0] mul_r,mul_i   
);
    reg signed [(2*WIDTH)-1:0] product1,product2,product3,product4; // signed output product							
	wire signed [(2*WIDTH)-1:0] p1_n,p2_n,p3_n,p4_n;
	wire signed [(2*WIDTH)-1:0] p1_n2,p4_n2;
	wire mul_mode,ctr_inv,sw_inv;
	    
	parameter signed[23:0] W_I1 = 24'hFF9E09; 	
	parameter signed[23:0] W_I2 = 24'hFF4AFC;          
	parameter signed[23:0] W_R1 = 24'h00EC83;   
	parameter signed[23:0] W_R2 = 24'h00B504;      
				 
	assign mul_mode=(ctr1==3'd2|ctr1==3'd6)?(1):(0);	
	assign sw_inv=(ctr1==3'd3|ctr1==3'd5)?(1):(0);
	assign ctr_inv=(ctr1==3'd3|ctr1==3'd6|ctr1==3'd7)?(1):(0);
		
	always@(*)
		if(mul_mode)
			begin
				product1 <=a*W_R2;//Wr1 
				product2 <=b*W_I2;//Wi1
				product3 <=a*W_I2;//Wi1
				product4 <=b*W_R2;//Wr1
			end
		else
			begin					
				product1 <=a*W_R1;//Wr1 
				product2 <=b*W_I1;//Wi1
				product3 <=a*W_I1;//Wi1
				product4 <=b*W_R1;//Wr1
			end
	
	// switch layer	+ 23 inv layer		
	assign p1_n=(sw_inv)?(product3):(product1);
	assign p2_n=(sw_inv)?(-product4):(product2);
	assign p3_n=(sw_inv)?(-product1):(product3);
	assign p4_n=(sw_inv)?(product2):(product4);
	
	// 14 inv layer
	assign p1_n2=(ctr_inv)?(-p1_n):(p1_n);
	assign p4_n2=(ctr_inv)?(-p4_n):(p4_n);
	
	assign mul_r = p1_n2-p2_n;
	assign mul_i = p3_n+p4_n2;
	
endmodule

module fft_but_ctr2#(parameter IN_W = 24,parameter Factor_W = 24)
(din_ar,din_ai,din_br,din_bi,ctr,dout_ar,dout_ai,dout_br,dout_bi);
input signed [IN_W-1:0] din_ar,din_ai,din_br,din_bi;
input ctr;
output signed [IN_W-1:0] dout_ar,dout_ai,dout_br,dout_bi;
wire signed [IN_W:0] a,b,a_inv;

assign dout_ar = din_ar + din_br;
assign dout_ai = din_ai + din_bi;
assign a = din_ar - din_br;// a-c
assign a_inv = -a;// c-a
assign b = din_ai - din_bi;// b-d

assign dout_br = (ctr)?{b[23],b[22:0]}:{a[23],a[22:0]};
assign dout_bi = (ctr)?{a_inv[23],a_inv[22:0]}:{b[23],b[22:0]};

endmodule

module buffer_in
(clk, rst, din, dout1, dout2 );
    parameter WIDTH = 16;
    parameter DEPTH = 16;
	
    input wire clk; // clock signal
    input wire rst; // reset signal
    input wire [WIDTH-1:0] din; // 16-bit input data
	output reg [WIDTH-1:0] dout1, dout2;
    reg [WIDTH-1:0] mem [0:DEPTH-1]; // 16x16 memory output

    integer i,j;

    always @(posedge clk or posedge rst) begin
        if (rst) 
			begin
				// Reset all memory cells to 0
				dout1 <= {WIDTH{1'b0}};
				dout2 <= {WIDTH{1'b0}};
				for (i = 0; i < DEPTH; i = i + 1) 
					begin
						mem[i] <= {WIDTH{1'b0}};
					end
			end 
		else 
			begin
				// Shift all memory cells down and insert new data at the top
				for (j = DEPTH-1; j > 0; j = j - 1) 
					begin
						mem[j] <= mem[j-1];
					end
				mem[0] <= din;
				dout1 <= mem[15];
				dout2 <= mem[7];
			end

    end

endmodule



module counter (clk, rst, valid,counter);

parameter count_bit = 4;
input wire clk; // clock signal
input wire rst; // reset signal
input wire valid; // start counting when valid is high
output reg [count_bit-1:0] counter; // output  of the counter
reg	[count_bit-1:0] n_counter; 
	/*
    always @(posedge clk or posedge rst)
		begin
			if (rst) 
				counter <= 4'b1111; // Reset counter to 0
			else if (valid && counter == 4'b1111) 
				counter <=  4'b0000;
			else 
				counter <= counter + valid; // Count 0-15 and loop
		end
	*/
	wire cnt16 = &counter;
	always@(*) begin
		if (valid && cnt16) begin
			n_counter <= 4'b0000;
			end
		else begin
			n_counter <= counter + 4'b1;
			end
	end
	always@(posedge clk or posedge rst)	begin
		if (rst)
			counter <= 4'b1110;
		else
			counter <= n_counter;
	end
	
endmodule

module buffer_8 #(
    parameter WIDTH = 24,
    parameter DEPTH = 8 // 3-bit address space for 8 locations
) (
    input wire clk, // clock signal
    input wire rst, // reset signal
    input wire wr_en, // write enable signal
    input wire [2:0] write_addr, // 3-bit write address
    input wire [WIDTH-1:0] dinr, // 24-bit input data 1
    input wire [WIDTH-1:0] dini, // 24-bit input data 2
    input wire [2:0] add_ar, // 3-bit read address 1
    input wire [2:0] add_ai, // 3-bit read address 2
    input wire [2:0] add_br, // 3-bit read address 3
    input wire [2:0] add_bi, // 3-bit read address 4
    output reg [WIDTH-1:0] doutar, // 24-bit output data 1
    output reg [WIDTH-1:0] doutai, // 24-bit output data 2
    output reg [WIDTH-1:0] doutbr, // 24-bit output data 3
    output reg [WIDTH-1:0] doutbi // 24-bit output data 4
);

    // Declare memory array
    reg [WIDTH-1:0] memr [0:DEPTH-1];
	reg [WIDTH-1:0] memi [0:DEPTH-1];
    // Write logic for real and imaginary parts
	integer i;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all memory cells to 0

            for (i = 0; i < DEPTH; i = i + 1) begin
                memr[i] <= {WIDTH{1'b0}};
                memi[i] <= {WIDTH{1'b0}};
            end
        end else if (wr_en) begin
            // Write data to the specified address
            memr[write_addr] <= dinr;
            memi[write_addr] <= dini;
        end
    end

    // Read logic for real and imaginary parts
    always @(*) begin
        doutar <= memr[add_ar]; // Read from real part memory at address add_ar
        doutai <= memi[add_ai]; // Read from imaginary part memory at address add_ai
        doutbr <= memr[add_br]; // Read from real part memory at address add_br
        doutbi <= memi[add_bi]; // Read from imaginary part memory at address add_bi
    end

endmodule
