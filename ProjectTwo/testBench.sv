program testBench(dut_IF.TEST IF);
 import classes::*;
 Generator generator;
 //Agent agent;
 //Scoreboard scoreboard;
 //Checker checker;
 Driver driver;
 Monitor monitor;

DriverSingle driverS;

 mailbox driverMB;
 mailbox scoreboardMB; 
 mailbox driverSingleMB;
    initial begin

	driverMB = new();
	scoreboardMB = new();
	driverSingleMB = new(1);

	generator = new();
	generator.driverMB = driverMB;
	generator.driverSingleMB = driverSingleMB;
	
        driver = new();
        driver.IF = IF;
	driver.driverMB = driverMB;

	driverS = new();
	driverS.IF = IF;
	driverS.driverSingleMB = driverSingleMB;

        monitor = new();
	monitor.IF = IF;
       
	

        reset();
        //just to test the driver and the display

	 fork
        monitor.run();
	driverS.run();
	generator.run();


    	join 

	$display("end of program");
    end


 
    

   
        

    task reset();
        IF.reset = 1; 
        IF.cb.req1_cmd_in <= 0000;
        IF.cb.req2_cmd_in <= 0000;
        IF.cb.req3_cmd_in <= 0000;
        IF.cb.req4_cmd_in <= 0000;
        
        IF.cb.req1_data_in <= 00000000000000000000000000000000;
        IF.cb.req2_data_in <= 00000000000000000000000000000000;
        IF.cb.req3_data_in <= 00000000000000000000000000000000;
        IF.cb.req4_data_in <= 00000000000000000000000000000000;

        IF.cb.req1_tag_in <= 00;
        IF.cb.req2_tag_in <= 00;
        IF.cb.req3_tag_in <= 00;
        IF.cb.req4_tag_in <= 00;





        @(IF.c_clk);
        @(IF.c_clk);
        @(IF.c_clk);
     

        IF.reset = 0; 

	@(IF.c_clk);
   	@(IF.c_clk);
	@(IF.c_clk);
   	@(IF.c_clk);	
    endtask

endprogram
