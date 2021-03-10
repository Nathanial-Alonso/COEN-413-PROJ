// Project One Test Bench
// Ewan McNeil 40021787
// Nate
// Gabriel 40057854


`default_nettype none
module testbench;	  
	// Setup the variables
	reg c_clk;
	logic [1:7] reset;

	// Inputs
	logic [0:3] commands [4] = '{4'b0001,4'b0010,4'b0101,4'b0110};

	logic [0:31] op1;
	logic [0:31] op2;
	logic [0:31] expected;

	localparam NoOP = 4'b0000,
	      Add = 4'b0001,
	      Sub = 4'b0010,
		  ShiftLeft = 4'b0101, 
		  ShiftRight = 4'b0110;
	      
	logic [0:3] cmd [4];
	logic [0:31] data_in[4];
	logic [0:31] data_out[4];
	logic [0:1] resp[4];
	
	// Instantiate the Device Under Test : the Calculator
	calc1_top calc1_top(
		.c_clk(c_clk),
		.reset(reset),

		// Inputs
		.req1_cmd_in(cmd[0]),
		.req1_data_in(data_in[0]),

		.req2_cmd_in(cmd[1]),
		.req2_data_in(data_in[1]),

		.req3_cmd_in(cmd[2]),
		.req3_data_in(data_in[2]),

		.req4_cmd_in(cmd[3]),
		.req4_data_in(data_in[3]),

		// Outputs
		.out_resp1(resp[0]),
		.out_data1(data_out[0]),

		.out_resp2(resp[1]),
		.out_data2(data_out[1]),

		.out_resp3(resp[2]),
		.out_data3(data_out[2]),

		.out_resp4(resp[3]),
		.out_data4(data_out[3])
	 );

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

		// This is the working reset
		// The specification reset is done by
		resetDUT(0);

		//resetAll(cycleOnReset);

		$display("--------------------------------------------------------------------");
		$display("----------Running Test 1.1 Command and Response for each port-------");
		$display("--------------------------------------------------------------------");

		//looking for a response of 01
		for(i = 0; i < $size(cmd); i++) begin
			$display("Testing port #%d", i);
			cycle_commands(i,1);
			//resetAll(cycleOnReset);
			resetDUT(0);
		end

		$display("--------------------------------------------------------------------");
		$display("------------------Running Test 1.2.1 addition check ----------------");
		$display("--------------------------------------------------------------------");

		for(i = 0; i < $size(cmd); i++) begin
			$display("port #%b", i);
			calculate(i,4'b0001,32'h00000005,32'h00000005);
			compare_expected_value(i,32'h0000000A);
			resetDUT(0);
		end

		$display("--------------------------------------------------------------------");
		$display("----------Running Test 1.2.2 subtraction check ---------------------");
		$display("--------------------------------------------------------------------");
		
		for(i = 0; i < $size(cmd); i++) begin	
		$display("Testing port #%d", i);
		calculate(i,4'b0010,32'h00000000,32'hFFFFFFFF);
		compare_expected_value(i,32'h00000003);
		resetDUT(0);
		end
		
		$display("--------------------------------------------------------------------");
		$display("----------Running Test 1.2.3 shift left check ----------------------");
		$display("--------------------------------------------------------------------");

		for(i = 1; i < $size(cmd); i++) begin
			calculate(i,4'b0101,32'h00000005,32'h00000003);
			compare_expected_value(i,32'h00000028);
			resetDUT(0);
		end

		$display("--------------------------------------------------------------------");
			$display("----------Running Test 1.2.4 shift right check -----------------");
		$display("--------------------------------------------------------------------");

		for(i = 1; i < $size(cmd); i++) begin
			calculate(i,4'b0110,32'h00000005,32'h00000003);
			compare_expected_value(i,32'h00000028);
			resetDUT(0);
		end

		$display("--------------------------------------------------------------------");
		$display("----------Running Test 1.2.3 overflow check ----------------------");
		$display("--------------------------------------------------------------------");
		
		for(i = 0; i < $size(cmd); i++) begin
			$display("Testing port #%d", i);
			calculate(i,4'b0001,32'h00003000,32'hFFFFFFFF);
		
			check_for_response(i);
			compare_expected_value(i,32'h0000000A);
			resetDUT(0);
		end
		
		$display("--------------------------------------------------------------------");
		$display("----------Running Test 1.2.3 underflow check ----------------------");
		$display("--------------------------------------------------------------------");

			for(i = 0; i < $size(cmd); i++) begin
				$display("Testing port #%d", i);
				calculate(i,4'b0010,32'h11111111,32'h20000000);
				
				check_for_response(i);
				resetDUT(0);
			end


		/////////////////////////
		//ADVANCED FUNCTION TESTS
		////////////////////////

		$display("--------------------------------------------------------------------");
		$display("----------Running Test 2.1.1 Command following----------------------");
		$display("--------------------------------------------------------------------");

		resetDUT(0);
		// On each port test every command (with valid inputs) and test another command after and ensure it ran properly
		// Check that its not dirty after running a command before
		// Expected value is then the first run of the command clean. 
		
		op1 = 32'h00000101;
		op2 = 32'h00000111;
		expected = 32'h00000000;
		for(i = 0; i < $size(cmd); i++) begin					//first loop is for all ports
			$display("TESTING PORT %d",i);
			for(int j = 0; j < $size(commands); j++)begin		//second is select first command

				//getting expected value
				calculate(i,commands[j],op1,op2);			
				expectedValue(op1,op2,commands[j],expected);	

				//reseting the DUT
				resetDUT(0);
				$display("Testing command initial %b",commands[j]);

				for(int k = 0; k < $size(commands); k++)begin	//this is select subsequenct command

					$display("Testing second command %b",commands[k]);
					//calulcate new command 	
					calculate(i,commands[k],op1,op2);			
					
					//check that the second didnt make the initail run change
					calculate(i,commands[j],op1,op2);	
					compare_expected_value(i,expected);
					resetDUT(0);
				end
			end
		end

		$display("--------------------------------------------------------------------");
		$display("----------Running Test 2.1.2 Concurrent commands----------------------");
		$display("--------------------------------------------------------------------");



		$display("--------------------------------------------------------------------");
		$display("----------Running Test 2.2 Prioirity Check -------------------------");
		$display("--------------------------------------------------------------------");



		$display("--------------------------------------------------------------------");
		$display("----------Running Test 2.3 High order 27 -------------------------");
		$display("--------------------------------------------------------------------");



		$display("--------------------------------------------------------------------");
		$display("----------Running Test 2.4.1 Corner Case overflow of one -----------");
		$display("--------------------------------------------------------------------");

		for(i = 0; i < $size(cmd); i++) begin
			$display("port #%h", i);
			calculate(i,4'b0001,32'hFFFFFFFF,32'h00000001);
			check_for_response(i);
			compare_expected_value(i,32'h00000000);
			resetDUT(0);
		end

		$display("--------------------------------------------------------------------");
		$display("----------Running Test 2.4.2 sum to max------------------------------");
		$display("--------------------------------------------------------------------");

		for(i = 0; i < $size(cmd); i++) begin
			$display("port #%h", i);
			calculate(i,4'b0001,32'hFFFF0000,32'h0000FFFF);
			check_for_response(i);
			compare_expected_value(i,32'hFFFFFFFF);
			resetDUT(0);
		end

		$display("--------------------------------------------------------------------");
		$display("----------Running Test 2.4.3 Subtracting Equal----------------------");
		$display("--------------------------------------------------------------------");

		for(i = 0; i < $size(cmd); i++) begin
			$display("port #%h", i);
			calculate(i,4'b0010,32'h0000A00,32'h0000A00);
			check_for_response(i);
			compare_expected_value(i,32'h00000000);
			resetDUT(0);
		end

		$display("--------------------------------------------------------------------");
		$display("----------Running Test 2.4.5 Shifiting zero places-------------------");
		$display("--------------------------------------------------------------------");

		$display("SHIFT LEFT");
		for(i = 0; i < $size(cmd); i++) begin
			$display("port #%h", i);
			calculate(i,4'b0101,32'h0000A00,32'h0000000);
			compare_expected_value(i,32'h00000000);
			resetDUT(0);
		end

		$display("SHIFT RIGHT");
		for(i = 0; i < $size(cmd); i++) begin
			$display("port #%h", i);
			calculate(i,4'b0110,32'h0000A00,32'h0000000);
			compare_expected_value(i,32'h00000A00);
			resetDUT(0);
		end

		$display("--------------------------------------------------------------------");
		$display("----------Running Test 2.4.6 Shifiting maximum place----------------");
		$display("--------------------------------------------------------------------");

		$display("SHIFT LEFT");
		for(i = 0; i < $size(cmd); i++) begin
			$display("port #%h", i);
			calculate(i,4'b0101,32'h0000001,32'h0000001F);			//32 in hex is 1f
			compare_expected_value(i,32'h1000000);
			resetDUT(0);
		end

		$display("SHIFT RIGHT");
		for(i = 0; i < $size(cmd); i++) begin
			$display("port #%h", i);
			calculate(i,4'b0110,32'h0000001,32'h0000001F);
			compare_expected_value(i,32'h00000001);
			resetDUT(0);
		end

		$display("--------------------------------------------------------------------");
		$display("----------Running Test 2.5 ignoring invalid data--------------------");
		$display("--------------------------------------------------------------------");



		/////////////////////////
		//GENERERIC FUNCTION TESTS
		////////////////////////

		$display("--------------------------------------------------------------------");
		$display("----------Running Test 3.1 ignoring invalid commamnds---------------");
		$display("--------------------------------------------------------------------");



		//dont know what 3.2 is asking 
		$display("--------------------------------------------------------------------");
		$display("----------Running Test 3.2 output for all ports and invalid commands are correct ------");
		$display("--------------------------------------------------------------------");



		$display("--------------------------------------------------------------------");
		$display("----------test that the reset function resets the desgin properly---");
		$display("--------------------------------------------------------------------");
			
		resetDUT(0);  //does the default reset
		for(int i = 0; i < $size(cmd); i++) begin
			$display("Testing output Port %d", i);
			if(resp[i] == 00) begin
				$display("Response reset Sucessfully");
			end
			else begin
				$display("FAIL: resp not reset %d", resp[i]);
			end
			if(data_out[i] ==32'h00000000) begin
				$display("Response reset Sucessfully");
			end
			else begin
				$display("FAIL: data out not reset %d", data_out[i]);
			end
		end
	end

	// Functions for a modular test bench

	task cycle_commands(int port,int checkResponse);

		integer j;
		// Testing only defined commands come back later and test invalid
		//logic [0:3] commands [5] = '{4'b0000,4'b0001,4'b0010,4'b0101,4'b0110};

		for(j = 0; j < 5; j++) begin
			if(checkResponse == 1) begin
				$display("Testing command %b",commands[j]);
			end

			cmd[port] = commands[j];
			data_in[port] = 1;
			@(posedge c_clk);
			data_in[port] = 3;
			if(checkResponse == 1) begin
				check_for_response(port);
			end
		end
	endtask

	task check_for_response(int port);
		
		integer i;                
		for(i = 0; i < 100; i++) begin
			@(posedge c_clk);

			if(resp[port] == 01) begin
				$display("Sucessful repsonse");
				break;
			end
			if(resp[port] == 10) begin
				$display("Under flow overflow or invalid command" );
				break;
			end
			if(resp[port] == 11) begin
				$display("unused response value obtained");
				break;
			end
			if(resp[port] === 2'bxx) begin
				$display("Error: xx repsonse obtained");
				break;
			end
			
		end
		if(resp[port] == 00)begin
			$display("NO RESPONSE");
		end	
	endtask


	// Function for calculate the answer of a given a command
	task calculate(int port, logic[0:3] command, logic[0:31] operand1, logic[0:31] operand2);
		@(posedge c_clk);
		cmd[port]= command;
		data_in[port] = operand1;
		@(posedge c_clk);
		data_in[port] = operand2;
		@(posedge c_clk);
	endtask

	// Function to compare the actual value with the expected one
	task compare_expected_value(int port, logic[0:31] expected_data);
		integer i;		

		for(i = 0; i < 40; i++) begin
				@(posedge c_clk);
			
				if(resp[port] == 01) begin

					if(expected_data == data_out[port]) begin
						$display("Got expected value");
						break;
					end
				else begin 
					$display("expected data is equal to %h but data out is %h", expected_data, data_out[port]);
					break;
				end
				end
		end
		//if no comparison check for response
		if(resp[port] != 01) begin
			check_for_response(port);
		end
	endtask

	task resetAll(cycleOnReset);
		resetDUT(cycleOnReset);
		resetDUT(cycleOnReset);
	endtask

	// Function to reset the DUT	
	// I commented out the display because it was getting too much
	task resetDUT(int cycleStart);

		if(cycleStart ==1) begin
			for(int i = 1; i <5; i++) begin
				cycle_commands(i,0);
			end
		end
		resetInputs();
		reset = 7'b1111111;
			
		@(posedge c_clk);
		@(posedge c_clk);
		@(posedge c_clk);
		@(posedge c_clk);
		@(posedge c_clk);
		@(posedge c_clk);
		@(posedge c_clk);
		reset = 7'b0000000;

		for(int i = 0; i < 400; i++) begin
		 @(posedge c_clk);   
		end
		
	endtask

	// TODO make sure that the shifting is acutally doing what it is supposed to 
	task expectedValue( input logic [0:31] op1,logic [0:31] op2, logic [0:3] command, output logic [0:31] out);
		if(command == 0001) begin
			out = op1 + op2;
		end
		if(command == 0010) begin
			out = op1 - op2;
		end
		if(command == 0101) begin
			out = op1*2**op1;		//shift left == mult by 2^x
		end
		if(command == 0110) begin
			out = op1/2**op2;		//shift right == divide by 2^x
		end
	endtask

	task resetInputs();
		for(int i = 0; i < $size(cmd); i++) begin
			cmd[i] = 0000;
			data_in[i] = 32'h00000000;
		end
	endtask

	// Function to display all the inputs and outputs
	task displayIO();
		$display("c_clk: %b", c_clk);
		$display("reset: %b", reset);

		for(int i = 0; i < $size(cmd); i++) begin
			$display("Port %d", i);
			$display("cmd  %b", cmd[i]);
			$display("data1 %b", data_in[i]);
			$display("resp1 %b",resp[i]);
			$display("dataout1 %b",data_out[i]);
		end
	endtask;
		
endmodule
