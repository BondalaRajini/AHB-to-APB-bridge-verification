class slave_drv extends uvm_driver #(slave_xtns);
	`uvm_component_utils(slave_drv)
		int a=$urandom;

	slave_agt_config scfg;
	virtual slave_if.SDRV_MP vif;
	function new(string name="slave_drv",uvm_component parent=null);
		super.new(name,parent);
	endfunction
	function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(slave_agt_config ) ::get(this,"","slave_agt_config",scfg))
			`uvm_fatal(get_type_name(),"config is not getting in src_drv");

	endfunction

	function void connect_phase(uvm_phase phase);
		vif=scfg.vif;
	endfunction
	
	task run_phase(uvm_phase phase);
			super.run_phase(phase);

		forever
			begin
			      send_to_dut();
			
			end
	endtask

	task send_to_dut();
		slave_xtns xtn;
		
			xtn=slave_xtns::type_id::create("xtn");
			//wait(vif.sdrv_cb.Pselx!=0)
			while(vif.sdrv_cb.Pselx===0)
			@(vif.sdrv_cb); 
			if(vif.sdrv_cb.Pwrite==0)
			begin	
			//wait(vif.sdrv_cb.Penable==1)
			//while(vif.sdrv_cb.Penable!==1)
			//@(vif.sdrv_cb);				
			vif.sdrv_cb.Prdata<=$random;
				end
						repeat(2)
			@(vif.sdrv_cb);
xtn.print;
	endtask
endclass
