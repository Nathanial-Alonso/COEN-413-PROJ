program test(dut_if IF);
 import classes::*;
 //Generator generator;
 //Agent agent;
 //Scoreboard scoreboard;
 //Checker checker;
 Driver driver;
 Monitor monitor;


    Transaction tarray[10];



    initial begin
        
        generator();

        foreach (tarray[i]) begin
        $display("cmd: %b, data_in: %b, tag_in: %b", tarray[i].cmd,tarray[i].data_in,tarray[i].tag_in);

        end


    end

    task generator();
        foreach (tarray[i]) begin
            tarray[i] = new();
        end
    endtask 
        

endprogram
