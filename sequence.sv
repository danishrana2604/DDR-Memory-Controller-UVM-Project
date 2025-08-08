//================sequence1===============
class sequence1 extends uvm_sequence #(seq_txn);

`uvm_object_utils(sequence1)

function new(string name="");
	super.new(name);
endfunction

task body();
	repeat(100)
	begin
	seq_txn txn;
 	txn=seq_txn::type_id::create("txn");
	
	start_item(txn);
 	void'(txn.randomize() with {addr_in inside {[1:5]};});
	txn.cmd_n=0;
	txn.rd_wr=0;
	finish_item(txn);
	end

endtask

endclass

class sequence2 extends uvm_sequence #(seq_txn);

`uvm_object_utils(sequence2)

function new(string name="");
	super.new(name);
endfunction

task body();
	repeat(100)
	begin
	seq_txn txn;
 	txn=seq_txn::type_id::create("txn");
	start_item(txn);
	void'(txn.randomize() with{addr_in inside {[1:5]};} );
	txn.cmd_n=0;
	txn.rd_wr=1;
	finish_item(txn);
	end
endtask

endclass

//==============================================
//
//
//==========sequence2==========================
class sequence_write1 extends uvm_sequence #(seq_txn);

`uvm_object_utils(sequence_write1)

function new(string name="");
	super.new(name);
endfunction

task body();
	repeat(100)
	begin
	seq_txn txn;
 	txn=seq_txn::type_id::create("txn");
	
	start_item(txn);
 	void'(txn.randomize() with {addr_in inside {1,5000,15000};});
	txn.cmd_n=0;
	txn.rd_wr=0;
	finish_item(txn);
	end

endtask

endclass

class sequence_read1 extends uvm_sequence #(seq_txn);

`uvm_object_utils(sequence_read1)

function new(string name="");
	super.new(name);
endfunction

task body();
	repeat(100)
	begin
	seq_txn txn;
 	txn=seq_txn::type_id::create("txn");
	
	start_item(txn);
 	void'(txn.randomize() with {addr_in inside {1,5000,15000};});
	txn.cmd_n=0;
	txn.rd_wr=1;
	finish_item(txn);
	end

endtask

endclass

//====================================
//
//
//==============sequence 3==============
class sequence_write2 extends uvm_sequence #(seq_txn);

`uvm_object_utils(sequence_write2)

function new(string name="");
	super.new(name);
endfunction

task body();
	repeat(100)
	begin
	seq_txn txn;
 	txn=seq_txn::type_id::create("txn");
	
	start_item(txn);
 	void'(txn.randomize() with {addr_in inside {16'hffff};});
	txn.cmd_n=0;
	txn.rd_wr=0;
	finish_item(txn);
	end

endtask

endclass

 class sequence_read2 extends uvm_sequence #(seq_txn);

`uvm_object_utils(sequence_read2)

function new(string name="");
	super.new(name);
endfunction

task body();
	repeat(100)
	begin
	seq_txn txn;
 	txn=seq_txn::type_id::create("txn");
	
	start_item(txn);
 	void'(txn.randomize() with {addr_in inside {16'hffff};});
	txn.cmd_n=0;
	txn.rd_wr=1;
	finish_item(txn);
	end

endtask

endclass

//=================================================
//
//
//=============sequence 4===============
class sequence_wr_to_rd extends uvm_sequence #(seq_txn);

`uvm_object_utils(sequence_wr_to_rd)

function new(string name="");
	super.new(name);
endfunction

task body();
	repeat(100)
	begin
	
	send1();
	send2();

	end

endtask


task send1();
	seq_txn txn;
 	txn=seq_txn::type_id::create("txn");
	start_item(txn);
 	void'(txn.randomize() with {addr_in inside {1};});
	txn.rd_wr=0;
	txn.cmd_n=0;
	finish_item(txn);
endtask

task send2();
	seq_txn txn;
 	txn=seq_txn::type_id::create("txn");
	start_item(txn);
 	void'(txn.randomize() with {addr_in inside {1};});
	txn.rd_wr=1;
	txn.cmd_n=0;
	finish_item(txn);
endtask


endclass

//============================================================
//
//
//============sequence 5==================
class sequence_wr_to_rd2 extends uvm_sequence #(seq_txn);

`uvm_object_utils(sequence_wr_to_rd2)

function new(string name="");
	super.new(name);
endfunction

task body();
	repeat(100)
	begin
	seq_txn txn;
 	txn=seq_txn::type_id::create("txn");
	
	send1();
	send2();

	end

endtask


task send1();
	seq_txn txn;
 	txn=seq_txn::type_id::create("txn");
	start_item(txn);
 	void'(txn.randomize() with {addr_in inside {1,5000,15000};});
	txn.rd_wr=0;
	txn.cmd_n=0;
	finish_item(txn);
endtask

task send2();
	seq_txn txn;
 	txn=seq_txn::type_id::create("txn");
	start_item(txn);
 	void'(txn.randomize() with {addr_in inside {1,5000,15000};});
	txn.rd_wr=1;
	txn.cmd_n=0;
	finish_item(txn);
endtask


endclass

//==========================================
//
//===========sequnce cmd_n set to low============
class sequence3 extends uvm_sequence #(seq_txn);

`uvm_object_utils(sequence3)

function new(string name="");
	super.new(name);
endfunction

task body();
	repeat(100)
	begin
	seq_txn txn;
 	txn=seq_txn::type_id::create("txn");
	start_item(txn);
	void'(txn.randomize());
	txn.cmd_n=1;
	finish_item(txn);
	end
endtask

endclass
