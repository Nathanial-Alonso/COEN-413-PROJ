//Project One Test Bench
//Ewan McNeil 40021787
//Nate
//Gabriel 40057854


`default_nettype none
module testbench;	  
	// Setup the variables
	reg c_clk;
	logic [1:7] reset;

	// Inputs
	logic [0:3] req1_cmd_in;
	logic [0:31] req1_data_in;

	logic [0:3] req2_cmd_in;
	logic [0:31] req2_data_in;

	logic [0:3] req3_cmd_in;
	logic [0:31] req3_data_in;

	logic [0:3] req4_cmd_in;
	logic [0:31] req4_data_in;

	// Outputs
	logic [0:1] out_resp1;
	logic [0:31] out_data1;

	logic [0:1] out_resp2;
	logic [0:31] out_data2;

	logic [0:1] out_resp3;
	logic [0:31] out_data3;

	logic [0:1] out_resp4;
	logic [0:31] out_data4;
	
	// Local testing variables
	integer error;	
	
	// Instantiate the Device Under Test : the Calculator
	calc1_top calc1_top(
		.c_clk(c_clk),
		.reset(reset),

		// Inputs
		.req1_cmd_in(req1_cmd_in),
		.req1_data_in(req1_data_in),

		.req2_cmd_in(req2_cmd_in),
		.req2_data_in(req2_data_in),

		.req3_cmd_in(req3_cmd_in),
		.req3_data_in(req3_data_in),

		.req4_cmd_in(req4_cmd_in),
		.req4_data_in(req4_data_in),

		// Outputs
		.out_resp1(out_resp1),
		.out_data1(out_data1),

		.out_resp2(out_resp2),
		.out_data2(out_data2),

		.out_resp3(out_resp3),
		.out_data3(out_data3),

		.out_resp4(out_resp4),
		.out_data4(out_data4)
	 );

	// Array for ports
	int ports [4] = '{1,2,3,4};

	// Clock generator
	initial begin 
	   c_clk = 0;
	   forever #50 c_clk = !c_clk;
	end

	initial begin
		
		integer i;
		int cycleOnReset = 1;


		$display("----------first------");

		/////////////////////////
		//BASIC FUNCTION TESTS
		////////////////////////


		//this is the working reset
		//the specification reset is done by
		//resetDUT(0)

		resetAll(cycleOnReset);

		$display("--------------------------------------------------------------------");
		$display("----------Running Test 1.1 Command and Response for each port-------");
		$display("--------------------------------------------------------------------");

		for(i = 0; i < $size(ports); i++) begin
			$display("Testing port #%d", ports[i]);
			cycle_commands(ports[i],1);
			resetAll(cycleOnReset);
		end


		$display("--------------------------------------------------------------------");
		$display("------------------Running Test 1.2.1 addition check ----------------");
		$display("--------------------------------------------------------------------");


		for(i = 0; i < $size(ports); i++) begin
			$display("port #%b", ports[i]);
			calculate(ports[i],0001,32'h00000005,32'h00000005);
			compare_expected_value(ports[i],32'h0000000A);
			resetDUT(cycleOnReset);
				end

		

		$display("--------------------------------------------------------------------");
		$display("----------Running Test 1.2.2 subtraction check ---------------------");
		$display("--------------------------------------------------------------------");
		
		
		for(i = 0; i < $size(ports); i++) begin	
		$display("Testing port #%d", ports[i]);
		calculate(ports[i],4'b0010,32'h00000000,32'hFFFFFFFF);
		compare_expected_value(ports[i],32'h00000003);
		resetDUT(cycleOnReset);
		end
		
		
		$display("--------------------------------------------------------------------");
		$display("----------Running Test 1.2.3 shift left check ----------------------");
		$display("--------------------------------------------------------------------");


		for(i = 1; i < $size(ports); i++) begin
			calculate(ports[i],0101,32'h00000005,32'h00000003);
				compare_expected_value(ports[i],32'h00000028);
		end


		$display("--------------------------------------------------------------------");
			$display("----------Running Test 1.2.4 shift right check -----------------");
		$display("--------------------------------------------------------------------");




		$display("--------------------------------------------------------------------");
		$display("----------Running Test 1.2.3 overflow check ----------------------");
		$display("--------------------------------------------------------------------");
		
		for(i = 0; i < $size(ports); i++) begin
			$display("Testing port #%d", ports[i]);
			calculate(ports[i],0001,32'h00000000,32'hFFFFFFFF);
		
			check_for_response(ports[i]);
			compare_expected_value(ports[i],32'h0000000A);
			resetDUT();
		end
		
		

		
		
		$display("--------------------------------------------------------------------");
		$display("----------Running Test 1.2.3 underflow check ----------------------");
		$display("--------------------------------------------------------------------");

				for(i = 0; i < $size(ports); i++) begin
						$display("Testing port #%b", ports[i]);
						calculate(ports[i],0010,32'h11111111,32'h20000000);
			check_for_response(ports[i]);
						resetDUT(cycleOnReset);
				end



	/////////////////////////
	//ADVANCED FUNCTION TESTS
	////////////////////////

		$display("--------------------------------------------------------------------");
		$display("----------Running Test 2.1.1 Command following----------------------");
		$display("--------------------------------------------------------------------");



		$display("--------------------------------------------------------------------");
		$display("----------Running Test 2.1.2 Concurrent commands----------------------");
		$display("--------------------------------------------------------------------");



		$display("--------------------------------------------------------------------");
		$display("----------Running Test 2.2 Prioirity Check -------------------------");
		$display("--------------------------------------------------------------------");

		$display("--------------------------------------------------------------------");
		$display("----------Running Test 2.4.1 Corner Case overflow of one -----------");
		$display("--------------------------------------------------------------------");



		$display("--------------------------------------------------------------------");
		$display("----------Running Test 2.4.2 sum to max------------------------------");
		$display("--------------------------------------------------------------------");




		$display("--------------------------------------------------------------------");
		$display("----------Running Test 2.4.3 Subtracting Equal----------------------");
		$display("--------------------------------------------------------------------");


		$display("--------------------------------------------------------------------");
		$display("----------Running Test 2.4.5 Shifiting zero places-------------------");
		$display("--------------------------------------------------------------------");


		$display("--------------------------------------------------------------------");
		$display("----------Running Test 2.4.6 Shifiting maximum place----------------");
		$display("--------------------------------------------------------------------");


		$display("--------------------------------------------------------------------");
		$display("----------Running Test 2.5 ignoring invalid data--------------------");
		$display("--------------------------------------------------------------------");


		$display("--------------------------------------------------------------------");
		$display("----------Running Test 3.1 ignoring invalid commamnds---------------");
		$display("--------------------------------------------------------------------");



		//dont know what 3.2 is asking 
		$display("--------------------------------------------------------------------");
		$display("----------Running Test 3.2 output for all ports and invalid commands are corrent ------");
		$display("--------------------------------------------------------------------");





		$display("--------------------------------------------------------------------");
		$display("----------test that the reset function resets the desgin properly---");
		$display("--------------------------------------------------------------------");




	/////////////////////////
	//GENERERIC FUNCTION TESTS
	////////////////////////

	


	end



// Functions for a modular test bench


task cycle_commands(int port,int checkResponse);

			integer j;

	//now I want to cylce through commands


	//testing only defined commands come back later and test invalid
	logic [0:3] commands [5] = '{4'b0000,4'b0001,4'b0010,4'b0101,4'b0110};

	for(j = 0; j < 5; j++)begin
		if(checkResponse == 1)begin
			$display("Testing command %b",commands[j]);
			end
			if(port ==1)begin
			req1_cmd_in <= commands[j];
			req1_data_in <= 1;
			@(posedge c_clk);
			req1_data_in <= 3;
			end
		if(port == 2) begin
			req2_cmd_in <= commands[j];
			req2_data_in <= 1;
			@(posedge c_clk);
			req2_data_in <= 3;
			end
		if(port == 3)begin
			req3_cmd_in <= commands[j];
			req3_data_in <= 1;
			@(posedge c_clk);
			req3_data_in <= 3;
		end
		if(port == 4) begin
			req4_cmd_in <= commands[j];
			req4_data_in <= 1;
			@(posedge c_clk);
			req4_data_in <= 3;
		end

		if(checkResponse == 1)begin
			check_for_response(port);
		end
	end

endtask



task check_for_response(int port);
	logic [0:1] resp;
	integer i;
                    
	for(i = 0; i < 100; i++) begin
		@(posedge c_clk);
		if(port == 1) begin
			resp = out_resp1;
		end

		if(port == 2) begin
			resp = out_resp2;
		end

		if(port == 3) begin
			resp = out_resp3;
		end

		if(port == 4) begin
			resp = out_resp4;
		end

		if(resp == 01) begin
			$display("Sucessful repsonse");
			break;
		end
		if(resp == 10) begin
			$display("Under flow overflow or invalid command" );
			break;
		end
		if(resp == 11) begin
			$display("unused response value obtained");
			break;
		end
		if(resp === 2'bxx) begin
			$display("Error: xx repsonse obtained");
			
			break;
		end
		
	end

	
	if(resp == 00)begin
		$display("NO RESPONSE");
		if(port ==4)begin
		
		end
	end	

endtask


// Function for calculate the answer of a given a command
task calculate(int port, logic[0:3] command, logic[0:31] operand1, logic[0:31] operand2);
	@(posedge c_clk);
		if(port == 1) begin
			$display("%b",command);
			req1_cmd_in <= command;
			req1_data_in <= operand1;
			@(posedge c_clk);
			req1_data_in <= operand2;
			@(posedge c_clk);
		end

		if(port == 2) begin
			req2_cmd_in <= command;
			req2_data_in <= operand1;
			@(posedge c_clk);
			req2_data_in <= operand2;
			@(posedge c_clk);
		end
		  
		if(port == 3) begin
			req3_cmd_in <= command;
			req3_data_in <= operand1;
			@(posedge c_clk);
			req3_data_in <= operand2;
			@(posedge c_clk);
        end
		
		if(port == 4) begin
			req4_cmd_in <= command;
			req4_data_in <= operand1;
			@(posedge c_clk);
			req4_data_in <= operand2;
			@(posedge c_clk);
		end
endtask

// Function to compare the actual value with the expected one
task compare_expected_value(int port, logic[0:31] expected_data);
	integer i;
	logic [31:0] data_out;
	logic [1:0] resp;  		

	for(i = 0; i < 40; i++) begin
	        @(posedge c_clk);
		
		if(port == 1) begin
			data_out = out_data1;
			resp = out_resp1;
		end	

		if(port == 2) begin
			data_out = out_data2;
			resp = out_resp2;
        end

		if(port == 3) begin
			data_out = out_data3;
			resp = out_resp3;	
		end

		if(port == 4) begin
			data_out = out_data4;
			resp = out_resp4;	
		end
		
                if(resp == 01) begin
			$display("The port being used is #%b", port);

                if(expected_data == data_out) begin
             		$display("expected data is equal to %b and data out is %b", expected_data, data_out);
						
				break;
			end
           		else begin 
				$display("expected data is equal to %b but data out is %b", expected_data, data_out);
				break;
			end
		end
        end   
endtask





task resetAll(cycleOnReset);
resetDUT(cycleOnReset);
resetDUT(cycleOnReset);
endtask




// Function to reset the DUT	
//I commentedd out the display because it was getting too much
task resetDUT(int cycleStart);

	if(cycleStart ==1)begin
	for(int i = 1; i <5; i++)begin
	cycle_commands(i,0);
	end
	end
	resetInputs();
	reset <= 7'b1111111;
	//$display("resetting");	
	@(posedge c_clk);
	@(posedge c_clk);
	@(posedge c_clk);
	@(posedge c_clk);
	@(posedge c_clk);
	@(posedge c_clk);
	@(posedge c_clk);
	reset <= 7'b0000000;

	for(int i = 0; i < 400; i++) begin
	 @(posedge c_clk);   
    
    end
	
endtask



task resetInputs();
	req1_cmd_in <= 0000;
	req1_data_in <= 32'h00000000;

	req2_cmd_in<= 0000;
	req2_data_in<= 32'h00000000;

	req3_cmd_in<= 0000;
	req3_data_in<= 32'h00000000;

	req4_cmd_in<= 0000;
	req4_data_in<= 32'h00000000;
endtask


// Function to display all the inputs and outputs
task displayIO();
	$display("c_clk: %b", c_clk);
	$display("reset: %b", reset);

	// Inputs
	$display("cmd1 %b", req1_cmd_in);
	$display("data1 %b", req1_data_in);

	$display("cmd2 %b", req2_cmd_in);
	$display("data2 %b",req2_data_in);

	$display( "cmd3 %b",req3_cmd_in);
	$display("data3 %b",req3_data_in);

	$display("cmd4 %b",req4_cmd_in);
	$display("data4 %b",req4_data_in);

	//outputs

	$display("resp1 %b",out_resp1);
	$display("dataout1 %b",out_data1);

	$display("resp2 %b",out_resp2);
	$display("data_out2 %b", out_data2);

	$display("resp3 %b",out_resp3);
	$display("data_out3 %b",out_data3);

	$display("resp4 %b",out_resp4);
	$display(" dataout4 %b",out_data4);

endtask;
	
	

	
endmodule
