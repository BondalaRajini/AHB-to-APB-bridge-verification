class mst_drv extends uvm_driver#(mst_xtns);
	`uvm_component_utils(mst_drv)

	mst_agt_config mcfg;
	virtual mst_if.MDRV_MP vif;
	function new(string name="mst_drv",uvm_component parent=null);
		super.new(name,parent);
	endfunction
	function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(mst_agt_config ) ::get(this,"","mst_agt_config",mcfg))
			`uvm_fatal(get_type_name(),"config is not getting in src_drv");

	endfunction
	function void connect_phase(uvm_phase phase);
		vif=mcfg.vif;
	endfunction
	
	task run_phase(uvm_phase phase);
			@(vif.mdrv_cb);
			vif.mdrv_cb.Hresetn<=1'b0;
			@(vif.mdrv_cb);
			vif.mdrv_cb.Hresetn<=1'b1;
		forever
			begin
				seq_item_port.get_next_item(req);
      			 	send_to_dut(req);
			//	$display("I am in master driver");
	`uvm_info("MAST DRV","PRINTING FROM MASTER DRIVER",UVM_LOW)
				req.print();
				seq_item_port.item_done();
			end
	endtask
	
	task send_to_dut(mst_xtns req);
		while(vif.mdrv_cb.Hready_out!==1)
			@(vif.mdrv_cb);
		vif.mdrv_cb.Haddr<=req.Haddr;
		vif.mdrv_cb.Hwrite<=req.Hwrite;
		vif.mdrv_cb.Hsize<=req.Hsize;
		vif.mdrv_cb.Htrans<=req.Htrans;
		vif.mdrv_cb.Hbrust<=req.Hbrust;
		vif.mdrv_cb.Hready_in<=1;
			@(vif.mdrv_cb);
		while(vif.mdrv_cb.Hready_out!==1)
			@(vif.mdrv_cb);	
	if(req.Hwrite)
			vif.mdrv_cb.Hwdata<=req.Hwdata;
		else
			vif.mdrv_cb.Hwdata<=32'b0;
	endtask
endclass

