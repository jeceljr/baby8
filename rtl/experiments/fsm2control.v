/*
 * Generated by Digital. Don't modify this file!
 * Any changes will be lost if this file is regenerated.
 */

module Mux_2x1_NBits #(
    parameter Bits = 2
)
(
    input [0:0] sel,
    input [(Bits - 1):0] in_0,
    input [(Bits - 1):0] in_1,
    output reg [(Bits - 1):0] out
);
    always @ (*) begin
        case (sel)
            1'h0: out = in_0;
            1'h1: out = in_1;
            default:
                out = 'h0;
        endcase
    end
endmodule


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


// special multiplexor that also handles change in PH,PL with interrupt level
module cmux (
  input [3:0] in3, // the selection is extracted from this input
  input [3:0] in2,
  input [3:0] in1,
  input [3:0] in0,
  input curInt, // current Interrupt level
  output [3:0] out,
  output sel0
);
  wire s0;
  wire s1;
  wire s2;
  wire s3;
  wire s4;
  wire s5;
  wire s6;
  wire [1:0] s7;
  wire [3:0] s8;
  assign s0 = in3[0];
  assign s1 = in3[1];
  assign s2 = in3[2];
  assign s3 = in3[3];
  assign s4 = (s2 | s3);
  assign s8[0] = s0;
  assign s8[1] = s2;
  assign s8[2] = (s2 ^ (s1 & s2 & s3 & curInt));
  assign s8[3] = s3;
  assign s5 = (s1 | s4);
  assign s6 = (s0 | s4);
  assign s7[0] = s6;
  assign s7[1] = s5;
  assign sel0 = ~ (s6 | s5);
  Mux_4x1_NBits #(
    .Bits(4)
  )
  Mux_4x1_NBits_i0 (
    .sel( s7 ),
    .in_0( in0 ),
    .in_1( in1 ),
    .in_2( in2 ),
    .in_3( s8 ),
    .out( out )
  );
endmodule

module Mux_8x1_NBits #(
    parameter Bits = 2
)
(
    input [2:0] sel,
    input [(Bits - 1):0] in_0,
    input [(Bits - 1):0] in_1,
    input [(Bits - 1):0] in_2,
    input [(Bits - 1):0] in_3,
    input [(Bits - 1):0] in_4,
    input [(Bits - 1):0] in_5,
    input [(Bits - 1):0] in_6,
    input [(Bits - 1):0] in_7,
    output reg [(Bits - 1):0] out
);
    always @ (*) begin
        case (sel)
            3'h0: out = in_0;
            3'h1: out = in_1;
            3'h2: out = in_2;
            3'h3: out = in_3;
            3'h4: out = in_4;
            3'h5: out = in_5;
            3'h6: out = in_6;
            3'h7: out = in_7;
            default:
                out = 'h0;
        endcase
    end
endmodule


