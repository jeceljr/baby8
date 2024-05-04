# Baby 8

The original Baby 8 processor was an 8 bit CISC multicycle design with a Von Neumann architeture and 16 specialized registers. It used a 128 word by 32 bit microcode ROM to implement
its control unit.

The new Baby 8 design is a single cycle RISC processor with 16 general registers and a simple control unit made from combinational logic. Though it looks like a Harvard architecture
with a 64KB 8bit wide RAM for data and a 16K by 16 bit ROM for instructions, these are actually a single dual port memory that most FPGAs can efficiently implement.

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
