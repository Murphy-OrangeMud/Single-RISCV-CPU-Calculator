// 数据寄存器
module dmem_io(
      input       clk, 
			input			  we,
      input  [31:0] a, 
			input  [31:0] wd,
      output [31:0] rd,
			input [3:0] porta_in, 
			input [15:0] portb_in,			   
			output [15:0] portc_out,
			output [15:0] portd_out
    );

  reg  [31:0] RAM[15:0];
  reg  [31:0] rdata;
  wire	 [31:0] rdata_RAM;
  wire we_dmem;
  wire we_portc;
  wire we_portd;
  
  wire [3:0] porta;
  wire [15:0] portb;
  reg [15:0] portc_reg;
  reg [15:0]  portd_reg;
  
  assign we_dmem = (((a >= 32'h00001000) && (a < 32'h00001800)) ? 1 : 0 ) & we;
  assign we_portc = ( a == 32'h00007f20 );
  assign we_portd = ( a == 32'h00007ffc );
  
  assign porta = porta_in;
  assign portb = portb_in;
  
  assign rdata_RAM = RAM[a[5:2]];

  /*
  // add bcd2bin module here, from input sw to output portb
  binary2BCD u_binary2BCD_b (
    .binary(sw),
    .thousands(portb[15:12]),
    .hundreds(portb[11:8]),
    .tens(portb[7:4]),
    .ones(portb[3:0])
  );
  
  // add bin2bcd and led7seg module here, from input portc_reg to output seg/an
  reg [3:0] thousands;
  reg [3:0] hundreds;
  reg [3:0] tens;
  reg [3:0] ones;
  binary2BCD u_binary2BCD_c (
    .binary(portc_reg),
    .thousands(thousands),
    .hundreds(hundreds),
    .tens(tens),
    .ones(ones)
  );

  reg [0:6] seg;
  reg [0:3] an;
  display_7seg_x4 u_display_7seg_x4 (
    .clk(clk),
    .in0(thousands),
    .in1(hundreds),
    .in2(tens),
    .in3(ones),
    .seg(seg),
    .an(an)
  );*/
  
  // dmem read
  always @(a, porta, portb, portc_reg, portd_reg, rdata_RAM)
    begin
	   if ( a == 32'h0000ff00 )
		  begin rdata = {{28{1'b0}}, porta}; end
		else if ( a == 32'h0000ff10 )
        begin rdata = {{24{1'b0}}, portb}; end
		else if ( a == 32'h0000ff20 )
		  begin rdata = {{16{1'b0}}, portc_reg}; end
		else if ( a == 32'h0000fffc )
		  begin rdata = {{16{1'b0}}, portd_reg}; end
		else
		  rdata = rdata_RAM; // word aligned
    end
  
  // dmem write
  always @(posedge clk)
    if (we_dmem)
      RAM[a[5:2]] <= wd;
		
  always @(posedge clk)
    if (we_portc)
	   portc_reg <= wd;
  
  always @(posedge clk)
    if (we_portd)
	   portd_reg <= wd;
	
  // output assignment
  assign portc_out = portc_reg;
  assign portd_out = portd_reg;
  assign rd = rdata;
endmodule
