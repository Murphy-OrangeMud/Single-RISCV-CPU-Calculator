module singleriscv_tb();

  reg clk;
  reg btnC, btnU, btnL, btnD, btnR; 
  reg [15:0] sw;
  wire [15:0] led;
  wire [6:0] seg;
  wire [3:0] an;

  wire [3:0] btn;
  wire [31:0] pc, instr;
  wire [31:0] dmem_address, writedata, readdata; 
  wire memwrite; 
  
  wire [15:0] portb_in;
  wire [15:0] portc_out;
  wire [15:0] portd_out;
  
  assign bnt = {btnL, btnC, btnR, btnU}; // add, sub, multiply, =
  //assign portb_in = sw;		// You need connect this portb_in to output of BCD2Bin module which input is sw;

  BCD2Binary u_BCD2Binary(
    .thousands(sw[15:12]),
    .hundreds(sw[11:8]),
    .tens(sw[7:4]),
    .ones(sw[3:0]),
    .binary(portb_in)
  );
  
  // instantiate devices to be tested
  singleriscv u_singleriscv(mclk, reset_global, pc, instr,
           memwrite, dmem_address, writedata, readdata);
			  
  imem imem(pc[9:2], instr);
  
  dmem_io dmem_io(mclk, memwrite, dmem_address, 
            writedata, readdata, btn, portb_in, portc_out, portd_out);

  assign led = portd_out;
  //assign seg = 0;		// You need connect this IO to output of LED Driver which input is portc_out
  //assign an = 4'b1111;		// You need connect this IO to output of LED Driver which input is portc_out
  assign btn = {btnL, btnC, btnR, btnU};

  wire [3:0] thousands;
  wire [3:0] hundreds;
  wire [3:0] tens;
  wire [3:0] ones;

  binary2BCD u_binary2BCD(
    .binary(portc_out),
    .thousands(thousands),
    .hundreds(hundreds),
    .tens(tens),
    .ones(ones)
  );

  display_7seg_x4 u_display_7seg_x4(
    .CLK(clk),
    .in0(portc_out[3:0]),
    .in1(portc_out[7:4]),
    .in2(portc_out[11:8]),
    .in3(portc_out[15:12]),
    .seg(seg),
    .an(an)
  );

  // initialize input
  initial
    begin
      {btnL, btnC, btnR, btnU} = 0;	    
      sw <= 16'b1;
      cnt <= 32'b0;
      btnD <= 1; # 40; btnD <= 0;
    end

  assign reset_global = btnD;

  // generate clock to sequence tests
  always
    begin
      # 20;
      clk <= 1; # 20; 
      cnt <= cnt + 1;
      clk <= 0;
    end

  assign mclk = clk;

  always
    begin
      # 100000;
      sw <= 16'h05;
      # 100000;
      {btnL, btnC, btnR, btnU} <= 4'b0010;
      # 100000;
      {btnL, btnC, btnR, btnU} <= 4'b0000;
      # 100000;
      sw <= 16'h0a;
      # 100000;
      {btnL, btnC, btnR, btnU} <= 4'b0001;
      # 1000;
      {btnL, btnC, btnR, btnU} <= 4'b0000;
    end

  always @(negedge clk)
    begin
      if (memwrite) begin
        $display("write port: %h, data: %d", dmem_address, writedata);
        if (writedata == 50) $stop;
      end
    end
  
  /*
  // check results
  always@(negedge clk)
    begin
      if(memwrite) begin
        if(dmem_address == 32'h00007ffc & writedata == 1) begin
          $display("Simulation succeeded");
			 $stop;
		  end
        else $display("Simulation Continue...");
        //$stop;
      end
    end
  */
endmodule
