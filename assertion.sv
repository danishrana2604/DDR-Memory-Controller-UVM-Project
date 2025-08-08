module assertion (mem_intf fmem);


property data_on_dq_after_write;
@(posedge f.clk) disable iff (f.rst_n) 
c.fm.cmd==2 |-> (c.fm.dq !== 32'bz);
endproperty

assert property(data_on_dq_after_write)
begin `uvm_info("",$sformatf("write assertion passed"),UVM_LOW); end 
else 
  begin `uvm_error("","write assertion fail"); end


property data_on_dq_after_read;
@(posedge f.clk) disable iff (f.rst_n) 
c.fm.cmd==1 |-> ##2 (c.fm.dq !== 32'bz);
endproperty

assert property (data_on_dq_after_read)
 begin `uvm_info("",$sformatf(" read assertion passed"),UVM_LOW); end
else
   begin `uvm_error(""," read assertion failed"); end

property unknown;
 @(posedge f.clk) disable iff (f.rst_n) 
 (c.fm.dq !== 32'bx);
endproperty
 
assert property (unknown)
 begin `uvm_info("",$sformatf("assertion paased for dq"),UVM_LOW); end
else
  begin `uvm_error("",  " unknown value found"); end

property nop_after_read;
@(posedge f.clk) disable iff (f.rst_n) 
c.fm.cmd==1 |-> ##1 (c.fm.cmd==0);
endproperty

assert property(nop_after_read)
 begin `uvm_info("",$sformatf(" assertion passed : nop cmd issued after read cmd"),UVM_LOW); end
else	
   begin `uvm_error(""," assertion failed : nop cmd is not issued"); end

property read_cmd;
@(posedge f.clk) disable iff (f.rst_n) 
((c.fm.cmd==1) |-> (##3 c.fm.cmd==1 or ##5 c.fm.cmd==2 or ##5 c.fm.cmd==3));
endproperty

assert property(read_cmd)
   begin `uvm_info("",$sformatf(" assertion passed : correct delay after read cmd"),UVM_LOW); end
else	
   begin `uvm_error(""," assertion failed : incorrect delay after reaed"); end


property write_cmd;
@(posedge f.clk) disable iff (f.rst_n) 
((c.fm.cmd==2) |-> (##1 c.fm.cmd==2 or ##5 c.fm.cmd==1 or ##5 c.fm.cmd==3));
endproperty

assert property(write_cmd)
   begin `uvm_info("",$sformatf(" assertion passed : correct delay after write cmd"),UVM_LOW); end
else	
   begin `uvm_error(""," assertion failed : incorrect delay after write"); end

property activate_cmd;
@(posedge f.clk) disable iff (f.rst_n) 
((c.fm.cmd==4) |-> (##6 c.fm.cmd==2 or ##6 c.fm.cmd==1));
endproperty

assert property(write_cmd)
   begin `uvm_info("",$sformatf(" assertion passed : correct delay after activate cmd"),UVM_LOW); end
else	
   begin `uvm_error(""," assertion failed : incorrect delay after activate"); end

endmodule
