/*
 * Generated by Digital. Don't modify this file!
 * Any changes will be lost if this file is regenerated.
 */

module Mux_4x1_NBits #(
    parameter Bits = 2
)
(
    input [1:0] sel,
    input [(Bits - 1):0] in_0,
    input [(Bits - 1):0] in_1,
    input [(Bits - 1):0] in_2,
    input [(Bits - 1):0] in_3,
    output reg [(Bits - 1):0] out
);
    always @ (*) begin
        case (sel)
            2'h0: out = in_0;
            2'h1: out = in_1;
            2'h2: out = in_2;
            2'h3: out = in_3;
            default:
                out = 'h0;
        endcase
    end
endmodule

module DIG_Add
#(
    parameter Bits = 1
)
(
    input [(Bits-1):0] a,
    input [(Bits-1):0] b,
    input c_i,
    output [(Bits - 1):0] s,
    output c_o
);
   wire [Bits:0] temp;

   assign temp = a + b + c_i;
   assign s = temp [(Bits-1):0];
   assign c_o = temp[Bits];
endmodule



// This simple circuit can do all the operations needed to execute Baby8 instructions
module baby8_alu (
  input [1:0] logSel, // select logical operation between A and B or just use B
  input [1:0] aSel, // select A, inverted A or a constant to be added
  input Cin, // carry in
  input [7:0] A,
  input [7:0] B,
  output [7:0] R, // result of the addition
  output Z, // addition had zero result
  output C, // carry out
  output N, // addition had negative result
  output V // addition overflowed

);
  wire [7:0] s0;
  wire [7:0] s1;
  wire [7:0] s2;
  wire [7:0] s3;
  wire [7:0] s4;
  wire [7:0] s5;
  wire [7:0] s6;
  wire [7:0] s7;
  wire [7:0] s8;
  wire [7:0] R_temp;
  wire s9;
  wire s10;
  wire N_temp;
  assign s5 = (A & B);
  assign s6 = (A | B);
  assign s7 = (A ^ B);
  assign s3 = ~ A;
  Mux_4x1_NBits #(
    .Bits(8)
  )
  Mux_4x1_NBits_i0 (
    .sel( aSel ),
    .in_0( A ),
    .in_1( s3 ),
    .in_2( 8'b0 ),
    .in_3( 8'b11111110 ),
    .out( s4 )
  );
  Mux_4x1_NBits #(
    .Bits(8)
  )
  Mux_4x1_NBits_i1 (
    .sel( logSel ),
    .in_0( s5 ),
    .in_1( s6 ),
    .in_2( s7 ),
    .in_3( B ),
    .out( s8 )
  );
  assign s9 = s4[7];
  assign s10 = s8[7];
  assign s0[6:0] = s4[6:0];
  assign s0[7] = s9;
  assign s1[6:0] = s8[6:0];
  assign s1[7] = s10;
  DIG_Add #(
    .Bits(8)
  )
  DIG_Add_i2 (
    .a( s0 ),
    .b( s1 ),
    .c_i( Cin ),
    .s( s2 ),
    .c_o( C )
  );
  assign N_temp = s2[7];
  assign R_temp[6:0] = s2[6:0];
  assign R_temp[7] = N_temp;
  assign V = ((N_temp & ~ s9 & ~ s10) | (~ N_temp & s9 & s10));
  assign Z = ~ (R_temp[0] | R_temp[1] | R_temp[2] | R_temp[3] | R_temp[4] | R_temp[5] | R_temp[6] | R_temp[7]);
  assign R = R_temp;
  assign N = N_temp;
endmodule