// 指令寄存器
module imem (input [7:0] a,
				output [31:0] rd);

	reg [31:0] RAM[256:0];

	initial
	begin
		$readmemh ("calculatortest.dat",RAM);
	end

	assign rd = RAM[a]; // word aligned

endmodule
