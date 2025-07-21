class slave_top extends uvm_env;
	`uvm_component_utils(slave_top)
	
	function new(string name="slave_top",uvm_component parent=null);
		super.new(name,parent);
	endfunction
	slave_agt agt_h[];
	env_config ecfg;
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(env_config)::get(this,"","env_config",ecfg))
			`uvm_fatal(get_type_name(),"env_config data is not gtting in slave_top class")
		agt_h=new[ecfg.no_of_slave_agent];
		foreach(agt_h[i])
		begin
		agt_h[i]=slave_agt ::type_id::create($sformatf("agt_h[%0d]",i),this);
		uvm_config_db #(slave_agt_config)::set(this,$sformatf("agt_h[%0d]*",i),"slave_agt_config",ecfg.scfg[i]);
		end
	endfunction
endclass
