module Top;
    bit	clk;	
    always #50 clk = ~clk;	

    dut_IF IF(clk);
    calc2_top DUT(IF);
    testBench TEST(IF(IF.testBench));

    initial begin
        $display("top is running");
    end
endmodule


interface dut_IF(input logic clk);

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


    clocking cb	@(posedge clk);	//	Declare	cb
        input #2ns cmd, data_in, tag_in, reset;
        output #3ns resp, data_out, tag_out; 	
    endclocking

  //ASYNC reset
    modport	testBench (clocking cb,reset);
   // modport	DUT	(input	request,	rst,	output	grant);	

    

endinterface
