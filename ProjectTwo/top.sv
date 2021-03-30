module TestTop;
	bit clk;	

	always #100ns clk = ~clk;	

	calcInterface DUT_IF(clk);
	calc_2top DUT(DUT_IF);
	testBench TEST(DUT_IF);
endmodule

interface calcInterface(input logic clk);
   	//inputs to device
   	//indexed 0 -> port 1...
   	logic reset;
   	logic [0:3] cmd[4];
	logic [0:31] data_in[4];
    	logic [0:1] tag_in[4];

    	//outputs of device 
    	logic [0:1] resp[4];
	logic [0:31] data_out[4];
	logic [0:1] tag_out[4];
endinterface
