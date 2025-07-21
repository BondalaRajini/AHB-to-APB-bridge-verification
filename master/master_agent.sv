class mst_agt extends uvm_agent;
	`uvm_component_utils(mst_agt)
	mst_drv drv_h;
	mst_mon mon_h;
	mst_sequencer seqr_h;
	mst_agt_config mcfg;
	function new (string name="mst_agt",uvm_component parent=null);
		super.new(name,parent);
	endfunction
	function void build_phase(uvm_phase phase);
	if(!(uvm_config_db #(mst_agt_config)::get(this,"","mst_agt_config",mcfg)))
		`uvm_fatal(get_type_name(),"env_config not getting in src agt")
	mon_h=mst_mon::type_id::create("mon_h",this);
	if(mcfg.is_active)
begin
	drv_h=mst_drv::type_id::create("drv_h",this);
	seqr_h=mst_sequencer::type_id::create("seqr_h",this);

end	

endfunction


function void connect_phase(uvm_phase phase);
	if(mcfg.is_active)
		begin
			drv_h.seq_item_port.connect(seqr_h.seq_item_export);
		end
endfunction	
endclass

