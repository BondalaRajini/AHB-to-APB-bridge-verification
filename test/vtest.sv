class base_test extends uvm_test;
	`uvm_component_utils(base_test)	
	env env_h;
	env_config ecfg;
	mst_agt_config mcfg[];
	slave_agt_config scfg[];	
	int has_sagt=1;
	int has_magt=1;
	int no_of_mst_agent=1;
	int no_of_slave_agent=1;

	function new(string name="test_base",uvm_component parent=null);
		super.new(name,parent);
	endfunction


	function void con();
		if(has_sagt)
                  begin
			scfg=new[no_of_slave_agent];
			foreach (scfg[i])
			begin
			scfg[i]=slave_agt_config ::type_id::create($sformatf("scfg[%0d]",i));
			if(!uvm_config_db #(virtual slave_if)::get(this,"",$sformatf("sif_%0d",i),scfg[i].vif))
			`uvm_fatal(get_type_name(),"data is not getting in test class in slave")
			scfg[i].is_active=UVM_ACTIVE;
			ecfg.scfg[i]=scfg[i];
			end
		 end
			
		if(has_magt)
                  begin
			mcfg=new[no_of_mst_agent];
			foreach (mcfg[i])
			begin
			mcfg[i]=mst_agt_config ::type_id::create($sformatf("mcfg[%0d]",i));
			 if(!uvm_config_db #(virtual mst_if)::get(this,"",$sformatf("mif_%0d",i),mcfg[i].vif))
			`uvm_fatal(get_type_name(),"data is not getting in test class in mst")

			mcfg[i].is_active=UVM_ACTIVE;
			ecfg.mcfg[i]=mcfg[i];
			end
		 end

	ecfg.has_sagt=has_sagt;
	ecfg.has_magt=has_magt;
	ecfg.no_of_mst_agent=no_of_mst_agent;
	ecfg.no_of_slave_agent=no_of_slave_agent;
	endfunction
	
	function  void build_phase (uvm_phase phase);
		 super.build_phase(phase);
		 ecfg=env_config::type_id::create("ecfg");
		if(has_sagt)
		 ecfg.mcfg=new[no_of_mst_agent];
		if(has_magt)
		 ecfg.scfg=new[no_of_slave_agent];
		con();
		uvm_config_db #(env_config)::set(this,"*","env_config",ecfg);
		env_h=env::type_id::create("env_h",this);
	endfunction
	
endclass

class single_pkt_test extends base_test;
 single_seqs_pkt single_seqs_pkt_h;
// single_seqs_pkt_h=single_seqs_pkt::type_id::create("single_seqs_pkt_h");
	`uvm_component_utils(single_pkt_test)
	function new(string name="single_pkt_test",uvm_component parent=null);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);	
	endfunction
	
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		single_seqs_pkt_h= single_seqs_pkt::type_id::create("single_seqs_pkt_h");

		single_seqs_pkt_h.start	(env_h.mst_top_h.agt_h[0].seqr_h);
		#100;	
		phase.drop_objection(this);	
	endtask
  
endclass

class incr_pkt_test extends base_test;
 incr_seqs_pkt incr_seqs_pkt_h;
// incr_seqs_pkt_h= incr_seqs_pkt::type_id::create("incr_seqs_pkt_h");
	`uvm_component_utils(incr_pkt_test)
	function new(string name="incr_pkt_test",uvm_component parent=null);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);	
	endfunction
	
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		incr_seqs_pkt_h= incr_seqs_pkt::type_id::create("incr_seqs_pkt_h");

		incr_seqs_pkt_h.start(env_h.mst_top_h.agt_h[0].seqr_h);	
			#100;

		phase.drop_objection(this);
	
	endtask
  
endclass		

class wrap_pkt_test extends base_test;
 wrap_seqs_pkt wrap_seqs_pkt_h;
	`uvm_component_utils(wrap_pkt_test)
	function new(string name="wrap_pkt_test",uvm_component parent=null);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);	
	endfunction
	
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		wrap_seqs_pkt_h= wrap_seqs_pkt::type_id::create("wrap_seqs_pkt_h");

		wrap_seqs_pkt_h.start(env_h.mst_top_h.agt_h[0].seqr_h);	
			#40;

		phase.drop_objection(this);
	
	endtask
  
endclass		


