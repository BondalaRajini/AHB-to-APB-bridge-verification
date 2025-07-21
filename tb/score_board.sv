class scoreboard extends uvm_scoreboard;
 	`uvm_component_utils(scoreboard)
	mst_xtns m_xtn;
	slave_xtns s_xtn;
	uvm_tlm_analysis_fifo #(mst_xtns) m_fifo;
	uvm_tlm_analysis_fifo#(slave_xtns)s_fifo;
	function new(string name="scoreboard",uvm_component parent=null);
		super.new(name,parent);
			m_cg=new();
		s_cg=new();
	
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		m_fifo=new("m_fifo",this);
		s_fifo=new("s_fifo",this);
	endfunction
	covergroup m_cg;
		option.per_instance=1;

	HADDR :coverpoint m_xtn.Haddr{
		bins slave1={[32'h8000_0000:32'h8000_03ff]};
		bins slave2={[32'h8400_0000:32'h8400_03ff]};
		bins slave3={[32'h8800_0000:32'h8800_03ff]};
		bins slave4={[32'h8c00_0000:32'h8c00_03ff]};

	}
	HSIZE:coverpoint m_xtn.Hsize{
	       bins zero ={0};
	       bins one={1};
	       bins two={2};}
	HWRITE:coverpoint m_xtn.Hwrite{
		bins read_op={0};
		bins write_op={1};}
	HTRANS:coverpoint m_xtn.Htrans{
		bins Non_seq={2};
		bins seq={3};	}
	CROSS: cross HSIZE,HWRITE,HTRANS;
	endgroup
	
	covergroup s_cg;
		option.per_instance=1;

	PADDR:coverpoint s_xtn.Paddr{
		bins slave1={[32'h8000_0000:32'h8000_03ff]};
		bins slave2={[32'h8400_0000:32'h8400_03ff]};
		bins slave3={[32'h8800_0000:32'h8800_03ff]};
		bins slave4={[32'h8c00_0000:32'h8c00_03ff]};}
	PSELX: coverpoint s_xtn.Pselx{
		bins one={1};
		bins two={2};
		bins four={4};
		bins eight={8};}
	PWRITE:coverpoint s_xtn.Pwrite{
		bins read_op={0};
		bins write_op={1};}
	endgroup
		
	task run_phase(uvm_phase phase);
		forever
			begin
				fork
					begin
						m_fifo.get(m_xtn);
						$display("now we are printing mst_mon datain sb");
						m_xtn.print();
						m_cg.sample;
					end
					
			 	 		begin
						s_fifo.get(s_xtn);
						$display("now we are printing mst_mon datain sb");
						s_xtn.print();
						s_cg.sample;
					end
				join
			check1(m_xtn,s_xtn);
		    end
	endtask

	//compare template
	task compare(int Haddr,Paddr,Hwdata,Pwdata);
		if(Haddr==Paddr)
			$display("ADDR SUCESSFULLY COMPARED");
		else
			$display("ADDR COMPARSION IS FAILED");
		if(Hwdata==Pwdata)
			$display("DATA SUCESSFULLY COMPARED");
		else
			$display("DATA COMPARSION IS FAILED");

	endtask

   virtual	task check1 (mst_xtns m_xtn,slave_xtns s_xtn);
	     if(m_xtn.Hwrite)
	       begin
			if(m_xtn.Hsize==2'b00)
			  begin
				if(m_xtn.Haddr[1:0]==2'b00)	
					compare(m_xtn.Haddr,s_xtn.Paddr,m_xtn.Hwdata[7:0],s_xtn.Pwdata);
				if(m_xtn.Haddr[1:0]==2'b01)	
					compare(m_xtn.Haddr,s_xtn.Paddr,m_xtn.Hwdata[15:8],s_xtn.Pwdata);
				if(m_xtn.Haddr[1:0]==2'b10)	
					compare(m_xtn.Haddr,s_xtn.Paddr,m_xtn.Hwdata[23:16],s_xtn.Pwdata);
				if(m_xtn.Haddr[1:0]==2'b11)	
					compare(m_xtn.Haddr,s_xtn.Paddr,m_xtn.Hwdata[31:24],s_xtn.Pwdata);
			end
			
				if(m_xtn.Hsize==2'b01)
			  begin
				if(m_xtn.Haddr[1:0]==2'b00)	
					compare(m_xtn.Haddr,s_xtn.Paddr,m_xtn.Hwdata[15:0],s_xtn.Pwdata);
				if(m_xtn.Haddr[1:0]==2'b10)	
					compare(m_xtn.Haddr,s_xtn.Paddr,m_xtn.Hwdata[31:16],s_xtn.Pwdata);
			end
			
			if(m_xtn.Hsize==2'b10)
			  begin
				compare(m_xtn.Haddr,s_xtn.Paddr,m_xtn.Hwdata,s_xtn.Pwdata);
			  end		
		end

		else
	             begin
			if(m_xtn.Hsize==2'b00)
			  begin
				if(s_xtn.Paddr[1:0]==2'b00)	
					compare(m_xtn.Haddr,s_xtn.Paddr,m_xtn.Hrdata,s_xtn.Prdata[7:0]);
				if(s_xtn.Paddr[1:0]==2'b01)	
					compare(m_xtn.Haddr,s_xtn.Paddr,m_xtn.Hrdata,s_xtn.Prdata[15:8]);
				if(s_xtn.Paddr[1:0]==2'b10)	
					compare(m_xtn.Haddr,s_xtn.Paddr,m_xtn.Hrdata,s_xtn.Prdata[23:16]);
				if(s_xtn.Paddr[1:0]==2'b11)	
					compare(m_xtn.Haddr,s_xtn.Paddr,m_xtn.Hrdata,s_xtn.Prdata[31:24]);
			end
			
				if(m_xtn.Hsize==2'b01)
			  begin
				if(s_xtn.Paddr[1:0]==2'b00)	
					compare(m_xtn.Haddr,s_xtn.Paddr,m_xtn.Hrdata,s_xtn.Prdata[15:0]);
				if(s_xtn.Paddr[1:0]==2'b10)	
					compare(m_xtn.Haddr,s_xtn.Paddr,m_xtn.Hrdata,s_xtn.Prdata[31:16]);
			end
			
			if(m_xtn.Hsize==2'b10)
			  begin
				compare(m_xtn.Haddr,s_xtn.Paddr,m_xtn.Hrdata,s_xtn.Prdata);
			  end		
		end

	endtask

endclass

