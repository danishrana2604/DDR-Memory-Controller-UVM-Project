`include "uvm_macros.svh"
import uvm_pkg::*;

`include "trans.sv"
`include "sequencer.sv"
`include "driver.sv"
`include "cover_file.sv"
`include "monitor.sv"
`include "agent.sv"
`include "env.sv"
`include "test.sv"
`include "fsm_controller.sv"
`include "interface.sv"
`include "new_memory.sv"
`include "assertion.sv"

module top;

bit clk;
bit rst_n;
always #5 clk = ~clk;


ext_intf f(clk,rst_n);
mem_intf fm(clk,rst_n);

assertion a(fm);
controller c(f,fm);
new_memory mem(fm);

initial begin
rst_n=1;
#20 rst_n=0;
#530 rst_n=1;
#10 rst_n=0;
#360 rst_n=1;
#10 rst_n=0;

end

initial begin

uvm_config_db #(virtual ext_intf)::set(null,"*","dut_intf",f);
uvm_config_db #(virtual mem_intf)::set(null,"*","mem_intf",c.fm);
run_test("test");
end
initial
begin
 $dumpfile("dump.vcd");
 $dumpvars(0,f,c.fm);

end
endmodule


