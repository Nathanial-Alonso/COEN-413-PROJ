module Top;
    bit	clk;	
    always #50 clk = ~clk;	

    dut_IF IF(clk);

    //I think mod ports would fix this
    calc2_top DUT(.c_clk(IF.c_clk), .reset(IF.reset), .req1_cmd_in(IF.req1_cmd_in), .req1_data_in(IF.req1_data_in),.req1_tag_in(IF.req1_tag_in));
   
    testBench TEST(IF.TEST);

    initial begin
        $display("top is running");
    end
endmodule



interface dut_IF(input logic c_clk);

		//inputs to device
		//I think these should be packed diff
		logic reset;
		logic [0:3] req1_cmd_in;
		logic [0:31] req1_data_in;
		logic [0:1] req1_tag_in;


		logic [0:3] req2_cmd_in;
		logic [0:31] req2_data_in;
		logic [0:1] req2_tag_in;

		logic [0:3] req3_cmd_in;
		logic [0:31] req3_data_in;
		logic [0:1] req3_tag_in;

		logic [0:3] req4_cmd_in;
		logic [0:31] req4_data_in;
		logic [0:1] req4_tag_in;


		//outputs of device 
		logic [0:1] out_resp1;
		logic [0:31] out_data1;
		logic [0:1] out_tag1;

		logic [0:1] out_resp2;
		logic [0:31] out_data2;
		logic [0:1] out_tag2;

		logic [0:1] out_resp3;
		logic [0:31] out_data3;
		logic [0:1] out_tag3;

		logic [0:1] out_resp4;
		logic [0:31] out_data4;
		logic [0:1] out_tag4;



		clocking cb	@(posedge c_clk);	//	Declare	cb
			input #2ns req1_cmd_in,req1_data_in, req1_tag_in, req2_cmd_in,req2_data_in, req2_tag_in, req3_cmd_in,req3_data_in, req3_tag_in, req4_cmd_in,req4_data_in, req4_tag_in;
			output #3ns out_resp1, out_data1, out_tag1, out_resp2, out_data2, out_tag2,out_resp3, out_data3, out_tag3, out_resp4, out_data4, out_tag4; 
		endclocking

	//ASYNC reset
		modport	TEST(clocking cb);
	// modport	DUT	(input	request,	rst,	output	grant);	

endinterface


