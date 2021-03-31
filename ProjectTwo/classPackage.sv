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
	///Command block
	///

	//driver class
	class Driver;

		virtual dut_IF IF;

		function reset();
			IF.reset = 7'b1111111;
			for(int i = 0; i< 7; i++)begin
				//unsure how to wait for 7 cycles with cb
			end
			for(int i = 0; i < $size(IF.cmd); i++) begin
				IF.cb.cmd[i] = 0000;
				IF.cb.data_in[i] = 32'h00000000;
			end

		endfunction;

		function transmitPackets(input Transaction trans[]);
				for(int i = 0; i < $size(trans); i++) begin
					IF.cb.cmd[trans[i].port] = trans[i].cmd;
					IF.cb.data_in[trans[i].port] = trans[i].data_in;
					IF.cb.tag_in[trans[i].port] = trans[i].tag_in;
				end
		endfunction;

	endclass


	//monitor

		class Monitor;
			virtual dut_IF IF;

			function displayInterface();

				$display("c_clk: %b", IF.clk);
				$display("reset: %b", IF.reset);

				//TODO add tag

				for(int i = 0; i < $size(IF.cmd); i++) begin
					$display("Port %0d", i);
					$display("cmd  %b", IF.cmd[i]);
					$display("data1 %b", IF.data_in[i]);
					$display("resp1 %b",IF.resp[i]);
					$display("dataout1 %b",IF.data_out[i]);
				end

		endfunction

		endclass


	///
	///Functional block
	///
	
	//agent class
		//*

		//class Agent;
		//endclass

	//scoreboard


		//class Scoreboard;
		//endclass


	//checker 

		
		//class Checker;
		//endclass


	
	///
	///Scenario block
	///


	//generator


		//class Generator;
		//endclass
	
endpackage
		
