module binary2BCD(
  input [15:0] binary,
  output reg [3:0] thousands,
  output reg [3:0] hundreds,
  output reg [3:0] tens,
  output reg [3:0] ones
  ); 
  
  reg [31:0] shifter; 
  integer i;
 
  always @(binary) 
  begin 
    shifter[15:0] = binary;
    shifter[31:16] = 0; 
    
    for (i = 0; i< 14; i = i+1) begin 
        if (shifter[19:16] >= 5) 
            shifter[19:16] = shifter[19:16] + 3; 
        if (shifter[23:20] >= 5)             
            shifter[23:20] = shifter[23:20] + 3;
        if (shifter[27:24] >= 5)             
            shifter[27:24] = shifter[27:24] + 3; 
        if (shifter[31:28] >= 5)              
            shifter[31:28] = shifter[31:28] + 3; 
        shifter = shifter << 1;    
    end  
    
    thousands = shifter[31:28];
    hundreds = shifter[27:24];
    tens = shifter[23:20];
    ones = shifter[19:16];
  end

endmodule
