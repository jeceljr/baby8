# baby8

The great thing about FPGAs is that you can implement
a fully hardware solution when interfacing with different
i/o devices. Each block can work in parallel with all the
other blocks so timing constraints are easier to satisfy.

The problem is that this hardware consumes FPGA resources
that could be used for the main project. An alternative is
to have a small "soft core" processor implementing i/o in
software. This saves resources in two ways: the bits in
the block RAMs are tiny compared to the separate flip-flops
in the configurable blocks, and a processor will time
multiplex things like adders while the hardware solution
will have multiple copies that sit unused most of the time.

The performance has only to be high enough to implement
the particular protocol, so the trade-off is fewer resources
at the cost of speed.

Baby8 is an 8 bit CISC variation of the 32 bit RISC Baby42
design. The number of instructions is not large but any
instruction can access arbitrary memory locations. There
are features like post-increment addressing that are no
faster than doing various instructions in a RISC, but they
do make the programs more compact and might allow fewer
block RAMs to be used.
