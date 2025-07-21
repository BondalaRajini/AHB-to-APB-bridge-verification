class mst_seqs extends uvm_sequence#(mst_xtns);
	`uvm_object_utils(mst_seqs)
bit [31:0]haddr;
bit [2:0]hbrust,hsize;
bit hwrite;
bit [9:0] length;
	function new(string name ="mst_seqs");
	super.new(name);
	endfunction	
endclass
//single-seqs
class single_seqs_pkt extends mst_seqs;
       `uvm_object_utils(single_seqs_pkt)
	function new(string name="single_seqs_pkt");
    			super.new(name);
	endfunction
	
	task body();
		repeat(20)
		begin
		req=mst_xtns::type_id::create("mst_xtns");
		start_item(req);
		assert(req.randomize() with{Htrans==2'b10;Hbrust==3'b000;});
		finish_item(req);
		end
	endtask
endclass

//increment_seqs
class incr_seqs_pkt extends mst_seqs;
       `uvm_object_utils(incr_seqs_pkt)
	function new(string name="incr_seqs_pkt");
    			super.new(name);
	endfunction
	
	task body();
		repeat(20)
		begin
		req=mst_xtns::type_id::create("mst_xtns");
		start_item(req);
		assert(req.randomize() with{Htrans==2'b10;Hbrust inside{1,3,5,7};});
		finish_item(req);
		haddr=req.Haddr;
		hbrust=req.Hbrust;
		hsize=req.Hsize;
		hwrite=req.Hwrite;
		length=req.length;
		for(int i=1;i<length;i++)
		  begin
			start_item(req);
			assert(req.randomize()with{Htrans==2'b11;Hwrite==hwrite;Hsize==hsize;
					 	Hbrust==hbrust;Haddr==haddr+(2**hsize);});
			finish_item(req);
			haddr=req.Haddr;
		  end
		end
	endtask
endclass

//Wrap_seqs
class wrap_seqs_pkt extends mst_seqs;
       `uvm_object_utils(wrap_seqs_pkt)
	bit [31:0] s_addr,b_addr;
	function new(string name="wrap_seqs_pkt");
    			super.new(name);
	endfunction
	
	task body();
		repeat(20)
		begin
		req=mst_xtns::type_id::create("mst_xtns");
		start_item(req);
		assert(req.randomize() with{Htrans==2'b10;Hbrust inside{2,4,6};});
		finish_item(req);
		haddr=req.Haddr;
		hbrust=req.Hbrust;
		hsize=req.Hsize;
		hwrite=req.Hwrite;
		length=req.length;
		s_addr=((req.Haddr)/((2**hsize)*(length))*((2**hsize)*(length)));
		b_addr=s_addr+((2**hsize)*(length));
		haddr=haddr+(2**hsize);

		for(int i=1;i<length;i++)
		  begin
			if(haddr>=b_addr)
				haddr=s_addr;
			start_item(req);
			assert(req.randomize()with{Htrans==2'b11;Hsize==hsize;
			                   Hwrite==hwrite;Hbrust==hbrust;Haddr==haddr;});
			finish_item(req);
			haddr=req.Haddr+(2**hsize);
		  end
		end
	endtask
endclass



