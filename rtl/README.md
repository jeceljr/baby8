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

## baby8cpu.dig

The combination of the datapath and the control unit
forms the Central Processing Unit (CPU).

![CPU](baby8cpu.svg)

This requires and external memory pre-loaded with the
needed program and should be attached to one or more
peripheral devices.

## baby8_datapath.dig

This defines the logic needed to execute instructions,
including the registers and an ALU (arithmetic and
logic unit).

![Datapath](baby8_datapath.svg)

## baby8_control.dig

A hardwired finite state machine generates the signals needed
to use the datapath to execute instructions.

![Control Unit](baby8_control.svg)