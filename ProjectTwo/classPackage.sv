


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
			port = $random;
			cmd = $random;
			data_in = $random;
			tag_in = $random;
			$display("new transaction");
		endfunction


		function displayInputs();
			 $display("cmd: %b, data_in: %b, tag_in: %b", cmd,data_in,tag_in);
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

			//fixt reset function
			//IF.cb.req1_cmd_in <= 4b'0000;
		endfunction;


		//becuase we might want to transmit more than one at once
		//function transmitPackets(input Transaction trans[]);
		///		for(int i = 0; i < $size(trans); i++) begin
		//			IF.cb.req1_cmd_in[trans[i].port] <= trans[i].cmd;
		//			IF.cb.req1_cmd_in[trans[i].port] <= trans[i].data_in;
		//			IF.cb.req1_cmd_in[trans[i].port] <= trans[i].tag_in;
	///			end
	//	endfunction;

	function transmitOnePacket(input Transaction trans);

			$display("transmitting a packet");
			IF.cb.req1_cmd_in <= trans.cmd;
			IF.cb.req1_data_in <= trans.data_in;
			IF.cb.req1_tag_in <= trans.tag_in;
		endfunction;

	endclass


	//monitor

		class Monitor;
			virtual dut_IF IF;

			function displayInterface();

				for(int i = 0; i <5; i ++)begin
				
					$display($realtime);
					$display("c_clk: %b", IF.c_clk);
					$display("reset: %b", IF.reset);

					//TODO add tag

					$display("Port %0d", 1);
					$display("cmd  %b", IF.cb.req1_cmd_in);
					$display("data1 %b", IF.cb.req1_data_in);
					$display("resp1 %b",IF.cb.out_resp1);
					$display("dataout1 %b",IF.cb.out_data1);

					$display("Port %0d", 2);
					$display("cmd  %b", IF.cb.req2_cmd_in);
					$display("data1 %b", IF.cb.req2_data_in);
					$display("resp1 %b",IF.cb.out_resp2);
					$display("dataout1 %b",IF.cb.out_data2);


					$display("Port %0d", 3);
					$display("cmd  %b", IF.cb.req3_cmd_in);
					$display("data1 %b", IF.cb.req3_data_in);
					$display("resp1 %b",IF.cb.out_resp3);
					$display("dataout1 %b",IF.cb.out_data3);


					$display("Port %0d", 4);
					$display("cmd  %b", IF.cb.req4_cmd_in);
					$display("data1 %b", IF.cb.req4_data_in);
					$display("resp1 %b",IF.cb.out_resp4);
					$display("dataout1 %b",IF.cb.out_data4);
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
		
