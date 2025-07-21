class env extends uvm_env;
	`uvm_component_utils(env)
 env_config ecfg;
 mst_top mst_top_h;
 slave_top slave_top_h;
 scoreboard sb_h;

function new(string name="env",uvm_component parent=null);
		super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(env_config)::get(this,"","env_config",ecfg))
			`uvm_fatal(get_type_name(),"env_config is not getting in env class")
		if(ecfg.has_sagt)
				slave_top_h=slave_top::type_id::create("slave_top_h",this);
		if(ecfg.has_magt)
				mst_top_h=mst_top::type_id::create("mst_top_h",this);
		if(ecfg.has_scoreboard)
				sb_h=scoreboard::type_id::create("sb_h",this);

endfunction

function void end_of_elaboration_phase(uvm_phase phase);
	super.end_of_elaboration_phase (phase);
	uvm_top.print_topology;
endfunction

function void connect_phase(uvm_phase phase);
	if(ecfg.has_scoreboard)
	begin
	if(ecfg.has_magt)
		mst_top_h.agt_h[0].mon_h.monitor_port.connect(sb_h.m_fifo.analysis_export);
	if(ecfg.has_sagt)
		slave_top_h.agt_h[0].mon_h.monitor_port.connect(sb_h.s_fifo.analysis_export);
	end
endfunction

endclass
