module stage3(pass3, luck3, slide, timing, bonus2, pass2);
    output          pass3;
    input   [2:0]   slide;
    input   [2:0]   timing;
    input   [2:0]   luck3;
    input   [1:0]   bonus2;
    input           pass2;
    reg             accident0, accident1, accident2, accident3, fail0, fail1;
    wire    [2:0]   bad;
    always@(*) //slide quality
        if(slide == 3'd0)
            fail0 = 1'd0;
        else if((slide < 3'd2)||(slide == 3'd2))
            accident0 == (slide^(luck3[2:0]) == 3'b000)? 1'b1 : 1'b0;
        else if((slide > 3'd3)||(slide == 3'd3))
            accident1 == (slide^(luck3[2:0]) == 3'b001)? 1'b1 : 1'b0;
    always@(*) //report time
        if(timing == 3'd0)
            fail1 = 1'd0;
        else if((timing < 3'd2)||(timing == 3'd2))
            accident2 == (timing^(luck3[2:0]) == 3'b010)? 1'b1 : 1'b0;
        else if((timing > 3'd3)||(timing == 3'd3))
            accident3 == (timing^(luck3[2:0]) == 3'b100)? 1'b1 : 1'b0;
    assign bad = accident0*2 + accident1 + accident2*2 + accident3;
    assign pass3 = (pass2 && fail0 && fail1)?((bad <= 3'd1)? 1'b1 :((bonus2 >= bad)?1'b1 : 1'b0)) : 1'b0;
endmodule