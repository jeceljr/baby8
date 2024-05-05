# Baby 8

The original Baby 8 processor was an 8 bit CISC multicycle design with a Von Neumann architeture and 16 specialized registers. It used a 128 word by 32 bit microcode ROM to implement
its control unit.

The new Baby 8 design is a single cycle RISC processor with 16 general registers and a simple control unit made from combinational logic. Though it looks like a Harvard architecture
with a 64KB 8bit wide RAM for data and a 16K by 16 bit ROM for instructions, these are actually a single dual port memory that most FPGAs can efficiently implement.

For many instructions two different mnemonics will be indicated. The first will be based on an instruction name in Portuguese inspired by the 1972 Patinho Feio minicomputer while
the second one will be based on a name in English typical of RISC processors.

## Instruction Set

The first instruction format is unique to PUG or JAL (˜Pula e Guarda" or "Jump And Link"). The top two bits are 00 and the bottom 14 bits are the destination address divided by two.
Instructions must always be on even addresses. The PC is set to the indicated address while the Link register saves the address of the following instruction.

The second instruction format is

| 15 14 | 13 12 | 11 | 10 9 8 | 7 6 5 4 | 3 2 1 0 |
|-------|-------|----|--------|---------|---------|
| 0 1 | cond | K | op | source | destination |

The *op* field can be:

- 000:  SOM rD,rS (or ADD rD,rS)
- 001:  SUB rD,rS
- 010:  DEC rD,rS
- 011:  INC rD,rS
- 100:  E rD,rS (or AND rD,rS)
- 101:  OU rD,rS (or OR rD,rS)
- 110:  OUX rD,rS (or XOR, rD,rS)
- 111:  MOV rD,rS

This is, at first glance, a two address instruction set where the destination supplies one of the operands and is also where the result is stored.

### Conditional execution

If the condition specified by the *cond* field is not met, then the instruction following the current one is skipped. At the assembly level this is indicated by a "?" at the end of
the line followed by the condition:

- 00: always execute
- 01: execute if carry (?C)
- 10: execute if not zero (?NZ)
- 11: execute if zero (?Z)

An example would be

```
    SOM r3,r5 ?C
    INC r4,r4
    SOM r4,r6
```

which adds register 5 to the previous contents of register 3 and executes the next instruction if a carry was produced. This instruction essentially propagates the carry
to register 4, which then gets its value added to that of register 6. This is how a strictly 8 bit processor like Baby 8 can do a 16 bit addition between the old value
of the pair r3,r4 and the value of the pair r5,r6.

### Cascade

An extra register, called K, always has the value produced by the previous instruction. This can be used to allow some sequences to operate as a 3 address instruction set at the
cost of a single bit (bit 11, also called "K" in the instruction) instead of the 4 that would normally be required. These would be wasted in most code, while a strict 2 address
instruction set will at times require extra instructions to shuffle around registers.

At the assembly level, an extra "K" is shown as the leftmost argument of 3 in the first instruction and as an extra second argument in the second instruction:

```
    SOM K,r6,r7
    E r10,K,r1
```

The second instruction produces the exact same binary as "E r10,r1" but since it does "r10 := K AND r1" instead of the usual "r10 := r10 AND r1" it is best to use the alternative
syntax to make things clear to the reader. The operation of the two instructions is "r10 := (r6 + r7) AND r1".

### Data memory

The memory access instructions have a very similar format to the previous one:

| 15 | 14 | 13 12 | 11 | 10 9 8 | 7 6 5 4 | 3 2 1 0 |
|----|----|-------|----|--------|---------|---------|
| 1 | dir | cond | 0 | mode | high | low |

The *dir* field indicates if the instruction is CAR or LD (for "CARrega or "LoaD") if it is a 0 and ARM or ST (for "ARMazena" or "STore") if it is a 1. The address is formed by the contents of
the two indicated registers. In the case of a write to memory, the data is the result of the previous instruction (the "K" register). In the csae of a read from memory, the data will
only arrive in time for the following instruction and it will be used as an operand in places of the destination.

The mode bits will indicate an operation on the low register and will appear in the assembly as the following arguments:

- 000: rH,rL (normal address)
- 001: rH,rL++ (post increment)
- 010: rH,rL-- (post decrement)
- 011: rH,rL (normal address)
- 100: rH,rL (normal address)
- 101: rH,++rL (pre increment)
- 110: rH,--rL (pre decrement)
- 111: rH,rL (normal address)

Note that the increments and decrements are 8 bit only and so might give the wrong result if there is a carry
or borrow that is supposed to affect rH. The case of post operations it is not so bad since this can be detected and corrected after the memory access. But for pre operations the wrong
address will be used, so these modes have a more limited use.

Four different modes indicate normal addressing, but we only need one of them. So we will redefine modes 011 and 111 to actually load the address into the PC and the memory access will
be disabled. The syntax for that is "PR rH,rL" (for "Pula para Registradores") or "JR rH, rL" (for "Jump to Registers").

### Special loads

The memory instruction are not to be used with the "K" bit, so this encoding can be used for special instructions. In the case if reads the mode will indicate what should be loaded into
the K register instead of the result:

- 000: K LinkL (load the low 7 bits of Link times 2 into K)
- 001: K LinkH (load the high 7 bits of Link into K)
- 010: K #n (load the 8 bit constant represented by the high and low fields into K)
- 011: K in3 (load input 3 into K)

Optionally, the remaning modes can implement loading inputs 4 to 7 into K. There never are inputs 0 to 2. Note that the first two must be used to store the Link register somewhere at the
start of a subroutine so the PR (or JR) instruction can later return from that subroutine. A stack can be used to allow recursion.

In the case of memory writes, the "K" bit only makes the processor assert the IOWR pin instead of the MEMWR pin. This makes it easy to add output ports without having to decode many address
lines.

### Exact timing

Having two cascade instructions in a row is not very useful, so this will be used to implement a simpler timer "for free". More sophisticated timing needs will require extra hardware connected
to the I/O ports, but a sequence like>

```
    K #45
    SUB K,r1,r3
```

Will stop fetching new instructions and will do the subtraction over and over until the result is 0. The value of r1 is completely ignored due to the previous instruction also being a cascade,
so the value of r3 is getting subtracted from the current value of K. Supposing that r3 is initialized to 1, these two instructions will take exactly 46 clock cycles to execute. Most pairs
of cascade instructions do not produce interesting results, though a special load could be used to wait for a zero on a given input port.
