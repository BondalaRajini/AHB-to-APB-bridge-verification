class mst_top extends uvm_env;
	`uvm_component_utils(mst_top)
		mst_agt agt_h[];
	env_config ecfg;

	function new(string name="mst_top",uvm_component parent=null);
		super.new(name,parent);
	endfunction
		function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(env_config)::get(this,"","env_config",ecfg))
			`uvm_fatal(get_type_name(),"env_config data is not gtting in mst_top class")
		agt_h=new[ecfg.no_of_mst_agent];
		foreach(agt_h[i])
		begin
		
		agt_h[i]=mst_agt ::type_id::create($sformatf("agt_h[%0d]",i),this);
		uvm_config_db #(mst_agt_config)::set(this,$sformatf("agt_h[%0d]*",i),"mst_agt_config",ecfg.mcfg[i]);
		end
	endfunction

endclass


