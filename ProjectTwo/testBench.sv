program testBench(dut_IF.TEST IF);
 import classes::*;
 //Generator generator;
 //Agent agent;
 //Scoreboard scoreboard;
 //Checker checker;
 Driver driver;
 Monitor monitor;


    Transaction tarray[10];
    initial begin
        driver = new();
        driver.IF = IF;

        monitor = new();
        monitor.IF = IF;

        
        //just to test the driver and the display 
        generator();
        for(int i = 0; i < 10; i++)begin
            tarray[i].displayInputs();
        end


        
        driver.transmitOnePacket(tarray[0]);

        monitor.displayInterface();


    end
    

    //TODO move into class and move randomization into it
    task generator();
        for(int i = 0; i < 10; i++)begin
            $display("making new object");
            tarray[i] = new();
        end
    endtask 
        

endprogram
