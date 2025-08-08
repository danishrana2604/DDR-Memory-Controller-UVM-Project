class driver extends uvm_driver #(seq_txn);
 
  `uvm_component_utils(driver);


  virtual ext_intf fext;

  function new(string name ="",uvm_component parent);
  	super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db #(virtual ext_intf) :: get (this,"","dut_intf",fext))
     `uvm_fatal("fatal msg","virtual intf not received properly");
  endfunction:build_phase


  task main_phase(uvm_phase phase);

        seq_txn txn;
  	forever begin 
	seq_item_port.get_next_item(txn);
//	`uvm_info("PACKET RECV","Transfer collected from port","arshi");
  //      `uvm_info(get_type_name(), $sformatf("Transfer collected from port :\n%s",txn.sprint()), UVM_LOW)

	
	@(posedge fext.clk);
	        fext.addr_in<=txn.addr_in;
        	fext.data_in<=txn.data_in;
		fext.rd_wr<=txn.rd_wr;
		fext.cmd_n<=txn.cmd_n;
		fext.cmd_n<=txn.cmd_n;
	seq_item_port.item_done();
	end
  endtask
endclass
