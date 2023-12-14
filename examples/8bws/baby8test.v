
`include "hvsync_generator.v"

module top(clk, reset, hsync, vsync, rgb);

  input clk, reset;
  output hsync, vsync;
  output [2:0] rgb;
  wire display_on;
  wire [8:0] hpos;
  wire [8:0] vpos;

  hvsync_generator hvsync_gen(
    .clk(clk),
    .reset(reset),
    .hsync(hsync),
    .vsync(vsync),
    .display_on(display_on),
    .hpos(hpos),
    .vpos(vpos)
  );

  wire r = display_on && hpos[4];
  wire g = display_on && vpos[4];
  wire b = display_on && hpos[0];
  assign rgb = {b,g,r};

  reg [7:0] rom[0:1023];

  initial begin
‘ifdef EXT_INLINE_ASM
rom = ’{
__asm
.arch femto8
.len 1024
          ; should assemble the following instructions
          ; as 00 to FF in order, with instructions that
          ; have two or more bytes with 00 values (with
          ; two exceptions near the end)
zp:
          w += w        ; 00
          x += w        ; 01
          y += w        ; 02
          zp += w       ; 03 00
          w += x        ; 04
          x += x        ; 05
          y += x        ; 06
          zp += x       ; 07 00
          w += y        ; 08
          x += y        ; 09
          y += y        ; 0A
          zp += y       ; 0B 00
          w += zp       ; 0C 00
          x += zp       ; 0D 00
          y += zp       ; 0E 00
          zp += zp      ; 0F 00 00
          k = w + w     ; 10
          k = x + w     ; 11
          k = y + w     ; 12
          k = zp + w    ; 13 00
          k = w + x     ; 14
          k = x + x     ; 15
          k = y + x     ; 16
          k = zp + x    ; 17 00
          k = w + y     ; 18
          k = x + y     ; 19
          k = y + y     ; 1A
          k = zp + y    ; 1B 00
          k = w + zp    ; 1C 00
          k = x + zp    ; 1D 00
          k = y + zp    ; 1E 00
          k = zp + zp   ; 1F 00 00
          w -= w        ; 20
          x -= w        ; 21
          y -= w        ; 22
          zp -= w       ; 23 00
          w -= x        ; 24
          x -= x        ; 25
          y -= x        ; 26
          zp -= x       ; 27 00
          w -= y        ; 28
          x -= y        ; 29
          y -= y        ; 2A
          zp -= y       ; 2B 00
          w -= zp       ; 2C 00
          x -= zp       ; 2D 00
          y -= zp       ; 2E 00
          zp -= zp      ; 2F 00 00
          k = w - w     ; 30
          k = x - w     ; 31
          k = y - w     ; 32
          k = zp - w    ; 33 00
          k = w - x     ; 34
          k = x - x     ; 35
          k = y - x     ; 36
          k = zp - x    ; 37 00
          k = w - y     ; 38
          k = x - y     ; 39
          k = y - y     ; 3A
          k = zp - y    ; 3B 00
          k = w - zp    ; 3C 00
          k = x - zp    ; 3D 00
          k = y - zp    ; 3E 00
          k = zp - zp   ; 3F 00 00
          w = w         ; 40
          x = w         ; 41
          y = w         ; 42
          zp = w        ; 43 00
          w = x         ; 44
          x = x         ; 45
          y = x         ; 46
          zp = x        ; 47 00
          w = y         ; 48
          x = y         ; 49
          y = y         ; 4A
          zp = y        ; 4B 00
          w = zp        ; 4C 00
          x = zp        ; 4D 00
          y = zp        ; 4E 00
          zp = zp       ; 4F 00 00
          k = w = w     ; 50
          k = x = w     ; 51
          k = y = w     ; 52
          k = zp = w    ; 53 00
          k = w = x     ; 54
          k = x = x     ; 55
          k = y = x     ; 56
          k = zp = x    ; 57 00
          k = w = y     ; 58
          k = x = y     ; 59
          k = y = y     ; 5A
          k = zp = y    ; 5B 00
          k = w = zp    ; 5C 00
          k = x = zp    ; 5D 00
          k = y = zp    ; 5E 00
          k = zp = zp   ; 5F 00 00
          Z ?           ; 60
          ;!Z ?          ; 61
          C ?           ; 62
          ;!C ?          ; 63
          N ?           ; 64
          ;!N ?          ; 65
          V ?           ; 66
          ;!V ?          ; 67
          ;> ?           ; 68
          ;<= ?          ; 69
          ;$>= ?         ; 6A
          ;$< ?          ; 6B
          ;$> ?          ; 6C
          ;$<= ?         ; 6D
          true ?        ; 6E
          false ?       ; 6F
          k = Z         ; 70
          k = !Z        ; 71
          k = C         ; 72
          k = !C        ; 73
          k = N         ; 74
          k = !N        ; 75
          k = V         ; 76
          k = !V        ; 77
          k = >         ; 78
          k = <=        ; 79
          k = $>=       ; 7A
          k = $<        ; 7B
          k = $>        ; 7C
          k = $<=       ; 7D
          k = true      ; 7E
          k = false     ; 7F
          w &= w        ; 80
          x &= w        ; 81
          y &= w        ; 82
          zp &= w       ; 83 00
          w &= x        ; 84
          x &= x        ; 85
          y &= x        ; 86
          zp &= x       ; 87 00
          w &= y        ; 88
          x &= y        ; 89
          y &= y        ; 8A
          zp &= y       ; 8B 00
          w &= zp       ; 8C 00
          x &= zp       ; 8D 00
          y &= zp       ; 8E 00
          zp &= zp      ; 8F 00 00
          k = w & w     ; 90
          k = x & w     ; 91
          k = y & w     ; 92
          k = zp & w    ; 93 00
          k = w & x     ; 94
          k = x & x     ; 95
          k = y & x     ; 96
          k = zp & x    ; 97 00
          k = w & y     ; 98
          k = x & y     ; 99
          k = y & y     ; 9A
          k = zp & y    ; 9B 00
          k = w & zp    ; 9C 00
          k = x & zp    ; 9D 00
          k = y & zp    ; 9E 00
          k = zp & zp   ; 9F 00 00
          w |= w        ; A0
          x |= w        ; A1
          y |= w        ; A2
          zp |= w       ; A3 00
          w |= x        ; A4
          x |= x        ; A5
          y |= x        ; A6
          zp |= x       ; A7 00
          w |= y        ; A8
          x |= y        ; A9
          y |= y        ; AA
          zp |= y       ; AB 00
          w |= zp       ; AC 00
          x |= zp       ; AD 00
          y |= zp       ; AE 00
          zp |= zp      ; AF 00 00
          k = w | w     ; B0
          k = x | w     ; B1
          k = y | w     ; B2
          k = zp | w    ; B3 00
          k = w | x     ; B4
          k = x | x     ; B5
          k = y | x     ; B6
          k = zp | x    ; B7 00
          k = w | y     ; B8
          k = x | y     ; B9
          k = y | y     ; BA
          k = zp | y    ; BB 00
          k = w | zp    ; BC 00
          k = x | zp    ; BD 00
          k = y | zp    ; BE 00
          k = zp | zp   ; BF 00 00
          w ^= w        ; C0
          x ^= w        ; C1
          y ^= w        ; C2
          zp ^= w       ; C3 00
          w ^= x        ; C4
          x ^= x        ; C5
          y ^= x        ; C6
          zp ^= x       ; C7 00
          w ^= y        ; C8
          x ^= y        ; C9
          y ^= y        ; CA
          zp ^= y       ; CB 00
          w ^= zp       ; CC 00
          x ^= zp       ; CD 00
          y ^= zp       ; CE 00
          zp ^= zp      ; CF 00 00
          k = w ^ w     ; D0
          k = x ^ w     ; D1
          k = y ^ w     ; D2
          k = zp ^ w    ; D3 00
          k = w ^ x     ; D4
          k = x ^ x     ; D5
          k = y ^ x     ; D6
          k = zp ^ x    ; D7 00
          k = w ^ y     ; D8
          k = x ^ y     ; D9
          k = y ^ y     ; DA
          k = zp ^ y    ; DB 00
          k = w ^ zp    ; DC 00
          k = x ^ zp    ; DD 00
          k = y ^ zp    ; DE 00
          k = zp ^ zp   ; DF 00 00
          w += #0       ; E0 00
          x += #0       ; E1 00
          y += #0       ; E2 00
          zp += #0      ; E3 00 00
          w -= #0       ; E4 00
          x -= #0       ; E5 00
          y -= #0       ; E6 00
          zp -= #0      ; E7 00 00
          w = #0        ; E8 00
          x = #0        ; E9 00
          y = #0        ; EA 00
          zp = #0       ; EB 00 00
          >>>> zp       ; EC 00 00
          >>>>$ zp      ; ED 00 00
          ~             ; EE
          <<<<          ; EF
          w &= #0       ; F0 00
          x &= #0       ; F1 00
          y &= #0       ; F2 00
          zp &= #0      ; F3 00 00
          w |= #0       ; F4 00
          x |= #0       ; F5 00
          y |= #0       ; F6 00
          zp |= #0      ; F7 00 00
          w ^= #0       ; F8 00
          x ^= #0       ; F9 00
          y ^= #0       ; FA 00
          zp ^= #0      ; FB 00 00
          >>>> *zp      ; FC 80
          ;>>>>$ *zp     ; FD 80
          >>>># 0       ; FE 00
          <<<< zp       ; FF 00
__endasm
};
‘endif
  end

endmodule
