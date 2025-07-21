class env_config extends uvm_object;
	`uvm_object_utils(env_config)

	mst_agt_config mcfg[];
	slave_agt_config scfg[];
	int has_scoreboard=1;
	int no_of_mst_agent=1;
	int no_of_slave_agent=1;
	int has_sagt;
	int has_magt;
	int has_virtual_sequencer=1;
	function new(string name="env_config");
		super.new(name);
	endfunction
	
endclass
