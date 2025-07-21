module top;
// import test_pkg
    	import test_pkg::*;
   
	//import uvm_pkg.sv
	import uvm_pkg::*;

   	// Generate clock signal
	bit clock;  
	always 
		#10 clock=!clock;  
	mst_if in0 (clock);
	slave_if in1(clock);
	
	rtl_top DUV(.Hclk(clock),.Hresetn(in0.Hresetn),.Htrans(in0.Htrans),.Hsize(in0.Hsize),.Hreadyin(in0.Hready_in),.Hwdata(in0.Hwdata),.Haddr(in0.Haddr),.Hwrite(in0.Hwrite),.Prdata(in1.Prdata),.Hrdata(in0.Hrdata),.Hresp(in0.Hresp),.Hreadyout(in0.Hready_out),.Pselx(in1.Pselx),.Pwrite(in1.Pwrite),.Penable(in1.Penable),.Paddr(in1.Paddr),.Pwdata(in1.Pwdata));

  

	initial
		begin
			`ifdef VCS
         		$fsdbDumpvars(0, top);
        		`endif

					uvm_config_db #(virtual slave_if)::set(null,"*","sif_0",in1);
					uvm_config_db #(virtual mst_if)::set(null,"*","mif_0",in0);

			run_test();
		end
endmodule
