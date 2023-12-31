# simple experiments in RTL

A spreadsheet **softcoresizes.ods** (and its
generated PDF version) shows
the results of using the Yosys tool to
synthesize several processors and simple
blocks from Verilog to the following FPGAs:

- just NAND gates
- Lattice ICE40
- Gowin
- Intel Cyclone V
- AMD/Xilinx XC7 series

## RISC-V cores

### [darkriscv](https://github.com/darklife/darkriscv.git)
### [glacial](https://github.com/brouhaha/glacial.git)
### [serv](https://github.com/olofk/serv.git)
### [picorv32](https://github.com/cliffordwolf/picorv32.git)
### [VexRsicv](https://github.com/SpinalHDL/VexRiscv) as [translated to Verilog](https://github.com/efabless/caravel_mgmt_soc_gf180mcu/blob/main/verilog/rtl/VexRiscv_MinDebugCache.v) from SpinalHDL for use in the Caravel chip framework

## Other cores

### femto8 and femto16 simple processors from [the 8bitworkshop](https://8bitworkshop.com/)
### 6502 and ukp from [Nestang](https://github.com/nand2mario/nestang.git)
### [MCPU](https://github.com/cpldcpu/MCPU.git)
### j0 from Gameduino (multiplier and no multiplier)
### [ZPU avalanche](https://github.com/sergev/zpu-avalanche.git)
### Cray 1
### [MiniCPU](https://github.com/MorrisMA/MiniCPU-S.git)_SerPCU + MiniCPU_SerALU

## building blocks for Baby 8

### logic functions in ALU

![logic functions](baby8_logic.svg)

### complete ALU

![ALU](baby8_alu.svg)

### complete datapath

![complete datapath](../baby8_datapath.svg)

## Digital blocks test

Note that the Digital versions use clock circuits and blocks
that can't be exported to Verilog, so to get the .v versions
these were replaced with input pins

### two port registers

![register test](register_test.svg)

### block ram

![bram test](bram_test.svg)