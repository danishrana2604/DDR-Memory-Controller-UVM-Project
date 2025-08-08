class environment extends uvm_env;

  `uvm_component_utils(environment);

  agent ag; 
  function new(string name="",uvm_component parent);
	super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
  	super.build_phase(phase);
	ag=agent::type_id::create("ag",this);
  endfunction


endclass