module Mux_4x1
(
    input [1:0] sel,
    input in_0,
    input in_1,
    input in_2,
    input in_3,
    output reg out
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


module Demux2
#(
    parameter Default = 0 
)
(
    output out_0,
    output out_1,
    output out_2,
    output out_3,
    input [1:0] sel,
    input in
);
    assign out_0 = (sel == 2'h0)? in : Default;
    assign out_1 = (sel == 2'h1)? in : Default;
    assign out_2 = (sel == 2'h2)? in : Default;
    assign out_3 = (sel == 2'h3)? in : Default;
endmodule


// converts the encoded outputs from the Finite State Machine into the actual
// values used by the datapath
module fsm2control (
  input [3:0] wAdIn, // raw address for register to write
  input [3:0] aAdIn, // raw address for first operand
  input [3:0] bAdIn, // raw address for second operand
  input [1:0] bSelIn, // raw selection of second operand
  input [1:0] logSelIn, // raw selection of logic operation
  input [1:0] aSelIn, // raw selection of first operand
  input [1:0] CinIn, // raw selection of carry in calculation
  input [3:0] \reg , // low 4 bits of zero page address
  input [1:0] svS, // saved source field in instruction
  input curInt,
  input [1:0] svD, // saved destination field of instruction
  input prevK, // previous instruction was of the cascade type
  input useK, // current instruction is of the cascade type
  input svZIO, // the last zero page address was to an i/o port
  input svZReg, // the last zero page address was in the register range
  input svZInd, // indicates we are in an indirect zero page address
  input [2:0] svAluOp, // the saved ALU operation bits from the instruction
                       // (only 6 combinations are valid)
  input tr, // test result using saved flags
  output [3:0] wAd, // register to write
  output [3:0] aAd, // register to read for second operand
  output [3:0] bAd, // register to read for first operand
  output [1:0] bSel, // use register, memory or i/o as operand
  output [1:0] logSel, // logical operation
  output [1:0] aSel, // normal, inverted or constant
  output Cin, // output carry in for ALU
  output out3, // output port 3 should load dOut
  output out2, // output port 2 should load dOut
  output out1, // output port 1 should load dOut
  output out0 // output port 0 should load dOut

);
  wire [3:0] s0;
  wire [3:0] kD2;
  wire [3:0] s1;
  wire s2;
  wire [3:0] kD;
  wire [1:0] r2;
  wire s3;
  wire [2:0] s4;
  wire [1:0] s5;
  wire [1:0] memz;
  wire [1:0] mL;
  wire [1:0] mA;
  wire mCin;
  wire s6;
  wire s7;
  wire [1:0] s8;
  assign s0[1:0] = svS;
  assign s0[3:2] = 2'b0;
  assign s1[1:0] = svD;
  assign s1[3:2] = 2'b0;
  assign s4[0] = svZIO;
  assign s4[1] = svZReg;
  assign s4[2] = svZInd;
  assign r2 = \reg [1:0];
  assign s6 = svAluOp[2];
  assign s8 = svAluOp[1:0];
  assign s7 = svAluOp[2];
  Mux_2x1_NBits #(
    .Bits(4)
  )
  Mux_2x1_NBits_i0 (
    .sel( useK ),
    .in_0( s1 ),
    .in_1( 4'b11 ),
    .out( kD2 )
  );
  Mux_2x1_NBits #(
    .Bits(4)
  )
  Mux_2x1_NBits_i1 (
    .sel( prevK ),
    .in_0( s1 ),
    .in_1( 4'b11 ),
    .out( kD )
  );
  assign s5[0] = r2[0];
  assign s5[1] = 1'b1;
  assign mCin = (svAluOp[0] & ~ s6);
  Mux_2x1_NBits #(
    .Bits(2)
  )
  Mux_2x1_NBits_i2 (
    .sel( s7 ),
    .in_0( s8 ),
    .in_1( 2'b0 ),
    .out( mA )
  );
  Mux_2x1_NBits #(
    .Bits(2)
  )
  Mux_2x1_NBits_i3 (
    .sel( s6 ),
    .in_0( 2'b11 ),
    .in_1( s8 ),
    .out( mL )
  );
  cmux cmux_i4 (
    .in3( wAdIn ),
    .in2( kD2 ),
    .in1( s1 ),
    .in0( \reg  ),
    .curInt( curInt ),
    .out( wAd ),
    .sel0( s2 )
  );
  cmux cmux_i5 (
    .in3( aAdIn ),
    .in2( 4'b0 ),
    .in1( kD ),
    .in0( s0 ),
    .curInt( curInt ),
    .out( aAd )
  );
  cmux cmux_i6 (
    .in3( bAdIn ),
    .in2( 4'b0 ),
    .in1( kD ),
    .in0( \reg  ),
    .curInt( curInt ),
    .out( bAd )
  );
  Mux_8x1_NBits #(
    .Bits(2)
  )
  Mux_8x1_NBits_i7 (
    .sel( s4 ),
    .in_0( 2'b1 ),
    .in_1( 2'b1 ),
    .in_2( 2'b0 ),
    .in_3( s5 ),
    .in_4( 2'b1 ),
    .in_5( 2'b1 ),
    .in_6( 2'b1 ),
    .in_7( 2'b1 ),
    .out( memz )
  );
  Mux_4x1_NBits #(
    .Bits(2)
  )
  Mux_4x1_NBits_i8 (
    .sel( logSelIn ),
    .in_0( 2'b11 ),
    .in_1( mL ),
    .in_2( 2'b10 ),
    .in_3( 2'b0 ),
    .out( logSel )
  );
  Mux_4x1_NBits #(
    .Bits(2)
  )
  Mux_4x1_NBits_i9 (
    .sel( aSelIn ),
    .in_0( 2'b10 ),
    .in_1( 2'b11 ),
    .in_2( mA ),
    .in_3( 2'b0 ),
    .out( aSel )
  );
  Mux_4x1 Mux_4x1_i10 (
    .sel( CinIn ),
    .in_0( 1'b0 ),
    .in_1( 1'b1 ),
    .in_2( mCin ),
    .in_3( tr ),
    .out( Cin )
  );
  assign s3 = (s2 & svZIO & svZReg);
  Mux_4x1_NBits #(
    .Bits(2)
  )
  Mux_4x1_NBits_i11 (
    .sel( bSelIn ),
    .in_0( 2'b0 ),
    .in_1( 2'b1 ),
    .in_2( memz ),
    .in_3( 2'b0 ),
    .out( bSel )
  );
  Demux2 #(
    .Default(0)
  )
  Demux2_i12 (
    .sel( r2 ),
    .in( s3 ),
    .out_0( out0 ),
    .out_1( out1 ),
    .out_2( out2 ),
    .out_3( out3 )
  );
endmodule
