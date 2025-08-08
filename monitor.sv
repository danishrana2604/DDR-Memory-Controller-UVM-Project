class monitor extends uvm_monitor;
  
  seq_txn txn;
  mon_delay pkt_dly;
  mon_compare pkt_cmp;

bit [2:0] curr_cmd, prev_cmd, first_cmd;
bit [3:0] delay;
bit [31:0] curr_time, prev_time;
bit [7:0] clk_tp;
bit [2:0] posedge_count;
bit [5:0] first_edge_time;
bit [5:0] second_edge_time;
int file;

  `uvm_component_utils(monitor);

bit [31:0] mem [15:0][4095:0];
virtual mem_intf fmem;
virtual ext_intf fext;

cover_gp_item i;
coverage c;


 function new(string name="",uvm_component parent);
	super.new(name,parent);
  //      sample_address = new();
  endfunction

  function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	txn=seq_txn::type_id::create("txn");
	i=cover_gp_item::type_id::create("i");
	pkt_dly=mon_delay::type_id::create("pkt_dly");
	pkt_cmp=mon_compare::type_id::create("pkt_cmp");
	c = coverage::type_id::create("c",this);
	if(!uvm_config_db #(virtual ext_intf)::get(this,"","dut_intf",fext))
	`uvm_fatal("FATAL MSG","virtual intf not received properly");

	if(!uvm_config_db #(virtual mem_intf)::get(this,"","mem_intf",fmem))
	`uvm_fatal("FATAL MSG","virtual intf not received properly");

  endfunction

//========= TASK RUN ===========//
task configure_phase(uvm_phase phase);
file=$fopen("transaction_logger.txt");
$fdisplay(file,"adress		data");
endtask

task main_phase(uvm_phase phase);
  fork   
    forever @( posedge fmem.clk or posedge fmem.rst_n)
	begin
		calculate_clk_tp();
	end
	  
    forever @( posedge fmem.clk or posedge fmem.rst_n)
	begin
		if(fmem.rst_n==1)
	   	begin
			reset_mem();
	  	end
	end   

    forever @( negedge fmem.clk)
    begin
		if(fmem.cs_n==0)
		begin
	      	timing_check;
	 		c.cmd_coverage.sample(i);
        end
         fork
             rd_wr();
	 	join_none
	end
	      	   
  join_none
endtask

task shutdown_phase(uvm_phase phase);
	$fclose(file);
endtask

//---------------------------
	task rd_wr();
	  if(fmem.cmd==2)
	     begin
	        do_write;
	     end
	  else if(fmem.cmd==1)
	      compare();
	  endtask
//---------------------------

//============calculate_clk_time======//
task calculate_clk_tp();
   while(posedge_count <2)
    begin
      @(posedge fmem.clk)
      	begin
		if(posedge_count==0)
       	 first_edge_time=$time;

		else if(posedge_count ==1)
	   	begin
			second_edge_time=$time;
			$fdisplay(file,"adress		data");
			$display($time,"firstedge =%d second edge=%d",first_edge_time,second_edge_time);
	   	end
		posedge_count++;
      end
   end
  clk_tp = (second_edge_time - first_edge_time);
endtask  
//===========resest mem===========//
task reset_mem();

foreach(mem[i,j])
mem[i][j]=0;
first_cmd=0;
delay=0;

endtask
//==========VIRTUAL MEMORY=========//  
task do_write;

bit [3:0] ra;
bit [11:0] ca;
ra=fmem.ra;
ca=fmem.ca;
mem[ra][ca] = fmem.dq;
$fdisplay(file,"%h%h		%d",ra,ca,mem[ra][ca]);

endtask

//========= TASK COMPARE =========//
task compare;

//bit [31:0] data_compare;
bit [3:0] ra;
bit [11:0] ca;
ra=fmem.ra;
ca=fmem.ca;
pkt_cmp.ref_data= mem[ra][ca];

  fork
  begin
  counter(2);
  pkt_cmp.actual_data=fmem.dq;
  if(pkt_cmp.ref_data==fmem.dq)
   begin  `uvm_info("",$sformatf("READ DATA MATCH :\n%s", pkt_cmp.sprint()),UVM_LOW); end
  else
     begin `uvm_error("",$sformatf("READ DATA DIFFERENT :\n%s", pkt_cmp.sprint())); end
  end
  join_none
endtask

//=======:w
//=== check time bwteen two commands ==========//
task timing_check;

  if(first_cmd==0 && fmem.cmd != 0)
   begin
   i.prev_cmd=4;
   pkt_dly.prev_cmd=4;
   prev_cmd=4;
   prev_time=$time;
   curr_cmd=fmem.cmd;
   i.curr_cmd=curr_cmd;
   curr_time=$time;
   first_cmd++;
   end

   else if(fmem.cmd != 0)
      begin
      i.prev_cmd=prev_cmd;
      curr_cmd=fmem.cmd;
      i.curr_cmd=curr_cmd;
      pkt_dly.curr_cmd=curr_cmd;
      curr_time=$time;
      check_time();
      end
endtask

task check_time();
   delay = (curr_time-prev_time)/clk_tp;
  // delay = delay - clk_tp;
  
  delay = delay-1;
   pkt_dly.delay=delay;
case (prev_cmd)
1:
   begin
        if(curr_cmd==1)	
         begin
           if(delay!=2)
           `uvm_error("monitor error","delay after read to read fail");
         end
        else if(curr_cmd==2) 
         begin
           if(delay!=4)
           `uvm_error("monitor error","delay after read to write fail");
         end
        else if(curr_cmd==3) 
         begin
          if(delay!=4)
         `uvm_error("monitor error","delay after read to pre fail");
         end
   end

2:
  begin
       if(curr_cmd==1)	
         begin
          if(delay!=4)
          `uvm_error("monitor error","delay after write to read fail");
         end
       else if(curr_cmd==2) 
         begin
          if(delay!=0)
         `uvm_error("monitor error","delay after write to write fail");
         end
       else if(curr_cmd==3) 
         begin
         if(delay!=4)
         `uvm_error("monitor error","delay after write to pre fail");
         end
   end

3:
   begin
        if(curr_cmd==5 || curr_cmd==4)
          begin
           if(delay != 0)
           `uvm_error("monitor error","delay after pre to act or refresh fail");
          end  
   end
4:
   begin
        if(curr_cmd==1 || curr_cmd==2)
	   begin
             if(delay !=5)
   	     `uvm_error("monitor error","delay after act to rd/wr fail");
           end
   end	   

5:
   begin
         if(curr_cmd==4)
	    begin
              if(delay != 5)
              `uvm_error("monitor error","delay after refresh to act fail");
	    end
   end
endcase	
`uvm_info(get_type_name(), $sformatf("delay _btwn cmmands:\n%s",pkt_dly.sprint()), UVM_LOW);

   prev_cmd=curr_cmd;
   pkt_dly.prev_cmd=curr_cmd;
   prev_time=curr_time;
endtask   

//===============counter==============//
task counter(bit [3:0] i);
bit [3:0] count;
count=0;
while( count < i)
   begin
      @(negedge fmem.clk)
      begin
      count++;
      end
   end
endtask

endclass
