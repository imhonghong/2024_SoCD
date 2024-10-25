module stage3(pass3, luck3, slide, timing, bonus2, pass2);
    output          pass3;
	input   [2:0]   slide, timing, luck3;
    input   [1:0]   bonus2;
    input           pass2;
    reg             accident0, accident1, accident2, accident3, fail0, fail1;
    always@(*) begin
        {fail0, fail1, accident0, accident1, accident2, accident3} = 6'b001111;
        if(slide == 3'd0)
            fail0 = 1'd0;
        else if((slide < 3'd3)||(slide == 3'd3))
            accident0 = (slide^(luck3[2:0]) == 3'b000)? ((bonus2==2'd3)?1'b0:1'b1) : 1'b0;
        else if(slide > 3'd4)
            accident1 = (slide^(luck3[2:0]) == 3'b001)? 1'b1 : 1'b0;
		else begin
			accident0 = 1'b0;
			accident1 = 1'b0;
		end
        if(timing == 3'd0)
            fail1 = 1'd0;
        else if((timing < 3'd3)||(timing == 3'd3))
            accident2 = (timing^(luck3[2:0]) == 3'b010)? ((bonus2>=2'd1)?1'b0:1'b1) : 1'b0;
        else
            accident3 = (timing^(luck3[2:0]) == 3'b100)? ((bonus2>=2'd2)?1'b0:1'b1) : 1'b0;
        end
	wire bonus3 = ((slide>3'd4)&&(accident1==0))? 1'b1 : 1'b0;
	wire [2:0] bad = accident0*2 + accident1 + accident2*2 + accident3;
    assign pass3 = (pass2 && fail0 && fail1)?((bad <= 3'd1)? 1'b1 :((bonus3)?1'b1 : 1'b0)) : 1'b0;
endmodule
