# assembly examples for Baby 8

These examples are meant to test both the tools, such as the
assembler, and the implementation of the Baby 8 processor.

## sieve.s

This a quick and dirty translation of an implementation
in Basic of the famous Sieve of Eratosthenes benchmark that was
published in Byte Magazine in the early 1980s. The program does
a number of passes (currently just 1) where it sets an array
representing all integers up to 8190. It then finds prime numbers
by eliminating all multiples of previously found prime numbers and
prints the count of how many were found.

The program uses a single output port which shows characters written
there on the simulated terminal window.

A few macros are defined (FOR, add16, mov16, setFP and convBase) to make
the program more readable. Though this hides the awkwardness of handling
16 bit values the code still gets expanded in the actual output.