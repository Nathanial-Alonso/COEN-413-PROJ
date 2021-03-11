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
	logic [0:3] commands [5] = '{4'b0000,4'b0001,4'b0010,4'b0101,4'b0110};
	logic [0:3] illegal_commands [11] = '{4'b0011,4'b0100,4'b0111,4'b1000,4'b1001,4'b1010,4'b1011,4'b1100,4'b1101,4'b1110,4'b1111}; 
	logic [0:31] op1;
	logic [0:31] op2;
	logic [0:31] expected;
	logic [0:31] currentCommand;

	/*localparam NoOP = 4'b0000,
	        Add = 4'b0001,
		Sub = 4'b0010,
		ShiftLeft = 4'b0101, 
		ShiftRight = 4'b0110;*/
	      
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
		
		/////////////////////////
		//BASIC FUNCTION TESTS
		////////////////////////
		
		resetDUT(0);
		
		//resetAll(1);

		$display("--------------------------------------------------------------------");
		$display("---------Running Test 1.1 Command and response for each port--------");
		$display("--------------------------------------------------------------------");
		for(int i = 0; i < $size(cmd); i++) begin
			$display("Testing port %0d", i);
			cycle_commands(i,1);
			resetDUT(0);
		end



		$display("--------second iteration command and response--------");
		for(int i = 0; i < $size(cmd); i++) begin
			$display("Testing port %0d", i);
			cycle_commands(i,1);
			resetDUT(0);
		end

			$display("--------third iteration command and response--------");
		for(int i = 0; i < $size(cmd); i++) begin
			$display("Testing port %0d", i);
			cycle_commands(i,1);
			resetDUT(0);
		end

		

		$display("--------------------------------------------------------------------");
		$display("------------------Running Test 1.2.1 Addition check-----------------");
		$display("--------------------------------------------------------------------");


		resetDUT(0);
		currentCommand = 4'b0001;
		op1 = 32'h00000003;
		op2 = 32'h00000005;
		expected = 32'h00000008;
		driveTest();


		resetDUT(0);
		op1 = 32'h00000005;
		op2 = 32'h00000003;
		expected = 32'h00000008;
		driveTest();

		resetDUT(0);
		op1 = 32'h50000005;
		op2 = 32'h30000003;
		expected = 32'h80000008;
		driveTest();

		resetDUT(0);
		op1 = 32'h30000003;
		op2 = 32'h50000005;
		expected = 32'h80000008;
		driveTest();

		
		$display("--------------------------------------------------------------------");
		$display("----------------Running Test 1.2.2 Subtraction check----------------");
		$display("--------------------------------------------------------------------");
		
		resetDUT(0);
		currentCommand = 4'b0010;
		op1 = 32'h00000003;
		op2 = 32'h00000005;
		expected = 32'h00000008;
		driveTest();

		resetDUT(0);
		op1 = 32'h00000005;
		op2 = 32'h00000003;
		expected = 32'h00000008;
		driveTest();

		resetDUT(0);
		op1 = 32'h50000005;
		op2 = 32'h30000003;
		expected = 32'h80000008;
		driveTest();

		resetDUT(0);
		op1 = 32'h30000003;
		op2 = 32'h50000005;
		expected = 32'h80000008;
		driveTest();

		$display("--------------------------------------------------------------------");
		$display("----------------Running Test 1.2.3 Shift left check-----------------");
		$display("--------------------------------------------------------------------");

	
		resetDUT(0);
		currentCommand = 4'b0101;
		op1 = 32'h00000005;
		op2 = 32'h00000003;
		expected = 32'h00000028;
		driveTest();
		resetDUT(0);


		op1 = 32'h00000003;
		op2 = 32'h00000005;
		expected = 32'h00000060;
		driveTest();
		resetDUT(0);
		


		$display("--------------------------------------------------------------------");
		$display("----------------Running Test 1.2.4 Shift right check----------------");
		$display("--------------------------------------------------------------------");

		resetDUT(0);
		currentCommand = 4'b0110;
		op1 = 2'h00000028;
		op2 = 32'h00000003;
		expected = 32'h00000005;
		driveTest();
		resetDUT(0);
		


		op1 = 32'h00000003;
		op2 = 32'h00000005;
		expected = 32'h00000060;
		driveTest();
		resetDUT(0);
		

		op1 = 32'h30000000;
		op2 = 32'h50000000;
		expected = 32'h00000060;
		driveTest();
		resetDUT(0);




		$display("--------------------------------------------------------------------");
		$display("-----------------Running Test 1.3.1 Overflow check------------------");
		$display("--------------------------------------------------------------------");
		for(int i = 0; i < $size(cmd); i++) begin
			$display("Testing port %0d", i);
			calculate(i,4'b0001,32'h00000003,32'hFFFFFFFF);
			check_for_response(i ,4'b0001);
			resetDUT(0);
		end
		
		$display("--------------------------------------------------------------------");
		$display("-----------------Running Test 1.3.2 Underflow check-----------------");
		$display("--------------------------------------------------------------------");
		for(int i = 0; i < $size(cmd); i++) begin
			$display("Testing port %0d", i);
			calculate(i,4'b0010,32'h11111111,32'h20000000);
			check_for_response(i,4'b0010);
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

		for(int i = 0; i < $size(cmd); i++) begin					// First loop is for all ports
			$display("Testing port %0d",i);
			
			for(int j = 0; j < $size(commands); j++) begin		// Second is select first command
				// Getting expected value
				calculate(i,commands[j],op1,op2);			
				expectedValue(op1,op2,commands[j],expected);	

				//resetting the DUT
				resetDUT(0);

				$display("Testing first command %b",commands[j]);

				for(int k = 0; k < $size(commands); k++)begin	// This is select subsequent command
					$display("Testing second command %b",commands[k]);
					// Calculate new command 	
					calculate(i,commands[k],op1,op2);			
					
					// Check that the second didnt make the initial run change
					calculate(i,commands[j],op1,op2);	
					compare_expected_value(i,expected,commands[k]);
					resetDUT(0);
				end
			end
		end

		$display("--------------------------------------------------------------------");
		$display("---------------Running Test 2.1.2 Concurrent commands---------------");
		$display("--------------------------------------------------------------------");

                resetDUT(0);

                // For each command test on each port(with valid inputs) and test on another port after and ensure it ran properly
                // Check that its not dirty after running a command before
                // Expected value is then the first run of the command clean.

                op1 = 32'h00000101;
                op2 = 32'h00000111;
                expected = 32'h00000000;

                for(int i = 0; i < $size(commands); i++) begin                                   // First loop is for all commands
                        $display("Testing commands %b",commands[i]);

                        for(int j = 0; j < $size(cmd); j++) begin          // Second is select first port
                                // Getting expected value
                                calculate(j,commands[i],op1,op2);
                                expectedValue(op1,op2,commands[i],expected);
				
                                //resetting the DUT
                                resetDUT(0);

                                //$display("Testing first port %0d",j);

                                for(int k = 0; k < $size(cmd); k++) begin   // This is select subsequent port
                                        if(j != k) begin
						$display("Testing first port %0d",j);
						$display("Testing second port %0d",k);
                                        	// Calculate new port
                                        	calculate(k,commands[i],op1,op2);
				
                                        	// Check that the second didnt make the initial run change
                                        	calculate(j,commands[i],op1,op2);
                                        	compare_expected_value(j,expected, commands[i]);
                                        	resetDUT(0);
					end
                                end
                        end
                end

		$display("--------------------------------------------------------------------");
		$display("------------------Running Test 2.2 Priority check-------------------");
		$display("--------------------------------------------------------------------");
		

		//The Priority check needs to assert the same commands in parrelle to all the ports and count the number
		//of clock cycles that have past
		//it then would need to run this a few times


		for(int i = 0; i < 5; i++) begin
        	$display("Iteration %d", i);
			calculateParrellel(4'b0001,32'h00000003,32'h00000005);
			responseTimes();
		end 

		$display("--------------------------------------------------------------------");
		$display("------------------Running Test 2.3 High order bits------------------");
		$display("--------------------------------------------------------------------");
		$display("SHIFT LEFT");
                for(int i = 0; i < $size(cmd); i++) begin
                        $display("Testing port %0d", i);
                        calculate(i,4'b0101,32'h00000A00,32'hF0030004);
                        compare_expected_value(i,32'h0000A000,4'b0101);
                        resetDUT(0);
                end

                $display("SHIFT RIGHT");
                for(int i = 0; i < $size(cmd); i++) begin
                        $display("Testing port %0d", i);
                        calculate(i,4'b0110,32'h00300040,32'hFF000004);
                        compare_expected_value(i,32'h00030004,4'b0110);
                        resetDUT(0);
                end

		$display("--------------------------------------------------------------------");
		$display("-----------Running Test 2.4.1 Corner case overflow of one-----------");
		$display("--------------------------------------------------------------------");
		for(int i = 0; i < $size(cmd); i++) begin
			$display("Testing port %0d", i);
			calculate(i,4'b0001,32'hFFFFFFFF,32'h00000001);
			check_for_response(i,4'b0001);
			resetDUT(0);
		end

		$display("--------------------------------------------------------------------");
		$display("-------------------Running Test 2.4.2 Sum to max--------------------");
		$display("--------------------------------------------------------------------");
		for(int i = 0; i < $size(cmd); i++) begin
			$display("Testing port %0d", i);
			calculate(i,4'b0001,32'hFFFF0000,32'h0000FFFF);
			compare_expected_value(i,32'hFFFFFFFF,4'b0001);
			resetDUT(0);
		end

		$display("--------------------------------------------------------------------");
		$display("----------------Running Test 2.4.3 Subtracting equal----------------");
		$display("--------------------------------------------------------------------");
		for(int i = 0; i < $size(cmd); i++) begin
			$display("Testing port %0d", i);
			calculate(i,4'b0010,32'h00000A00,32'h00000A00);
			compare_expected_value(i,32'h00000000,4'b0010);
			resetDUT(0);
		end

		$display("--------------------------------------------------------------------");
                $display("-----------Running Test 2.4.4 Corner case underflow of one----------");
                $display("--------------------------------------------------------------------");
                for(int i = 0; i < $size(cmd); i++) begin
                        $display("Testing port %0d", i);
                        calculate(i,4'b0010,32'h00000003,32'h00000004);
                        check_for_response(i,4'b0010);
                        resetDUT(0);
                end

		$display("--------------------------------------------------------------------");
		$display("--------------Running Test 2.4.5 Shifting zero places---------------");
		$display("--------------------------------------------------------------------");
		$display("SHIFT LEFT");
		for(int i = 0; i < $size(cmd); i++) begin
			$display("Testing port %0d", i);
			calculate(i,4'b0101,32'h00000A00,32'h00000000);
			compare_expected_value(i,32'h00000A00,4'b0101);
			resetDUT(0);
		end

		$display("SHIFT RIGHT");
		for(int i = 0; i < $size(cmd); i++) begin
			$display("Testing port %0d", i);
			calculate(i,4'b0110,32'h00000A00,32'h00000000);
			compare_expected_value(i,32'h00000A00,4'b0110);
			resetDUT(0);
		end

		$display("--------------------------------------------------------------------");
		$display("-------------Running Test 2.4.6 Shifting maximum places-------------");
		$display("--------------------------------------------------------------------");
		$display("SHIFT LEFT");
		for(int i = 0; i < $size(cmd); i++) begin
			$display("Testing port %0d", i);
			calculate(i,4'b0101,32'h00000001,32'h0000001F);
			compare_expected_value(i,32'h10000000,4'b0101);
			resetDUT(0);
		end

		$display("SHIFT RIGHT");
		for(int i = 0; i < $size(cmd); i++) begin
			$display("Testing port %0d", i);
			calculate(i,4'b0110,32'h80000000,32'h0000001F);
			compare_expected_value(i,32'h00000001,4'b0101);
			resetDUT(0);
		end

		$display("--------------------------------------------------------------------");
		$display("---------------Running Test 2.5 Ignoring invalid data---------------");
		$display("--------------------------------------------------------------------");

		///Trying multiple permutations of invalid data

		resetDUT(0);
		expected = 32'h00000000;
		op1 = 32'h00000005;
		op2 = 32'h0000000X;
		invalidCheck();

		resetDUT(0);
		op1 = 32'h0000000X;
		op2 = 32'h00000005;
		invalidCheck();

		resetDUT(0);
		op1 = 32'h0000000X;
		op2 = 32'h0000000X;
		invalidCheck();

		resetDUT(0);
		op1 = 32'h50000000;
		op2 = 32'hX0000000;
		invalidCheck();

		resetDUT(0);
		op1 = 32'hX0000000;
		op2 = 32'h50000000;
		invalidCheck();

		resetDUT(0);
		op1 = 32'hX0000000;
		op2 = 32'hX0000000;
		invalidCheck();

		resetDUT(0);
		op1 = 32'h000X0000;
		op2 = 32'h000X0000;
		invalidCheck();

		


		/////////////////////////
		//GENERERIC FUNCTION TESTS
		////////////////////////

		$display("--------------------------------------------------------------------");
		$display("-------------Running Test 3.1 Ignoring invalid commands-------------");
		$display("--------------------------------------------------------------------");
                for(int i = 0; i < $size(cmd); i++) begin
                        $display("Testing port %0d", i);
                        cycle_illegal_commands(i,1);
                        resetDUT(0);
                end

		$display("--------------------------------------------------------------------");
		$display("-----Running Test 3.2 Reset function resets the design properly-----");
		$display("--------------------------------------------------------------------");			
		resetDUT(0);  //does the default reset

		for(int i = 0; i < $size(cmd); i++) begin
			$display("Testing ouput port %0d", i);
			if(resp[i] == 00) begin
				$display("Response reset sucessfully");
			end
			else begin
				$display("FAIL: resp not reset %0d", resp[i]);
			end
			if(data_out[i] == 32'h00000000) begin
				$display("Response reset sucessfully");
			end
			else begin
				$display("FAIL: data out not reset %0d", data_out[i]);
			end
		end
	end

	// Functions for a modular test bench





	task driveTest();
		$display(" ");
		$display("Testing OP1: %h OP2: %h", op1,op2);
		for(int i = 0; i < $size(cmd); i++) begin
			$display("Testing port %0d", i);
				calculate(i,currentCommand,op1,op2);
				compare_expected_value(i,expected,currentCommand);							//should be zero no change
				resetDUT(0);
		end
	endtask

	task invalidCheck();
		for(int i = 0; i < $size(cmd); i++) begin
			$display("Testing OP1: %h OP2: %h", op1,op2);
			$display("Testing port %0d", i);
			for(int j = 0; j< $size(commands); j++)begin
				$display("Testing command %0h", commands[j]);
				calculate(i,commands[j],op1,op2);
				compare_expected_value(i,expected,commands[j]);							//should be zero no change
			    // displayIO();	
				// check_for_response(i);
				resetDUT(0);
			end
		end
	endtask


	task cycle_commands(int port,int checkResponse);
		integer j;

		// Testing only defined commands come back later and test invalid
		for(j = 0; j < 5; j++) begin
			if(checkResponse == 1) begin
				$display("Testing command %b",commands[j]);
			end
			
			@(posedge c_clk);
			cmd[port] = commands[j];
			data_in[port] = 1;
			@(posedge c_clk);
			data_in[port] = 3;
			@(posedge c_clk);
					
			if(checkResponse == 1) begin
				check_for_response(port,commands[j]);
			end
		end
	endtask

        task cycle_illegal_commands(int port,int checkResponse);
                integer j;
				$display("Testing OP1: %h OP2: %h", 32'h00000005,32'h00000003);
                for(j = 0; j < 5; j++) begin
                        if(checkResponse == 1) begin
                                //$display("Testing illegal command %b",illegal_commands[j]);
                        end

                        @(posedge c_clk);
                        cmd[port] = illegal_commands[j];
                        data_in[port] = 32'h00000005;
                        @(posedge c_clk);
                        data_in[port] = 32'h00000003;
                        @(posedge c_clk);

                        if(checkResponse == 1) begin
                                check_for_response(port,illegal_commands[j]);
								compare_expected_value(port,expected,illegal_commands[j]);	
                        end
                end
        endtask


	task check_for_response(int port, logic [0:3] incommand);		
		integer i;                

		for(i = 0; i < 100; i++) begin
			@(negedge c_clk);
				
			if(resp[port] == 01) begin
				$display("Input command command: %d Response: Sucessful response ",incommand);
				break;
			end
			if(resp[port] == 10) begin
				$display("Input command command:%d Response: Underflow, overflow or invalid ",incommand);
				break;
			end
			if(resp[port] == 11) begin
				$display("Input command command:%d Response: Unused response value obtained",incommand);
				break;
			end
			if(resp[port] === 2'bxx) begin
				$display("Input command command:%d Response: Error: xx response obtained",incommand);
				break;
			end
			
		end
		
		if(resp[port] == 00) begin
			$display("Input command command:%d Response: NO RESPONSE",incommand);
		end	
	endtask


	// Function for calculate the answer of a given a command
	task calculate(int port, logic[0:3] command, logic[0:31] operand1, logic[0:31] operand2);
		@(posedge c_clk);
		cmd[port] = command;
		data_in[port] = operand1;
		@(posedge c_clk);
		data_in[port] = operand2;
		@(posedge c_clk);
	endtask

	task calculateParrellel(logic[0:3] command, logic[0:31] operand1, logic[0:31] operand2);
		@(posedge c_clk);
		cmd[3] <= command;
		data_in[3] <= operand1;
		cmd[2] <= command;
		data_in[2] <= operand1;
		cmd[1] <= command;
		data_in[1] <= operand1;
		cmd[0] <= command;
		data_in[0] <= operand1;
		@(posedge c_clk);
		data_in[3] <= operand2;
		data_in[2] <= operand2;
		data_in[1] <= operand2;
		data_in[0] <= operand2;
		@(posedge c_clk);
	endtask


	task responseTimes();
		integer i;                
		int queue[$]; 
		int found1 =0;
		int found2 = 0;
		int found3 =0;
		int found4 = 0;			//the founds are a workaround atm

		for(i = 0; i < 500; i++) begin
			@(negedge c_clk);

			if(resp[0] == 01 && found1 == 0) begin
				queue.push_back(1);
				found1 = 1;
			end
			if(resp[1] == 01 && found2 == 0) begin
				queue.push_back(2);
				found2 = 1;
			end
			if(resp[2] == 01 && found3 == 0) begin
				queue.push_back(3);
				found3 = 1;
			end
			if(resp[3] == 01 && found4 == 0) begin
				queue.push_back(4);
				found4 = 1;
			end
		end
		$display("Response sequence was: ");
		foreach(queue[i])$display(" %0d",queue[i]);
	endtask

	// Function to compare the actual value with the expected one
	task compare_expected_value(int port, logic[0:31] expected_data,logic[0:3] incommand);
		integer i;		

		for(i = 0; i < 40; i++) begin
				@(negedge c_clk);
			
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
			check_for_response(port,incommand);
		end
	endtask

	task resetAll(cycleOnReset);
		resetDUT(cycleOnReset);
		resetDUT(cycleOnReset);
	endtask

	// Function to reset the DUT	
	// I commented out the display because it was getting too much
	task resetDUT(int cycleStart);

		if(cycleStart == 1) begin
			for(int i = 1; i < 5; i++) begin
				cycle_commands(i,0);
			end
		end
		resetInputs();
		reset = 7'b1111111;
			
		repeat(7) @(posedge c_clk);

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
			out = op1 << op2;
		end
		if(command == 0110) begin
			out = op1 >> op2;
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
			$display("Port %0d", i);
			$display("cmd  %b", cmd[i]);
			$display("data1 %b", data_in[i]);
			$display("resp1 %b",resp[i]);
			$display("dataout1 %b",data_out[i]);
		end
	endtask;
		
endmodule
