class slave_xtns extends uvm_sequence_item;
	`uvm_object_utils(slave_xtns)
	
	function new(string name="slave_xtns");
	super.new(name);
	endfunction
	
	rand bit [31:0]Prdata;
	bit Penable,Pwrite;
	bit [3:0]Pselx;
	bit[31:0] Pwdata,Paddr;
	
	function void do_print(uvm_printer printer);
		super.do_print(printer);
	printer.print_field("pselx",this.Pselx,4,UVM_DEC);
	printer.print_field("pwrite",this.Pwrite,1,UVM_DEC);
	printer.print_field("penable",this.Penable,1,UVM_DEC);
	printer.print_field("paddr",this.Paddr,32,UVM_DEC);
	printer.print_field("prdata",this.Prdata,32,UVM_DEC);
	printer.print_field("pwdata",this.Pwdata,32,UVM_DEC);
	endfunction
endclass

