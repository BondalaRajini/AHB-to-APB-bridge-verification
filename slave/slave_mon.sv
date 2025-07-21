class slave_mon extends uvm_monitor;
  	slave_agt_config scfg;
		slave_xtns xtns;

 	virtual slave_if.SMON_MP vif;
 	`uvm_component_utils(slave_mon)
	uvm_analysis_port #(slave_xtns) monitor_port;
	function new(string name="slave_mon",uvm_component parent=null);
		super.new(name,parent);
		monitor_port=new("monitor_port",this);
 	endfunction

	function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(slave_agt_config ) ::get(this,"","slave_agt_config",scfg))
			`uvm_fatal(get_type_name(),"config is not getting in monitor")

	endfunction

	function void connect_phase(uvm_phase phase);
		vif=scfg.vif;
	endfunction
	
	task run_phase(uvm_phase phase);
			forever
			begin
				collect_data();
			end
	endtask

	task collect_data();
			xtns=slave_xtns::type_id::create("xtns");

			while(vif.smon_cb.Penable!==1'b1)
				@(vif.smon_cb);


			xtns.Paddr=vif.smon_cb.Paddr;
			xtns.Pwrite=vif.smon_cb.Pwrite;
			xtns.Pselx=vif.smon_cb.Pselx;
			xtns.Penable=vif.smon_cb.Penable;
		
			if(vif.smon_cb.Pwrite)
			begin
					
				xtns.Pwdata=vif.smon_cb.Pwdata;			
			end
			else
	
				
				xtns.Prdata=vif.smon_cb.Prdata;
			xtns.print();

		
						repeat(2)
				@(vif.smon_cb);
	`uvm_info("SLV MON","PRINTING FROM slave MON",UVM_LOW)

			monitor_port.write(xtns);

	endtask
endclass
