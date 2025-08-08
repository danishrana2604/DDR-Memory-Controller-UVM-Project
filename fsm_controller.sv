module controller (ext_intf fc, mem_intf fm);

bit q_cmd[$];
bit [15:0] q_addr[$];
bit [31:0] q_data[$];
logic cmd;
logic [1:0] prev_cmd;
logic [1:0] curr_cmd;
logic [31:0] data;
bit [15:0] addr;
logic [3:0] activate_row;
bit [2:0] ref_delay;
bit [15:0] counter_ref;
bit first_pre;
logic local_data;
bit refresh_enable;
enum bit [2:0] {nop_state,read,write,precharge,activate,refresh} state;
//control_state state;
	
assign fm.cs_n = (fm.cmd==0)? 'b1: 'b0;
assign fc.data_out_vld = (fm.r_w_enable==1 && fm.dq !== 32'bz)?'b1:'b0;
assign fc.data_in_vld = (fm.r_w_enable==0 && fm.dq !== 32'bz)?'b1:'b0;

always @(posedge fc.clk)
begin
counter_ref++;
if(counter_ref==640)
begin  
   refresh_enable=1;
end
end

//=========== DRIVING Z ON DQ===================//
assign fm.dq= (fm.r_w_enable) ? 32'bz : data;
//===============================================//


always @(posedge fc.clk or posedge fc.rst_n)
begin
	if( fc.rst_n==1)
	begin		   
		   q_cmd.delete;
		   q_data.delete;
		   q_addr.delete;
		   first_pre=0;
		   fm.cmd=0;
		   activate_row = 4'bx;
		   refresh_enable=0;
		   fm.ra=0;
		   fm.ca=0;

		   state=nop_state;
	end
	if(fc.cmd_n==0)
	begin
 	   	q_cmd.push_back(fc.rd_wr);
 	   	q_addr.push_back(fc.addr_in);
 	   	if(fc.rd_wr==0)
 	   	    q_data.push_back(fc.data_in);
	end		
end


initial @(posedge fc.clk)
begin
	if(q_cmd.size > 0)
	begin
		cmd=q_cmd.pop_front;
		addr=q_addr.pop_front;
		state=activate;
	end
	else
		state=nop_state;
end		   


always @(posedge fc.clk)
begin
fm.r_w_enable=1;
fm.cmd=0;
case (state)
nop_state :
begin
if(refresh_enable==1)
   begin
   counter(4);
   fm.cmd=3;
   counter(1);
   fm.cmd=5;
   counter(1);
   fm.cmd=0;
   counter(3);
   counter_ref=0;
   refresh_enable=0;
   first_pre=0;
   state=nop_state;
   end
else
   begin
if( q_cmd.size > 0)
   begin
        cmd=q_cmd.pop_front;
	addr=q_addr.pop_front;
	if(cmd==1)
		begin
		  if(first_pre==0)
		     begin
		     first_pre++;
		     state=activate;
		     end
		  else
		     begin
	      	     if(addr[15:12]==activate_row)
	             	begin
	            	if(prev_cmd==1)
	         	   begin
	         	   counter(1);
	         	   state=read;
	         	   end
	         	else
	         	   begin
	         	   counter(3);
	         	   state=read;
	         	   end
	                end
		     else
		      state=precharge;
		  end
		 end 

	else if(cmd==0)
		 begin
		    if(first_pre==0)
		       begin
		       first_pre++;
		       state=activate;
		       end
		    else
		       begin
		   	 if(addr[15:12]==activate_row)
		     	 begin
		      		if(prev_cmd==1)
		             	 begin
		            	  counter(3);
		            	  state=write;
		             	 end
		          else
		              state=write;
		      	 end
		    	else
		       	    state=precharge;
		       end
		 end      
end     
else
   begin
   @(posedge fc.clk)
   state=nop_state;
   end
end
end

write :
begin
   if(addr[15:12]==activate_row)
      begin
      fm.cmd=2;
      fm.r_w_enable=0;
      fm.ca=addr[11:0];
      prev_cmd=cmd;
      data=q_data.pop_front;
      fork
         begin
	 counter(1);
	 fm.r_w_enable=1;
	 end
      join_none
      check_cmd;
      end
    else
       state=precharge;
end

read:
begin
	 if(addr[15:12]==activate_row)
	    begin
	      	fm.ca=addr[11:0];
		fm.r_w_enable = 1;
		fm.cmd=1;
		prev_cmd=cmd;
		fork
		    begin
		    counter(3);
		    fc.data_out=fm.dq;
		    end
		join_none
		state=nop_state;
   	    end
	 else
	    state=precharge;
	
end

precharge:
begin
counter(3);
fm.cmd=3;
state=activate;
end

activate:
begin
	activate_row=addr[15:12];
	fm.ra = activate_row;
	fm.cmd=4;
	counter(1);
	fm.cmd=0;
	counter(4);
	if(cmd==0)
	  state= write;
	 else
	  state= read;
end

/*refresh:
begin
     fm.cmd=5;
     prev_cmd=1'bx;
     counter_ref=0;
	fm.cmd=0;
counter(3);
counter_ref=0;
state=nop_state;
end*/

	   
endcase
end
//==========check_cmd=======//
task check_cmd();
if(q_cmd.size > 0)
  begin
     if(refresh_enable==1)
	state=nop_state;
     else
	begin
  		prev_cmd=cmd;
    		cmd=q_cmd.pop_front;
    		addr=q_addr.pop_front;
      		if(cmd==0)
	    	   state=write;
                else
	           begin
	  		if(addr[15:12]==activate_row)
	     		begin
	     		counter(1);
	     		fm.cmd=0;
	     		counter(3);
	     		state=read;
			end
	   		else
	      		state=read;
	  	   end
  	end
  end	
else
   state=nop_state;
endtask   

//=========== C O U N T E R   T A S K===========//
task counter( bit [3:0] i);
   repeat(i)
	begin
	if(fc.rst_n==1)
	   begin
	      break;
	   end   
	 else
	    @(posedge fc.clk or posedge fc.rst_n);
	 end
endtask	 


initial begin
$dumpfile("new_controller.vcd");
$dumpvars(0,fm);
end

endmodule
