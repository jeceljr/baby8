# Register Transfer Level

RTL is a design style where a single clock
signal goes to all registers in the circuit
and there are additional enable signals for
those registers so that a subset of them
update their values on a give cycles while
the others keep their previous value

Between the outputs of all the registers and
their inputs there is a combinational circuit.
The time between clock edges must be long enough
so the combinational circuit has settled to
a stable value before the hold time defined for
the registers.

The baby8 processor was developed using the
Digital simulation tool written in Java.

## baby8_datapath.dig

This defines the logic needed to execute instructions,
including the registers and an ALU (arithmetic and
logic unit).
