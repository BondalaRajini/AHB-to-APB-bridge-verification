class mst_xtns extends uvm_sequence_item;
	`uvm_object_utils(mst_xtns)
		
	function new(string name="mst_xtns");
	super.new(name);
	endfunction

	bit Hresetn,Hready_in; 
	rand bit Hwrite;
	rand bit [1:0] Htrans;
	rand bit[31:0] Hwdata,Haddr;
	rand bit[2:0] Hbrust,Hsize;
	rand bit [9:0] length;
	bit [31:0] Hrdata;
	bit [1:0] Hresp;
	bit Hready_out;
	
	constraint valid_Haddr {Haddr inside{[32'h8000_0000:32'h8000_03ff],[32'h8400_0000:32'h8400_03ff],
						[32'h8800_0000:32'h8800_03ff],[32'h8c00_0000:32'h8c00_03ff]};}
	constraint valid_Hsize {Hsize inside {0,1,2};}
	constraint aligned {(Hsize==1)->Haddr%2==0;(Hsize==2)->Haddr%4==0;}
	constraint c1{(Haddr%1024+(length*(2**Hsize))<=1023);}
	constraint valid_length{(Hbrust==2)->length==4;(Hbrust==3)->length==4;
				(Hbrust==4)->length==8;(Hbrust==5)->length==8;
				 (Hbrust==6)->length==16;(Hbrust==7)->length==16;}
	constraint c2{Hwrite dist{ 0:=50,1:=50};}

	
	function void do_print(uvm_printer printer);
		super.do_print(printer);
	printer.print_field("Hresetn",this.Hresetn,1,UVM_DEC);
	printer.print_field("Hready_in",this.Hready_in,1,UVM_DEC);
	printer.print_field("Hwrite",this.Hwrite,1,UVM_DEC);
	printer.print_field("Htrans",this.Htrans,2,UVM_DEC);
	printer.print_field("Hbrust",this.Hbrust,3,UVM_DEC);
	printer.print_field("Hsize",this.Hsize,3,UVM_DEC);
	printer.print_field("Hwdata",this.Hwdata,32,UVM_DEC);
	printer.print_field("Haddr",this.Haddr,32,UVM_DEC);
	printer.print_field("Hrdata",this.Hrdata,32,UVM_DEC);
	printer.print_field("Hresp",this.Hresp,1,UVM_DEC);
	printer.print_field("Hready_out",this.Hready_out,2,UVM_DEC);

	endfunction

endclass

