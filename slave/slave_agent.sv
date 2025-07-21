class slave_agt extends uvm_agent;
	`uvm_component_utils(slave_agt)
	slave_drv drv_h;
	slave_mon mon_h;
	slave_sequencer seqr_h;
	slave_agt_config scfg;
	function new (string name="slave_agt",uvm_component parent=null);
		super.new(name,parent);
	endfunction
	function void build_phase(uvm_phase phase);
	if(!(uvm_config_db #(slave_agt_config)::get(this,"","slave_agt_config",scfg)))
		`uvm_fatal(get_type_name(),"env_config not getting in src agt")
	mon_h=slave_mon::type_id::create("mon_h",this);
	if(scfg.is_active)
	begin
	drv_h=slave_drv::type_id::create("drv_h",this);
	seqr_h=slave_sequencer::type_id::create("seqr_h",this);
end	

endfunction


/*function void connect_phase(uvm_phase phase);
	if(scfg.is_active)
		begin
			drv_h.seq_item_port.connect(seqr_h.seq_item_export);
		end
endfunction*/	
endclass
