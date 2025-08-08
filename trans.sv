class seq_txn extends uvm_sequence_item;
rand logic cmd_n;
rand logic rd_wr;
rand logic [15:0] addr_in;
rand logic [31:0] data_in;
`uvm_object_utils_begin(seq_txn);
	`uvm_field_int(cmd_n,UVM_ALL_ON)
	`uvm_field_int(rd_wr,UVM_ALL_ON)
	`uvm_field_int(addr_in,UVM_ALL_ON)
	`uvm_field_int(addr_in,UVM_ALL_ON)
`uvm_object_utils_end	


//constraint addr_range { addr_in inside {16'hffff,16'hfff,16'hff,16'hf,16'h0};
//constraint addr_range { addr_in inside {1,5000,15000,16};}
//constraint addr_range { addr_in inside {[1:100],[5000:5500]};}
//constraint addr_range { addr_in inside {[1:10]};}

endclass


class cover_gp_item extends uvm_sequence_item;
`uvm_object_utils(cover_gp_item);

logic [3:0] ra;
logic [11:0] ca;
logic [2:0] curr_cmd;
logic [2:0] prev_cmd;
logic [2:0] delay;
logic [31:0] data_in;
endclass

class mon_delay extends uvm_sequence_item;

logic [2:0] curr_cmd;
logic [2:0] prev_cmd;
logic [5:0] delay;

`uvm_object_utils_begin(mon_delay);
	`uvm_field_int(prev_cmd,UVM_ALL_ON)
	`uvm_field_int(curr_cmd,UVM_ALL_ON)
	`uvm_field_int(delay,UVM_ALL_ON)
`uvm_object_utils_end	

endclass

class mon_compare extends uvm_sequence_item;

logic [31:0] actual_data;
logic [31:0] ref_data;

`uvm_object_utils_begin(mon_compare);
	`uvm_field_int(ref_data,UVM_ALL_ON)
	`uvm_field_int(actual_data,UVM_ALL_ON)
`uvm_object_utils_end	

endclass

