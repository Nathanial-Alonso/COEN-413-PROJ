//Project One Test Bench
//Ewan McNeil 40021787
//Nate
//Gabe




`default_nettype none
module testbench;	
  
	//setup the varibles
	
	reg c_clk;
	logic [1:7] reset;

	//inputs

	logic [0:3] req1_cmd_in;
	logic [0:31] req1_data_in;

	logic [0:3] req2_cmd_in;
	logic [0:31] req2_data_in;

	logic [0:3] req3_cmd_in;
	logic [0:31] req3_data_in;

	logic [0:3] req4_cmd_in;
	logic [0:31] req4_data_in;

	//outputs

	logic [0:1] out_resp1;
	logic [0:31] out_data1;

	logic [0:1] out_resp2;
	logic [0:31] out_data2;

	logic [0:1] out_resp3;
	logic [0:31] out_data3;

	logic [0:1] out_resp4;
	logic [0:31] out_data4;

	
	

	//these are the data types questa sim says im missing

	logic scan_out;
	logic a_clk;
	logic b_clk;
	logic[0:3] error_found;
	logic scan_in;

  	//local testing varibles
	integer error;
	logic [31:0] data_out;
	



	
	
	
	//instantiate the Device under Test the Calculator


	calc1_top calc1_top(

	.c_clk(c_clk),
	.reset(reset),

	//inputs

	.req1_cmd_in(req1_cmd_in),
	.req1_data_in(req1_data_in),

	.req2_cmd_in(req2_cmd_in),
	.req2_data_in(req2_data_in),

	.req3_cmd_in(req3_cmd_in),
	.req3_data_in(req3_data_in),

	.req4_cmd_in(req4_cmd_in),
	.req4_data_in(req4_data_in),

	//outputs

	.out_resp1(out_resp1),
	.out_data1(out_data1),

	.out_resp2(out_resp2),
	.out_data2(out_data2),

	.out_resp3(out_resp3),
	.out_data3(out_data3),

	.out_resp4(out_resp4),
	.out_data4(out_data4),


	//questa sim says we need these ports declared
	.scan_out(scan_out),
	.a_clk(a_clk),
	.b_clk(b_clk),
	.error_found(error_found),
	.scan_in(scan_in)

	 );

	
	//array for ports
	logic [1:0] ports [4] = '{00,01,10,11};




	//Code for the Clock
	initial begin 
	   c_clk = 0;
	   forever #50 c_clk = !c_clk;
	  end



//BASIC FUNCTION TESTS
	initial begin
		

		//Test num 1.1 check each of the four ports with command and reponse protocal
		integer i;
		
		resetDUT();

		//trying addition
		for(i = 0; i <$size(ports); i++) begin	
			calculate(ports[i],0001,32'h00000001,32'h00000001);
			compare_expected_value(ports[i],32'h00000002);
		end


		//trying subtraction
		for(i = 0; i <$size(ports); i++) begin	
			calculate(ports[i],0001,32'h00000011,32'h00000005);
			compare_expected_value(ports[i],32'h00000005);
		end





		//displayIO();
	end








///
//Functions for a modular test bench
////




//Function for writing a command
task calculate(logic[1:0] port, logic[0:3] command, logic[31:0] operand1, logic[31:0] operand2);
	
	@(posedge c_clk);

		//case statement isnt working for multiline
		if(port == 00)begin
			//$display("checking inputs");
			req1_cmd_in <= command;
			req1_data_in <= operand1;
			@(posedge c_clk);
			req1_data_in <= operand2;
			//$display(command);
			//$display(operand1);
			//$display(req1_cmd_in);
			//$display(req1_data_in);

			end
		if(port == 01)begin
			req2_cmd_in <= command;
			req2_data_in <= operand1;
			@(posedge c_clk);
			req2_data_in <= operand2;
		end
		  
		if(port == 10)begin
			req3_cmd_in <= command;
			req3_data_in <= operand1;
			@(posedge c_clk);
			req3_data_in <= operand2;
                end
		
		if(port == 11)begin
			req3_cmd_in <= command;
			req3_data_in <= operand1;
			@(posedge c_clk);
			req3_data_in <= operand2;
		end


endtask





task compare_expected_value(logic[0:1] port, [8:0] expected_data);
	  @(posedge c_clk);
	  case(port)
		  2'b00:
			data_out = out_data1;			
		  2'b01:
			data_out = out_data2;	
		  2'b10:
			data_out = out_data3;	
                  2'b11:
			data_out = out_data4;
	 endcase	
	 if(expected_data != data_out)
	   begin
	    error = error +1;
	     $display("data out should equal %b but the read result is %b ",expected_data, data_out);
	  end
	  else
	    begin
	      $display("read result on port %b is as expected 	%b ", port, data_out);
	      end
	      
	 endtask

			


	
task resetDUT();
	reset = 8'b111111;
	$display("reseting");	
	 @(posedge c_clk);
	 @(posedge c_clk);
	 @(posedge c_clk);
	 @(posedge c_clk);
	 @(posedge c_clk);
	 @(posedge c_clk);
	 @(posedge c_clk);
 	 @(posedge c_clk);
	 @(posedge c_clk);
	reset = 8'b00000000;
endtask

task displayIO();
	$display(c_clk);
	$display(reset);

	//inputs

	$display(req1_cmd_in);
	$display( req1_data_in);

	$display(req2_cmd_in);
	$display(req2_data_in);

	$display( req3_cmd_in);
	$display(req3_data_in);

	$display(req4_cmd_in);
	$display(req4_data_in);

	//outputs

	$display(out_resp1);
	$display(out_data1);

	$display(out_resp2);
	$display( out_data2);

	$display(out_resp3);
	$display(out_data3);

	$display(out_resp4);
	$display(out_data4);

endtask;
	
	

	
endmodule