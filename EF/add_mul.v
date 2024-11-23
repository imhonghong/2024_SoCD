module add_mul(	dout00, dout01, dout02, dout03, dout04, dout05, dout06, dout07,
				dout08,	dout09, dout10, dout11, dout12, dout13, dout14, dout15,
				dout16, dout17, dout18, dout19, dout20, dout21, dout22, dout23,
				dout24, dout25, dout26, dout27, dout28, dout29, dout30, dout31,
				sum_all
				);
	input signed [15:0]	dout00, dout01, dout02, dout03, dout04, dout05, dout06, dout07,
					dout08,	dout09, dout10, dout11, dout12, dout13, dout14, dout15,
					dout16, dout17, dout18, dout19, dout20, dout21, dout22, dout23,
					dout24, dout25, dout26, dout27, dout28, dout29, dout30, dout31;
	output signed [40:0]	sum_all;

	// FIR coefficient
	parameter signed [19:0] FIR_C00 = 20'hFFF9E ;  //The FIR_coefficient value  0: -1.495361e-003
	parameter signed [19:0] FIR_C01 = 20'hFFF86 ;  //The FIR_coefficient value  1: -1.861572e-003
	parameter signed [19:0] FIR_C02 = 20'hFFFA7 ;  //The FIR_coefficient value  2: -1.358032e-003
	parameter signed [19:0] FIR_C03 = 20'h0003B ;  //The FIR_coefficient value  3:  9.002686e-004
	parameter signed [19:0] FIR_C04 = 20'h0014B ;  //The FIR_coefficient value  4:  5.050659e-003
	parameter signed [19:0] FIR_C05 = 20'h0024A ;  //The FIR_coefficient value  5:  8.941650e-003
	parameter signed [19:0] FIR_C06 = 20'h00222 ;  //The FIR_coefficient value  6:  8.331299e-003
	parameter signed [19:0] FIR_C07 = 20'hFFFE4 ;  //The FIR_coefficient value  7: -4.272461e-004
	parameter signed [19:0] FIR_C08 = 20'hFFBC5 ;  //The FIR_coefficient value  8: -1.652527e-002
	parameter signed [19:0] FIR_C09 = 20'hFF7CA ;  //The FIR_coefficient value  9: -3.207397e-002
	parameter signed [19:0] FIR_C10 = 20'hFF74E ;  //The FIR_coefficient value 10: -3.396606e-002
	parameter signed [19:0] FIR_C11 = 20'hFFD74 ;  //The FIR_coefficient value 11: -9.948730e-003
	parameter signed [19:0] FIR_C12 = 20'h00B1A ;  //The FIR_coefficient value 12:  4.336548e-002
	parameter signed [19:0] FIR_C13 = 20'h01DAC ;  //The FIR_coefficient value 13:  1.159058e-001
	parameter signed [19:0] FIR_C14 = 20'h02F9E ;  //The FIR_coefficient value 14:  1.860046e-001
	parameter signed [19:0] FIR_C15 = 20'h03AA9 ;  //The FIR_coefficient value 15:  2.291412e-001
	parameter signed [19:0] FIR_C16 = 20'h03AA9 ;  //The FIR_coefficient value 16:  2.291412e-001
	parameter signed [19:0] FIR_C17 = 20'h02F9E ;  //The FIR_coefficient value 17:  1.860046e-001
	parameter signed [19:0] FIR_C18 = 20'h01DAC ;  //The FIR_coefficient value 18:  1.159058e-001
	parameter signed [19:0] FIR_C19 = 20'h00B1A ;  //The FIR_coefficient value 19:  4.336548e-002
	parameter signed [19:0] FIR_C20 = 20'hFFD74 ;  //The FIR_coefficient value 20: -9.948730e-003
	parameter signed [19:0] FIR_C21 = 20'hFF74E ;  //The FIR_coefficient value 21: -3.396606e-002
	parameter signed [19:0] FIR_C22 = 20'hFF7CA ;  //The FIR_coefficient value 22: -3.207397e-002
	parameter signed [19:0] FIR_C23 = 20'hFFBC5 ;  //The FIR_coefficient value 23: -1.652527e-002
	parameter signed [19:0] FIR_C24 = 20'hFFFE4 ;  //The FIR_coefficient value 24: -4.272461e-004
	parameter signed [19:0] FIR_C25 = 20'h00222 ;  //The FIR_coefficient value 25:  8.331299e-003
	parameter signed [19:0] FIR_C26 = 20'h0024A ;  //The FIR_coefficient value 26:  8.941650e-003
	parameter signed [19:0] FIR_C27 = 20'h0014B ;  //The FIR_coefficient value 27:  5.050659e-003
	parameter signed [19:0] FIR_C28 = 20'h0003B ;  //The FIR_coefficient value 28:  9.002686e-004
	parameter signed [19:0] FIR_C29 = 20'hFFFA7 ;  //The FIR_coefficient value 29: -1.358032e-003
	parameter signed [19:0] FIR_C30 = 20'hFFF86 ;  //The FIR_coefficient value 30: -1.861572e-003
	parameter signed [19:0] FIR_C31 = 20'hFFF9E ;  //The FIR_coefficient value 31: -1.495361e-003

wire signed [35:0] product00, product01, product02, product03, product04, product05, product06, product07,
					product08, product09, product10, product11, product12, product13, product14, product15,
					product16, product17, product18, product19, product20, product21, product22, product23,
					product24, product25, product26, product27, product28, product29, product30, product31;
					
assign product00 = dout00 * FIR_C00 ;
assign product01 = dout01 * FIR_C01 ;
assign product02 = dout02 * FIR_C02 ;
assign product03 = dout03 * FIR_C03 ;
assign product04 = dout04 * FIR_C04 ;
assign product05 = dout05 * FIR_C05 ;
assign product06 = dout06 * FIR_C06 ;
assign product07 = dout07 * FIR_C07 ;
assign product08 = dout08 * FIR_C08 ;
assign product09 = dout09 * FIR_C09 ;

assign product10 = dout10 * FIR_C10 ;
assign product11 = dout11 * FIR_C11 ;
assign product12 = dout12 * FIR_C12 ;
assign product13 = dout13 * FIR_C13 ;
assign product14 = dout14 * FIR_C14 ;
assign product15 = dout15 * FIR_C15 ;
assign product16 = dout16 * FIR_C16 ;
assign product17 = dout17 * FIR_C17 ;
assign product18 = dout18 * FIR_C18 ;
assign product19 = dout19 * FIR_C19 ;

assign product20 = dout20 * FIR_C20 ;
assign product21 = dout21 * FIR_C21 ;
assign product22 = dout22 * FIR_C22 ;
assign product23 = dout23 * FIR_C23 ;
assign product24 = dout24 * FIR_C24 ;
assign product25 = dout25 * FIR_C25 ;
assign product26 = dout26 * FIR_C26 ;
assign product27 = dout27 * FIR_C27 ;
assign product28 = dout28 * FIR_C28 ;
assign product29 = dout29 * FIR_C29 ;

assign product30 = dout30 * FIR_C30 ;
assign product31 = dout31 * FIR_C31 ;


assign sum_all =  	product00 + product01 + product02 + product03 + product04 + product05 + product06 + product07 +
					product08 + product09 + product10 + product11 + product12 + product13 + product14 + product15 +
					product16 + product17 + product18 + product19 + product20 + product21 + product22 + product23 +
					product24 + product25 + product26 + product27 + product28 + product29 + product30 + product31;
					
endmodule
