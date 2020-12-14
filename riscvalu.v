module alu32(input [31:0] srca,
             input [31:0] srcb,
             input [3:0] alucontrol,
             input [4:0] shamt, 
             output [31:0] aluout,
             output zero);
    
    parameter add = 4'b0000;
    parameter sub = 4'b1000;

    case (alucontrol)
    add:add32 u_add32(srca, srcb, aluout);
    sub:sub32 u_sub32(srca, srcb, aluout);
    endcase
    
endmodule

module b4_carry_lookahead(input [3:0] a,
                          input [3:0] b,
                          input cin,
                          output reg [3:0] s,
                          output cout);
        
        reg [3:0] p;
        reg [3:0] g;
        reg [4:0] c;

        c[0] = cin;
        for (int i = 0; i < 4; i++) begin
            assign p[i] = a[i] ^ b[i];
            assign g[i] = a[i] & b[i];
            assign c[i+1] = g[i] | (p[i] & c[i]);
            assign s[i] = p[i] ^ c[i];
        end

        assign cout = c[4];

endmodule

module add32(input [31:0] srca,
             input [31:0] srcb,
             output reg [31:0] aluout);

    reg [15:0] carry_bits_store;
    reg [7:0] carry_bits;
    reg [31:0] aluout_0;
    reg [31:0] aluout_1;

    b4_carry_lookahead u_b4_carry_lookahead_1(.a(srca[3:0]),
                                              .b(srcb[3:0]),
                                              .cin(0),
                                              .s(aluout[3:0]),
                                              .cout(carry_bits[0]));
    b4_carry_lookahead u_b4_carry_lookahead_2_0(.a(srca[7:4]),
                                                .b(srcb[7:4]),
                                                .cin(0),
                                                .s(aluout_0[7:4]),
                                                .cout(carry_bits_store[2]));
    b4_carry_lookahead u_b4_carry_lookahead_2_1(.a(srca[7:4]),
                                                .b(srcb[7:4]),
                                                .cin(1),
                                                .s(aluout_1[7:4]),
                                                .cout(carry_bits_store[3]));
    b4_carry_lookahead u_b4_carry_lookahead_3_0(.a(srca[11:8]),
                                                .b(srcb[11:8]),
                                                .cin(0),
                                                .s(aluout_0[11:8]),
                                                .cout(carry_bits_store[4]));
    b4_carry_lookahead u_b4_carry_lookahead_3_1(.a(srca[11:8]),
                                                .b(srcb[11:8]),
                                                .cin(1),
                                                .s(aluout_1[11:8]),
                                                .cout(carry_bits_store[5]));
    b4_carry_lookahead u_b4_carry_lookahead_4_0(.a(srca[15:12]),
                                                .b(srcb[15:12]),
                                                .cin(0),
                                                .s(aluout_0[15:12]),
                                                .cout(carry_bits_store[6]));
    b4_carry_lookahead u_b4_carry_lookahead_4_1(.a(srca[15:12]),
                                                .b(srcb[15:12]),
                                                .cin(1),
                                                .s(aluout_1[15:12]),
                                                .cout(carry_bits_store[7]));
    b4_carry_lookahead u_b4_carry_lookahead_5_0(.a(srca[19:16]),
                                                .b(srcb[19:16]),
                                                .cin(0),
                                                .s(aluout_0[19:16]),
                                                .cout(carry_bits_store[8]));
    b4_carry_lookahead u_b4_carry_lookahead_1_1(.a(srca[19:16]),
                                                .b(srcb[19:16]),
                                                .cin(1),
                                                .s(aluout_1[19:16]),
                                                .cout(carry_bits_store[9]));
    b4_carry_lookahead u_b4_carry_lookahead_6_0(.a(srca[23:20]),
                                                .b(srcb[23:20]),
                                                .cin(0),
                                                .s(aluout_0[23:20]),
                                                .cout(carry_bits_store[10]));
    b4_carry_lookahead u_b4_carry_lookahead_6_1(.a(srca[23:20]),
                                                .b(srcb[23:20]),
                                                .cin(1),
                                                .s(aluout_1[23:20]),
                                                .cout(carry_bits_store[11]));
    b4_carry_lookahead u_b4_carry_lookahead_7_0(.a(srca[27:24]),
                                                .b(srcb[27:24]),
                                                .cin(0),
                                                .s(aluout_0[27:24]),
                                                .cout(carry_bits_store[12]));
    b4_carry_lookahead u_b4_carry_lookahead_7_1(.a(srca[27:24]),
                                                .b(srcb[27:24]),
                                                .cin(1),
                                                .s(aluout_1[27:24]),
                                                .cout(carry_bits_store[13]));
    b4_carry_lookahead u_b4_carry_lookahead_8_0(.a(srca[31:28]),
                                                .b(srcb[31:28]),
                                                .cin(0),
                                                .s(aluout_0[31:28]),
                                                .cout(carry_bits_store[14]));
    b4_carry_lookahead u_b4_carry_lookahead_8_1(.a(srca[31:28]),
                                                .b(srcb[31:28]),
                                                .cin(1),
                                                .s(aluout_1[31:28]),
                                                .cout(carry_bits_store[15]));

    mux2 #(4) add_2(aluout_0[7:4], aluout_1[7:4], carry_bits[0], aluout[7:4]);
    mux2 #(1) carry_2(carry_bits_store[2], carry_bits_store[3], carry_bits[0], carry_bits[1]);

    mux2 #(4) add_3(aluout_0[11:8], aluout_1[11:8], carry_bits[1], aluout[11:8]);
    mux2 #(1) carry_3(carry_bits_store[4], carry_bits_store[5], carry_bits[1], carry_bits[2]);

    mux2 #(4) add_4(aluout_0[15:12], aluout_1[15:12], carry_bits[2], aluout[15:12]);
    mux2 #(1) carry_4(carry_bits_store[6], carry_bits_store[7], carry_bits[2], carry_bits[3]);

    mux2 #(4) add_5(aluout_0[19:16], aluout_1[19:16], carry_bits[3], aluout[19:16]);
    mux2 #(1) carry_5(carry_bits_store[8], carry_bits_store[9], carry_bits[3], carry_bits[4]);

    mux2 #(4) add_6(aluout_0[23:20], aluout_1[23:20], carry_bits[4], aluout[23:20]);
    mux2 #(1) carry_6(carry_bits_store[10], carry_bits_store[11], carry_bits[4], carry_bits[5]);

    mux2 #(4) add_7(aluout_0[27:24], aluout_1[27:24], carry_bits[5], aluout[27:24]);
    mux2 #(1) carry_7(carry_bits_store[12], carry_bits_store[13], carry_bits[5], carry_bits[6]);

    mux2 #(4) add_8(aluout_0[31:28], aluout_1[31:28], carry_bits[6], aluout[31:28]);
    mux2 #(1) carry_8(carry_bits_store[14], carry_bits_store[15], carry_bits[6], carry_bits[7]);

endmodule

module complement32(input [31:0] in,
                    output reg [31:0] out);
    
    int flag = 0;
    for (int i = 0; i < 32; i = i + 1) begin
        if (in[i] == 1) begin
            if (flag) out[i] = 0;
            else flag = 1;
        end
        else begin
            if (flag) out[i] = 1;
        end
    end

endmodule

module sub32(input [31:0] srca,
             input [31:0] srcb,
             output reg [31:0] aluout);
    
    reg [31:0] compl_srcb;

    complement32 u_complement32(srcb, compl_srcb);
    add32 u_add32(srca, compl_srcb, aluout);

endmodule