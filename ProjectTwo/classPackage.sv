package classes;
	//transaction Class
	//is this for one port or for multiple
	//I think just for one
	class Transaction;
		static int errorCount = 0;
		static int posCount = 0;
		int port;		//used to see which port it is on
		logic [0:3] cmd;
		logic [0:31] data_in;
    		logic [0:1] tag_in;

		//outputs of device 
		logic [0:1] resp;
		logic [0:31] data_out;
		logic [0:1] tag_out;


		//TODO make the random values be made by the generator
		function new();
			int port = $random();
			logic [0:3] cmd = $random();
			logic [0:31] data_in =$random();
			logic [0:1] tag_in = $random();
		endfunction

		//added a deep copy function
		function Transaction copy();
			copy = new();
			copy.cmd = cmd;
			copy.data_in = data_in;
    			copy.tag_in = tag_in;

			//outputs of device 
			copy.resp = resp;
			copy.data_out = data_out;
			copy.tag_out = tag_out;

		endfunction
	endclass
	

	///
	/// Command block
	///

	// Driver
	class Driver;
		function reset();
			IF.reset = 7'b1111111;
			
			repeat(7) @(posedge IF.clk);

			IF.reset = 7'b0000000;


			for(int i = 0; i < $size(IF.cmd); i++) begin
				IF.cmd[i] = 0000;
				IF.data_in[i] = 32'h00000000;
			end
		endfunction;

		function transmitPackets(input Transaction trans[]);
			@(posedge IF.clk);
				foreach(trans[i])
					IF.cmd[i] = trans.cmd;
					IF.data_in[i] = trans.data_in;
					IF.tag_in[i] = trans.tag_in;
		endfunction;

	endclass


	// Monitor
	class Monitor;

	endclass

	///
	/// Functional blocks
	///
	
	// Agent
	class Agent;

	endclass

	// Scoreboard
	class Scoreboard;

	endclass


	// Checker 
	class Checker;

	endclass

	///
	/// Scenario block
	///


	// Generator
	class Generator;
		
	endclass
endpackage
