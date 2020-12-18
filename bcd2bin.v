module BCD2Binary(
  input [3:0] thousands,
  input [3:0] hundreds,
  input [3:0] tens,
  input [3:0] ones,
  output reg [15:0] binary
);

  reg [31:0] shifter;
  integer i;

  always @(ones or tens or hundreds or thousands)
  begin
    shifter[31:28] = thousands;
    shifter[27:24] = hundreds;
    shifter[23:20] = tens;
    shifter[19:16] = ones;
    shifter[15:0] = 0;
    for (i = 0; i < 16; i = i + 1)
    begin
      shifter = shifter >> 1;
      if (shifter[31:28] >= 8)
        shifter[31:28] = shifter[31:28] - 3;
      if (shifter[27:24] >= 8)
        shifter[27:24] = shifter[27:24] - 3;
      if (shifter[23:20] >= 8)
        shifter[23:20] = shifter[23:20] - 3;
      if (shifter[19:16] >= 8)
        shifter[19:16] = shifter[19:16] - 3;
    end
    binary = shifter[15:0];
  end
endmodule