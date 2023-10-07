# simple experiments in RTL

A spreadsheet (softcoresizes.ods) shows
the results of using the Yosys tool to
synthesize several processors and simple
blocks from Verilog to the following FPGAs:

- Lattice ICE40
- Gowin
- Intel Cyclone V
- AMD/Xilinx XC7 series

Note that some cores include the main memories
while most don't.

## RISC-V cores

- darkriscv
- glacial
- serv
- picorv32
- riscv_simple (RV32I, RV32IM), (Unicycle, Multicycle, Pipeline)

The numbers for riscv_simple shouldn't be trusted as Yosys
seems to be completely optimizing one of the memories away.

## Other cores

- 6502 and ukp from Nestang
- MCPU
- j0 from Gameduino (multiplier and no multiplier)
- MiniCPU_SerPCU + MiniCPU_SerALU
- ZPU avalanche
- Cray 1

## building blocks for Baby 8

- logic functions in ALU
- complete ALU
- complete datapath

## Digital blocks test

- two port registers
- block ram

Note that the Digital versions use clock circuits and blocks
that can't be exported to Verilog, so to get the .v versions
these were replaced with input pins
