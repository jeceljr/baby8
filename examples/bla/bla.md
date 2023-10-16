# BLA (Baby 8 LAnguage)

This  is a toy programming language in the spirit of tinyBasic,
VLT-2 and so on. Only small and simple programs are practical. One goal is to
be a bit more readable than the alternatives with mostly structured programming
in place of GOTOs like in Basic inspired systems and infix notation instead of
RPN like in Forth inspired languages.

## Language

All variables are global and have a single character as their names. Like VTL-2,
certain characters have side effects when read or when assigned a
value. Even the characters that indicate operators can be used as valid variable
names if they appear where a variable is expected. All variables hold 16 bit values.

Spaces, tabs and newlines are simply
ignored and with single letter variables wouldn't make a difference. They can
be used for formatting.

Expressions are evaluated left to right but parenthesis can be used to force a
different order.

A character just evaluates to the value of the variable it names.

A sequence of digits 0 to 9 are the decimal represenation of a number.

### Inifix Operators

Infix operators will combine the value of the expression to its left with the
operand to its right, which must either be a simple variable or a more
complex expression in parenthesis.

- \+ is addition
- \- is subtraction
- \* is multiplication
- / is division
- < is less than comparison
- = is equal comparison
- \> is greater than comparison
- \! is store to address
- , is convert byte to word index
- & is bitwise AND
- | is bitwise OR
- ^ is bitwise XOR

The comparisons return a 1 when their condition is
true and 0 when false.

The , operation will multiply the right expression by two
and add it to the left expression, so that X,I is the same as X+(2*I) but is
nicer to read when used with ! and @.

The assignment, : , is also an infix operator but is special in that it doesn't
evaluate its right expression but treats it as a variable name of where to store
the result of the left expression. It also is special in that it doesn't produce
a result. If it is known that variable N is stored in memory location 140 then
45:N could be written as 45!140 instead. So it is there to make programs more
readable instead of being strictly needed.

### Prefix operator

The only prefix operator is \ which stores the current value of the program
counter in the variable whose name follows (it is like assignment). This is
used for defining labels. Note that \N is the same thing as .+5:N so like , and :
itself this is syntatic sugar instead of something fundamental.

Though not quite a prefix operator, the " character will output all the characters
that follow it until a second " is found. The ' character has the same functionality
but will output characters until a second ' is found. This allows texts with these
characters to be output:

    "I don't know why he said "'"no".'

### Postfix operators and Unstructured control flow

- @ is load from address
- . is a jump to the address
- % is a call to the address storing the current program counter in ;
- ? is a conditional break from current loop (see structured control flow)
- \# will print the value as a decimal number
- $ will print the value as a single ASCII character

When used as variables, \# and $ will read a number or a single character from
the terminal.

When used as a variable . is the value of the current program counter.

Since % saves the address of the next instruction in the ; special variable
before jumping to the indicated address, a return from subroutine is just ;.
if we only have one level of calls. For mode levels ; must be saved and then
the return will be a jump to the saved value.

### Structured control flow

Control flow is normally structured by placing code between { and } where { is
like a postfix operator that will push the expression to its left and the
current program counter to a nesting stack. If the expression is 0 then
execution skips to after the corresponding } and pops the nesting stack.

When } is encountered then the current loop count is decremented and if not
zero then execution continues to right after the corresponding {. If the
count has reached zero then the nesting stack is popped and execution
continues after the }.

Note that since comparison operators return either 0 or 1, placing such an
expression before a {..} is an IF. To have an ELSE part the expression should be
saved, like in

   X>25:C C{ then part } 1-C{ else part }
   
There is no syntax for comments, but since any characters between 0{ and } will
be ignored (except for checking that nested { } pairs are balanced) they can
be used as comments though with both a space and run time cost.

The ? operator will act as an extra { in that if the expression is 0 it will
skip to after the corresponding } and pop the nesting stack.

The \[ operator is equivalent to 1{ while the \] is similar to } but doesn't
decrement the loop counter. If the loop counter has been set to zero by
someone else it will pop the nesting stack and continue, otherwise it jumps
back to the start of the loop. Note that for matching purposes { and [ are
the same, as are } and ]. So x{..\] and \[...} are valid.

The \_ variable points to the
top of the nesting stack, so the current loop count can be accessed as
 \_@ and the count in the next leve of loop as \_,1@ (at most 16 levels are
allowed, so \_,16@ will actually get the address after the opening { ).

While ? can be used to exit the current loop, it is possible to do something
like:

     0!(_,1)

to clear the loop counter of the next level. When the nesting stack is popped
there is an implied ? so that if the new loop counter is zero we skip to the
} or ].

## Modes

The system is either in edit mode or in run mode. When switching to run mode,
execution always starts at the first character of the program. When switching
to edit mode the program source takes up the whole heap (with a gap at the
cursor position) so any values stored there are lost. The variables keep their
values between executions.

The ~ special variable indicates the start of the heap in run mode. Any attempt
to execute at ~ or beyond will switch to edit mode, as will any error during
execution. In the case of an error the message will be inserted at the cursor
location where the error happened and it will be selected, so a simple backspace
or control-x will restore the program leaving the cursor at the error location.
A program can force the switch to edit mode with ~. and the cursor will be at
the end of the program.

Supposing a pure text terminal, there is no way to indicate a cursor between two
characters. So a reasonable approximation is to altenatively blink the character
before and the one after the invisible cursor. Moving the cursor while pressing
alt will select a sequence of characters and these will be inverted without
blinking. control-x or control-c will move the selected text to after the
program and the cursor will again be blinking between characters. control-v will
insert a copy of the text after the program at the cursor location. This text
"clipboard" is lost when run mode is entered.

Backspace is like control-x when a block is selected but will remove a single
character to the left of the cursor when that is blinking.

There is no immediate mode like in Basic or Forth, but it is simple enough to
navigate to the start of the program (a "home" key, if present) and insert a
small fragment. For example, if we need to know what was the value of B when
an error happened, we can insert this at the top of the program:

   B? ?~.
   
The space is not needed but was used to separate the interesting part from the
the trick to skip the rest of the program. After B is printed on the screen, a
value is read so the computer pauses and the printed value can be read. After
the user types anything (just a return, for example) a jump to the start of the
heap will switch to edit mode. The expression is not correct in that nothing was
done with the value the user typed, but as the evaluation stack is reset on
entering edit mode this does no harm.

As mentioned earlier, this trick won't allow the heap to be inspected as it was
destroyed when entering the edit mode after the error.
