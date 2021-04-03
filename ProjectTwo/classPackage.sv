package classes;
	//transaction Class
	//is this for one port or for multiple
	//I think just for one
	class Transaction;
		static int errorCount = 0;
		static int posCount = 0;
		rand bit [0:1] port;		//used to see which port it is on
		rand bit [0:3] cmd;
		rand bit [0:31] data_in_1;
		rand bit [0:31] data_in_2;
    		rand bit [0:1] tag_in;

		//outputs of device 
		logic [0:1] resp;
		logic [0:31] data_out;
		logic [0:1] tag_out;
		
		//0001 add
		//0010 sub
		constraint commandValid {((cmd == 1) || (cmd == 2) || (cmd == 5) || (cmd ==6));}
		constraint portValid{((port == 0) || (port == 1) || (port == 2) || (port ==3));}
		constraint tagValid{((tag_in == 1) || (tag_in == 2) || (tag_in ==3));}
		constraint dataOne{ data_in_1 > 1; data_in_1 < 100;}
		constraint dataTwo{ data_in_2 > 1; data_in_2 < 100;}

		//TODO make the random values be made by the generator
		function new();
			$display("new transaction");
		endfunction


		function displayInputs();
			 $display("cmd: %b, data_in_1: %b, data_in_2: %b, tag_in: %b", cmd,data_in_1,data_in_2,tag_in);
		endfunction

		//added a deep copy function
		function Transaction copy();
			copy = new();
			copy.cmd = cmd;
			copy.data_in_1 = data_in_1;
			copy.data_in_2 = data_in_2;
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

		//has to be task to drive values
		task transmitOnePacket(input Transaction trans);

				$display("transmitting a packet");
				$display("values: Cmd: %b , Data1%b, Data2%b, tag%b", trans.cmd,trans.data_in_1,trans.data_in_2,trans.tag_in);
				$display("on port", trans.port);

				if(trans.port == 00)begin
					$display("TRANSMIT PORT ZERO");
					@(IF.cb);
					IF.cb.req1_cmd_in <= trans.cmd;
					IF.cb.req1_tag_in <= trans.tag_in;
					IF.cb.req1_data_in <= trans.data_in_1;
					@(IF.cb);
					IF.cb.req1_data_in <= trans.data_in_2;
				end

				if(trans.port == 01)begin
					@(IF.cb);
					IF.cb.req2_cmd_in <= trans.cmd;
					IF.cb.req2_tag_in <= trans.tag_in;
					IF.cb.req2_data_in <= trans.data_in_1;
					@(IF.cb);
					IF.cb.req2_data_in <= trans.data_in_2;
				end

				if(trans.port ==10)begin
					@(IF.cb);
					IF.cb.req3_cmd_in <= trans.cmd;
					IF.cb.req3_tag_in <= trans.tag_in;
					IF.cb.req3_data_in <= trans.data_in_1;
					@(IF.cb);
					IF.cb.req3_data_in <= trans.data_in_2;
				end

				if(trans.port == 11)begin
					@(IF.cb);
					IF.cb.req4_cmd_in <= trans.cmd;
					IF.cb.req4_tag_in <= trans.tag_in;
					IF.cb.req4_data_in <= trans.data_in_1;
					@(IF.cb);
					IF.cb.req4_data_in <= trans.data_in_2;
				end

		endtask;



	endclass


	//monitor

		class Monitor;
			virtual dut_IF IF;

			function displayInterface();

					//TODO add tag
					
					$display("Port %0d", 1);
					$display("Resp1 %b",IF.cb.out_resp1);
					$display("Dataout1 %b",IF.cb.out_data1);
					$display("tag1 %b", IF.cb.out_tag1);

					$display("Port %0d", 2);
					$display("resp2 %b",IF.cb.out_resp2);
					$display("dataout2 %b",IF.cb.out_data2);
					$display("tag2 %b", IF.cb.out_tag2);

					
					$display("Port %0d", 3);
					$display("resp1 %b",IF.cb.out_resp3);
					$display("dataout1 %b",IF.cb.out_data3);
					$display("tag3 %b", IF.cb.out_tag3);

					$display("Port %0d", 4);
					$display("resp1 %b",IF.cb.out_resp4);
					$display("dataout1 %b",IF.cb.out_data4);
					$display("tag4 %b", IF.cb.out_tag4);
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
		
