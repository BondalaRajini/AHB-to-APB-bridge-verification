class mst_mon extends uvm_monitor;
  	mst_agt_config mcfg;
 	virtual mst_if.MMON_MP vif;
 	`uvm_component_utils(mst_mon)
	uvm_analysis_port #(mst_xtns) monitor_port;
	mst_xtns rdata;
	function new(string name="mst_mon",uvm_component parent=null);
		super.new(name,parent);
	monitor_port=new("monitor_port",this);
 	endfunction

	function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(mst_agt_config ) ::get(this,"","mst_agt_config",mcfg))
			`uvm_fatal(get_type_name(),"config is not getting in monitor")

	endfunction

	function void connect_phase(uvm_phase phase);
		vif=mcfg.vif;
	endfunction

	task run_phase(uvm_phase phase);
		forever
			begin
				collect_data();
			end
	endtask

	task collect_data();
		rdata=mst_xtns::type_id::create("rdata");
		while(vif.mmon_cb.Hready_out!==1)
			@(vif.mmon_cb);
		if(vif.mmon_cb.Htrans==2'b10 || vif.mmon_cb.Htrans==2'b11)
		begin
		rdata.Haddr=vif.mmon_cb.Haddr;
		rdata.Htrans=vif.mmon_cb.Htrans;
		rdata.Hsize=vif.mmon_cb.Hsize;
		rdata.Hready_in=vif.mmon_cb.Hready_in;
		rdata.Hwrite=vif.mmon_cb.Hwrite;
		rdata.Hbrust=vif.mmon_cb.Hbrust;
		rdata.Hresp=vif.mmon_cb.Hresp;
		@(vif.mmon_cb);
		while(vif.mmon_cb.Hready_out!==1)
			@(vif.mmon_cb);	
	if(rdata.Hwrite)
		rdata.Hwdata=vif.mmon_cb.Hwdata;
	else
	   rdata.Hrdata=vif.mmon_cb.Hrdata;
	`uvm_info("MAST  MON","PRINTING FROM MASTER MONITOR",UVM_LOW)
	rdata.print();
		monitor_port.write(rdata);
end
else
@(vif.mmon_cb);	

	
	endtask
endclass

