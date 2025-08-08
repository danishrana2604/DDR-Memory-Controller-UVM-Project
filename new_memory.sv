module new_memory(mem_intf f);

bit [3:0] ra;
bit [11:0] ca;
bit [31:0] mem [15:0][4095:0];
logic [2:0] cmd;
logic [31:0] local_data;

assign f.dq= (f.r_w_enable) ? local_data : 32'bz;
//assign local_data =(f.r_w_enable)? mem[ra][ca] :32'bz;
always @(posedge f.clk)
begin
	if(f.rst_n ==1)
	   begin
	   foreach( mem[i,j])
	   mem[i][j]=0;
           end
end	   

always @(f.clk)
 begin 
  if(f.cmd === 1'b0)
     begin
     counter(2);
      local_data = 32'bz;
     end
 end    

always @(f.clk)
begin
 @( f.cmd or f.ca )
begin
//	cmd=f.cmd;
	ra=f.ra;
	ca=f.ca;
	
        
	case(f.cmd)
	0: // nop
	begin
	$display("ideal state");
	local_data=32'bz;
	end

	1: // read
	begin
	fork
	begin
	counter(2);
	local_data=mem[ra][ca];
	end
	join_none
	end

	2: // write
	begin
	local_data=32'bz;

	mem[ra][ca]=f.dq;
	end

	3://precharge
	begin
	$display("===saving saving of current row===");
	end

	4: //activate
	begin
	$display("new row activated in memory");
	end

	5: begin
	$display("memory is in refresh state");

	end
endcase
end
end


task counter( bit [3:0] i);
bit [3:0] count;
count=0;
while( count < i)
   begin
      @(posedge f.clk)
      begin
      count++;
      end
   end
endtask
endmodule		





	   


