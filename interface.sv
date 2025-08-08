interface ext_intf(input clk,rst_n);
logic rd_wr;
logic cmd_n;
logic [15:0] addr_in;
logic [31:0] data_in;
logic [31:0] data_out;
wire data_out_vld;
wire data_in_vld;
endinterface

interface mem_intf(input clk ,rst_n);
logic [3:0] ra;
logic [2:0]cmd;
logic [11:0] ca;
wire [31:0] dq=32'bz;
bit r_w_enable;
wire cs_n;
endinterface
