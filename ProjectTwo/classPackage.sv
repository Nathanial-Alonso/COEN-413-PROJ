package classes;
	//transaction Class
	//is this for one port or for multiple
	//I think just for one

	class Transaction;
		static int errorCount = 0;
		static int posCount = 0;
		//rand bit [0:1] port;		//used to see which port it is on
		logic [0:1] port;
		rand bit [0:3] cmd;
		rand bit [0:31] data_in_1;
		rand bit [0:31] data_in_2;
    		logic [0:1] tag_in;

		//outputs of device 
		logic [0:1] resp;
		logic [0:31] data_out;
		logic [0:1] tag_out;
		
		//0001 add, 0010 sub, 0101 shift left, 0110 shift right
		//constraint commandValid {((cmd == 1) || (cmd == 2) || (cmd == 5) || (cmd ==6));}
		constraint commandValid {(cmd == 1);}
		//constraint portValid{((port == 0) || (port == 1) || (port == 2) || (port ==3));}
		constraint tagValid{((tag_in == 0) || (tag_in == 1) || (tag_in == 2)  ||(tag_in == 3));}
		constraint dataOne{ data_in_1 > 1; data_in_1 < 100;}
		constraint dataTwo{ data_in_2 > 1; data_in_2 < 100;}

		//TODO make the random values be made by the generator
		function new(logic [0:1] inPort, logic [0:1] inTag);
			port = inPort;
			tag_in = inTag;
			//$display("New transaction on port: %b with tag: %b", port, tag_in);
		endfunction


		function displayInputs();
			 $display("T: %0t [Transaction] port: %b cmd: %b data_in_1: %0d data_in_2: %0d tag_in: %b", $time, port, cmd, data_in_1, data_in_2, tag_in);
		endfunction
	endclass
		
	//driver class
	class DriverSingle;
		virtual dut_IF IF;
		mailbox driverSingleMB;
		event drv_done;
		task run();
			$display("T: %0t [Driver] starting...", $time);

			forever begin
				Transaction trans;

				driverSingleMB.get(trans);
				$display("T: %0t [Driver] receiving transaction from Generator", $time);

				$display("T: %0t [Driver] port: %b cmd: %b Data1: %0d Data2: %0d Tag: %b", $time, trans.port, trans.cmd, trans.data_in_1, trans.data_in_2, trans.tag_in);

				if(trans.port == 00) begin
					IF.cb.req1_cmd_in <= trans.cmd;
					IF.cb.req1_tag_in <= trans.tag_in;
					IF.cb.req1_data_in <= trans.data_in_1;
					@(IF.cb);
					IF.cb.req1_data_in <= trans.data_in_2;
				end

				if(trans.port == 01) begin
					IF.cb.req2_cmd_in <= trans.cmd;
					IF.cb.req2_tag_in <= trans.tag_in;
					IF.cb.req2_data_in <= trans.data_in_1;
					@(IF.cb);
					IF.cb.req2_data_in <= trans.data_in_2;
				end

				if(trans.port ==10) begin
					IF.cb.req3_cmd_in <= trans.cmd;
					IF.cb.req3_tag_in <= trans.tag_in;
					IF.cb.req3_data_in <= trans.data_in_1;
					@(IF.cb);
					IF.cb.req3_data_in <= trans.data_in_2;
				end

				if(trans.port == 11) begin
					IF.cb.req4_cmd_in <= trans.cmd;
					IF.cb.req4_tag_in <= trans.tag_in;
					IF.cb.req4_data_in <= trans.data_in_1;
					@(IF.cb);
					IF.cb.req4_data_in <= trans.data_in_2;
				end

				@(IF.c_clk);
				@(IF.c_clk);
				@(IF.c_clk);
				@(IF.c_clk);

				@(posedge IF.c_clk);
					->drv_done;
			end
		endtask
	endclass

	///
	///Command block
	///

	//monitor
	//four threads looking at each of the input/ output ports 
	//but multiple commands could be running so maybe fork a new internally?
	class Monitor;
		//link to the interface

		virtual dut_IF IF;
			
		//TODO 
		mailbox scoreboardMail;

		task run();
			$display("T: %0t [Monitor] starting...", $time);
			
			fork
				watchInputOne();
				watchInputTwo();
				//watchOutputOne();
				//watchOutputTwo();
				//watchOutputThree();
				//watchOutputFour();
		 	join
		endtask
			
		
		//This concept of watching the inputs maybe isnt needed
		task watchInputOne();
			forever begin
				Transaction fresh;

		   		@(IF.cb.req1_data_in);
		   		
				//make a new transaction object
				$display("T: %0t [Monitor] seeing new transaction on port 0", $time);
				fresh = new(2'b00,IF.cb.req1_tag_in);		//port is 00 and pass new tag in
				fresh.cmd = IF.cb.req1_cmd_in;
				fresh.data_in_1 = IF.cb.req1_data_in;
	
	
		  		@(IF.cb.req1_data_in)
				fresh.data_in_2 = IF.cb.req1_data_in;
				fresh.displayInputs();

		  		fork
					watchOutputOne(fresh);
		  		join_none
		  		//join none so the watchinputoOne is resarted
	         	end


		endtask

		task watchInputTwo();
			forever begin
				Transaction fresh;

		   		@(IF.cb.req2_data_in);
		   		
				//make a new transaction object
				$display("T: %0t [Monitor] seeing new transaction on port 1", $time);
				fresh = new(2'b01,IF.cb.req2_tag_in);		//port is 00 and pass new tag in
				fresh.cmd = IF.cb.req2_cmd_in;
				fresh.data_in_1 = IF.cb.req2_data_in;
	
	
		  		@(IF.cb.req2_data_in)
				fresh.data_in_2 = IF.cb.req2_data_in;
				fresh.displayInputs();

		  		fork
					watchOutputTwo(fresh);
		  		join_none
		  		//join none so the watchinputoOne is resarted
	         	end
		endtask

		task watchOutputOne(Transaction fresh);
			//task watchOutputOne();
		
			$display("T: %0t [Monitor] waiting for response on port 0", $time);

			
			//TODO wait for equal tag
			@(IF.cb.out_resp1)
				fresh = new(2'b00,IF.req1_tag_in);
				fresh.resp = IF.out_resp1;
				fresh.data_out = IF.out_data1;
				fresh.tag_out = IF.out_tag1;
			
			$display("T: %0t [Monitor] received response on port 0", $time);
			$display("T: %0t [Monitor] Resp: %b Data: %0d Tag: %b", $time, fresh.resp, fresh.data_out, fresh.tag_out);

			//TODO
			//then send over to the scoreboard
		endtask

		task watchOutputTwo(Transaction fresh);
			//task watchOutputTwo();
		
			$display("T: %0t [Monitor] waiting for response on port 1", $time);

			//TODO wait for equal tag
			@(IF.cb.out_resp2)
				fresh = new(2'b00,IF.req2_tag_in);
				fresh.resp = IF.out_resp2;
				fresh.data_out = IF.out_data2;
				fresh.tag_out = IF.out_tag2;
			
			$display("T: %0t [Monitor] received response on port 0", $time);
			$display("T: %0t [Monitor] Resp: %b Data: %0d Tag: %b", $time, fresh.resp, fresh.data_out, fresh.tag_out);

			//TODO
			//then send over to the scoreboard
		endtask

		task watchOutputThree();
		Transaction fresh;
		$display("Monitor: waiting for response on port 3");

		forever begin
			@(IF.out_resp3)
				fresh = new(2'b10,IF.req3_tag_in);
				fresh.resp = IF.out_resp3;
				fresh.data_out = IF.out_data3;
				fresh.tag_out = IF.out_tag3;
			
			
			$display("Monitor Received response on port 3");
			$display("Resp: %b", fresh.resp);
			$display("Data: %b", fresh.data_out);
			$display("Tag: %b", fresh.tag_out);

		//TODO
		//then send over to the scoreboard
		
	
		end
		endtask


		task watchOutputFour();
		Transaction fresh;
		$display("Monitor: waiting for response on port 3");

		forever begin
			@(IF.out_resp4)
				fresh = new(2'b11,IF.req4_tag_in);
				fresh.resp = IF.out_resp4;
				fresh.data_out = IF.out_data4;
				fresh.tag_out = IF.out_tag4;
			
			
			$display("Monitor Received response on port 4");
			$display("Resp: %b", fresh.resp);
			$display("Data: %b", fresh.data_out);
			$display("Tag: %b", fresh.tag_out);

		//TODO
		//then send over to the scoreboard
		
		
		end
		endtask
			
					
		
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
		
		//maybe we should do both, bundles and signel ones
		//generator generates bundles of transactions 
		class Generator;
			mailbox driverSingleMB;
			event drv_done;
			Transaction trans;
			
			task run();
				for(int i = 0; i < 2; i++)begin
					$display("T: %0t [Generator] making a new object", $time);
				   	trans = new(2'b01,2'b00);
				    	trans.randomize();
				    	trans.displayInputs();
				    	driverSingleMB.put(trans);
					@(drv_done);
				  end

				$display("T: %0t [Generator] done generation of transactions", $time);
			endtask
		endclass
endpackage
