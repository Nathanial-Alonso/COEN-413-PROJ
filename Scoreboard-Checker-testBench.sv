program testBench(dut_IF.TEST IF);
 import classes::*;
 Generator generator;
//Agent agent;
Scoreboard scoreboard;
Checker checkerOB;
//Driver driver;
Monitor monitor;

DriverSingle driverS;

 mailbox driverMB;
 mailbox scoreboardMB; 
 mailbox driverSingleMB;
 mailbox SBtocheckerMB;
 mailbox MNtocheckerMB;
 
    initial begin

	driverMB = new();
	scoreboardMB = new();
	SBtocheckerMB = new();
	MNtocheckerMB = new();
	driverSingleMB = new();
	

	generator = new();
	generator.driverMB = driverMB;
	generator.driverSingleMB = driverSingleMB;
	generator.scoreboardMB = scoreboardMB;

	checkerOB = new();
	checkerOB.SBtocheckerMB = SBtocheckerMB;
	checkerOB.MNtocheckerMB = MNtocheckerMB;

	
        //driver = new();
       //driver.IF = IF;
	//driver.driverMB = driverMB;

	driverS = new();
	driverS.IF = IF;
	driverS.driverSingleMB = driverSingleMB;

        monitor = new();
        monitor.IF = IF;
	monitor.MNtocheckerMB = MNtocheckerMB;

	//going to use the same mailbox as the driver for now

	scoreboard = new();
	scoreboard.scoreboardMB = scoreboardMB;
	scoreboard.SBtocheckerMB = SBtocheckerMB;

	
	

        reset();
        //just to test the driver and the display

	 fork
         monitor.run();
	driverS.run();
	generator.run();
	scoreboard.run();
	checkerOB.run();

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
