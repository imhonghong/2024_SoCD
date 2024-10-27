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
