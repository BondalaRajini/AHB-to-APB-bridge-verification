class slave_sequencer extends uvm_sequencer #(slave_xtns);
	`uvm_component_utils(slave_sequencer)
	function new(string name="slave_sequencer",uvm_component parent=null);
		super.new(name,parent);
	endfunction
endclass
