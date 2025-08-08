class coverage extends uvm_component;
`uvm_component_utils(coverage);

covergroup cmd_coverage with function sample (cover_gp_item i);
   current_cmd:	coverpoint i.curr_cmd {
      bins read[] = {1};
      bins write[] = {2};
      bins pre[] = {3};
      bins act[] = {4};
      bins refresh[] = {5};}
   previous_cmd:   coverpoint i.prev_cmd {
      bins read[] = {1};
      bins write[] = {2};
      bins pre[] = {3};
      bins act[] = {4};
      bins refresh[] = {5};}

    cross_cov : cross current_cmd,previous_cmd {
       ignore_bins pre_to_pre = binsof(previous_cmd) intersect {3} && binsof(current_cmd) intersect {3};
       ignore_bins act_to_act = binsof(previous_cmd) intersect {4} && binsof(current_cmd) intersect {4};
       ignore_bins ref_to_ref = binsof(previous_cmd) intersect {5} && binsof(current_cmd) intersect {5};
       ignore_bins ref_to_wr = binsof(previous_cmd) intersect {5} && binsof(current_cmd) intersect {1};
       ignore_bins rd_to_ref = binsof(previous_cmd) intersect {1} && binsof(current_cmd) intersect {5};
       ignore_bins ref_to_rd = binsof(previous_cmd) intersect {5} && binsof(current_cmd) intersect {2};
       ignore_bins ref_to_pre = binsof(previous_cmd) intersect {5} && binsof(current_cmd) intersect {3};
       ignore_bins wr_to_act = binsof(previous_cmd) intersect {2} && binsof(current_cmd) intersect {4};
       ignore_bins wr_to_ref = binsof(previous_cmd) intersect {2} && binsof(current_cmd) intersect {5};
       ignore_bins rd_to_act = binsof(previous_cmd) intersect {1} && binsof(current_cmd) intersect {4};
       ignore_bins pre_to_wr = binsof(previous_cmd) intersect {3} && binsof(current_cmd) intersect {2};
       ignore_bins pre_to_rd = binsof(previous_cmd) intersect {3} && binsof(current_cmd) intersect {1};
       ignore_bins act_to_ref = binsof(previous_cmd) intersect {4} && binsof(current_cmd) intersect {5};
       ignore_bins act_to_pre = binsof(previous_cmd) intersect {4} && binsof(current_cmd) intersect {3};
    }
/*   trans_prev_to_curr_cmd: coverpoint i.curr_cmd {
      bins trans_wr_to_wr = (2 =>2);
      bins trans_rd_to_rd = (1 =>1);
      bins trans_wr_to_rd = (2 =>1);
      bins trans_rd_to_wr = (1 =>2);
      bins trans_rd_to_pre = (1 =>3);
      bins trans_pre_to_act = (3 => 4);
      bins trans_pre_to_refresh = (3 =>5);
      ignore_bins trans_wr_to_act = (2 =>4);
      bins trans_wr_to_pre = (2 =>3);
      ignore_bins trans_wr_to_refresh = (2 =>5);
      ignore_bins trans_rd_to_refresh = (1 =>5);
      bins trans_refresh_to_act = (5 =>4);
     ignore_bins trans_refresh_to_pre = (5 =>3);
      ignore_bins trans_refresh_to_refresh = (5 =>5);
      ignore_bins trans_refresh_to_write = (5 =>2);
      ignore_bins trans_refresh_to_read = (5 =>1);
      bins trans_nop_to_nop = default;
   }*/
      
endgroup   
		


/*covergroup current_txn with function sample (cover_gp_item i);
	coverpoint i.ra {
   		bins row_addr_cover[] = {[0:15]};}
	coverpoint i.ca {
	   	bins col_addr_cover[] = {[0:12'hfff]};}
	coverpoint i.data_in {
	   	bins d_low [] = {[0:'d4000]};
		bins d_mid [] = {['d4001:'d15000]};}
endgroup*/

 function new(string name="",uvm_component parent);
	super.new(name,parent);
  cmd_coverage = new();
  //current_txn = new();
  endfunction

endclass
