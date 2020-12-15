module complement32_tb();
    reg [31:0] srca = 32'h00000eff;
    reg [31:0] srcb = 32'h00000234;

    wire [31:0] aluout;
    wire [4:0] shamt;

    assign shamt = 5'b00000;

    initial begin
        $dumpfile("compl32.vcd");
        $dumpvars(0, t_compl32);
        //$dumpvars(1, u_bin2bcd_czy);
        $monitor("Alu in = %b, aluout = %b", srcb, aluout);

        $finish;
    end

    complement32 t_compl32(srcb, aluout);
    
endmodule
