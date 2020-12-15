module add32_tb();
    reg [31:0] srca = 32'h00000eff;
    reg [31:0] srcb = 32'h00000234;

    wire [31:0] aluout;
    wire [4:0] shamt;

    assign shamt = 5'b00000;

    initial begin
        $dumpfile("add32.vcd");
        $dumpvars(0, t_add32);
        //$dumpvars(1, u_bin2bcd_czy);
        $monitor("Alu srca = %b, Alu srcb = %b, aluout = %b", srca, srcb, aluout);

        $finish;
    end

    add32 t_add32(srca, srcb, aluout);
    
endmodule
