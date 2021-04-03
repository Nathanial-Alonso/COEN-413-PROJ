program testBench(dut_IF.TEST IF);
 import classes::*;
 //Generator generator;
 //Agent agent;
 //Scoreboard scoreboard;
 //Checker checker;
 Driver driver;
 Monitor monitor;


    Transaction tarray[50];
    initial begin
        driver = new();
        driver.IF = IF;

        monitor = new();
        monitor.IF = IF;

        reset();
        //just to test the driver and the display 
        generator();
        for(int i = 0; i < 50; i++)begin
            tarray[i].displayInputs();
        end

        foreach(tarray[i])begin
            driver.transmitOnePacket(tarray[i]);
        	@(IF.cb);
       		@(IF.cb);
        	@(IF.cb);
        	@(IF.cb);
            monitor.displayInterface();
	@(IF.cb);s
	 reset();
            
        end
    end
    

    //TODO move into class and move randomization into it
    task generator();
        for(int i = 0; i < 50; i++)begin
            $display("making new object");
            tarray[i] = new();
	    tarray[i].randomize();
        end
    endtask 
        

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





        @(IF.cb);
        @(IF.cb);
        @(IF.cb);
        @(IF.cb);
        @(IF.cb);
        @(IF.cb);
        @(IF.cb);
        @(IF.cb);
        @(IF.cb);

        IF.reset = 0; 
    endtask

endprogram
