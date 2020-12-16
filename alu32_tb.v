module alu32_tb();
    reg [31:0] srcb = 32'h00000eff;
    reg [31:0] srca = 32'h00000234;

    wire [31:0] aluout;
    wire [4:0] shamt;
    wire [3:0] alucontrol;
    wire zero;

    assign shamt = 5'b00000;
    assign alucontrol = 4'b1000;

    initial begin
        $dumpfile("alu32.vcd");
        $dumpvars(0, t_alu32);
        //$dumpvars(1, u_bin2bcd_czy);
        $monitor("Alu srca = %b, Alu srcb = %b, aluout = %b", srca, srcb, aluout);

        $finish;
    end

    alu32 t_alu32(srca, srcb, alucontrol, shamt, aluout, zero);
    

endmodule