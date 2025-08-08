`include "sequence.sv"

//========test1 fix adress is [1:5]=========//
class test1 extends uvm_test;
	
  `uvm_component_utils(test1);
  environment env;

  sequence1 seq1;
  sequence2 seq2;

  function new(string name="",uvm_component parent);
	super.new(name,parent);
  endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  env=environment::type_id::create("env",this);
 seq1=sequence1::type_id::create("seq1",this);
 seq2=sequence2::type_id::create("seq2",this);
endfunction

task main_phase(uvm_phase phase);
     phase.raise_objection(this);
     seq1.start(env.ag.seqr);
     seq2.start(env.ag.seqr);
#1000;
	phase.drop_objection(this);

endtask
endclass
//===========================================

//============test2 fix adress is 1,5000,15000==================//

class test2 extends uvm_test;
	
  `uvm_component_utils(test2);
  environment env;

  sequence_write1 seq1;
  sequence_read1 seq2;
  sequence3 seq3;

  function new(string name="",uvm_component parent);
	super.new(name,parent);
  endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  env=environment::type_id::create("env",this);
 seq1=sequence_write1::type_id::create("seq1",this);
 seq2=sequence_read1::type_id::create("seq2",this);
 seq3=sequence3::type_id::create("seq3",this);
endfunction

task main_phase(uvm_phase phase);
     phase.raise_objection(this);
     seq1.start(env.ag.seqr);
     seq2.start(env.ag.seqr);
     seq3.start(env.ag.seqr);
#10000;
	phase.drop_objection(this);

endtask
endclass
//=====================================//


//============test3 fix adress is 'hffff ============//
class test3 extends uvm_test;
	
  `uvm_component_utils(test3);
  environment env;

  sequence_write2 seq1;
  sequence_read2 seq2;
  sequence3 seq3;

  function new(string name="",uvm_component parent);
	super.new(name,parent);
  endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  env=environment::type_id::create("env",this);
 seq1=sequence_write2::type_id::create("seq1",this);
 seq2=sequence_read2::type_id::create("seq2",this);
 seq3=sequence3::type_id::create("seq3",this);
endfunction

task main_phase(uvm_phase phase);
     phase.raise_objection(this);
     seq1.start(env.ag.seqr);
     seq2.start(env.ag.seqr);
     seq3.start(env.ag.seqr);
#1000;
	phase.drop_objection(this);

endtask
endclass

//=====================================//



//============test4 wr then read without change in row============//
class test4 extends uvm_test;
	
  `uvm_component_utils(test4);
  environment env;

  sequence_wr_to_rd seq1;
  sequence3 seq3;

  function new(string name="",uvm_component parent);
	super.new(name,parent);
  endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  env=environment::type_id::create("env",this);
 seq1=sequence_wr_to_rd::type_id::create("seq1",this);
 seq3=sequence3::type_id::create("seq3",this);
endfunction

task main_phase(uvm_phase phase);
     phase.raise_objection(this);
     seq1.start(env.ag.seqr);
     seq3.start(env.ag.seqr);
#1000;
	phase.drop_objection(this);

endtask
endclass



//=====================================//


//============test5 wr then read with change in row============//
class test5 extends uvm_test;
	
  `uvm_component_utils(test5);
  environment env;

  sequence_wr_to_rd2 seq1;
  sequence3 seq3;

  function new(string name="",uvm_component parent);
	super.new(name,parent);
  endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  env=environment::type_id::create("env",this);
 seq1=sequence_wr_to_rd2::type_id::create("seq1",this);
 seq3=sequence3::type_id::create("seq3",this);
endfunction

task main_phase(uvm_phase phase);
     phase.raise_objection(this);
     seq1.start(env.ag.seqr);
     seq3.start(env.ag.seqr);
#10000;
	phase.drop_objection(this);

endtask
endclass

//=====================================//
//
////////////////////////////////////////////////////
///////////////// F U L L   T E S T //////////////////
/////////////////////////////////////////////////
//
//=============================================
//
class full_test extends uvm_test;
	
  `uvm_component_utils(full_test);
  environment env;

 sequence1 seq1;
 sequence3 seq9;
  sequence2 seq2;
  sequence_wr_to_rd seq3;
 sequence_write1 seq4;
 sequence_write2 seq5;
  sequence_read2 seq6;
sequence_wr_to_rd2 seq7;
  sequence_read1 seq8;


  function new(string name="",uvm_component parent);
	super.new(name,parent);
  endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  env=environment::type_id::create("env",this);
 seq3=sequence_wr_to_rd::type_id::create("seq3",this);
 seq1=sequence1::type_id::create("seq1",this);
 seq2=sequence2::type_id::create("seq2",this);
 seq9=sequence3::type_id::create("seq9",this);
 seq7=sequence_wr_to_rd2::type_id::create("seq7",this);
seq5=sequence_write2::type_id::create("seq5",this);
 seq6=sequence_read2::type_id::create("seq6",this);
 seq4=sequence_write1::type_id::create("seq4",this);
 seq8=sequence_read1::type_id::create("seq8",this);


endfunction

task main_phase(uvm_phase phase);
     phase.raise_objection(this);
     seq1.start(env.ag.seqr);
     seq2.start(env.ag.seqr);
     seq7.start(env.ag.seqr);
     seq3.start(env.ag.seqr);
     seq4.start(env.ag.seqr);
     seq5.start(env.ag.seqr);
     seq6.start(env.ag.seqr);
     seq8.start(env.ag.seqr);
     seq9.start(env.ag.seqr);

#10000;
	phase.drop_objection(this);

endtask
endclass

