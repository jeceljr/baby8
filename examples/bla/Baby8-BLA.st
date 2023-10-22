Object subclass: #BLAInterp
	instanceVariableNames: 'source heap '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Baby8-BLA'!
!BLAInterp commentStamp: 'jecel 10/13/2023 11:52' prior: 0!
This is a very simple interpreter for the BLA programming language.

BLA (Baby 8 LAnguage) is a toy programming language in the spirit of tinyBasic,
VLT-2 and so on. Only small and simple programs are practical. One goal is to
be a bit more readable than the alternatives with mostly structured programming
in place of GOTOs like in Basic inspired systems and infix notation instead of
RPN like in Forth inspired languages.

All variables are global and have a single character as their names. Like VTL-2,
certain characters (like # or ?) have side effects when read or when assigned a
value. All variables hold 16 bit values. Spaces, tabs and newlines are simply
ignored and with single letter variables wouldn't make a difference. They can
be used for formatting.

Expressions are evaluated left to right but parenthesis can be used to force a
different order.

A character just evaluates to the value of the variable it names.

A sequence of digits 0 to 9 are the decimal represenation of a number.

The infix operators are +-*/<=>!!,&|^ representing addition, subtraction,
multiplication, division, less than comparison, equal comparison, greater than
comparison, store to address, convert byte to word index, bitwise AND,
bitwise OR and bitwise XOR. The comparisons return a 1 when their condition is
true and 0 when false. The , operation will multiply the right expression by two
and add it to the left expression, so that X,I is the same as X+(2*I) but is
nicer to read when used with !! and @.

The special variable % has the remainder of the last division operation.

The assignment, : , is also an infix operator but is special in that it doesn't
evaluate its right expression but treats it as a variable name of where to store
the result of the left expression. It also is special in that it doesn't produce
a result. If it is known that variable N is stored in memory location 140 then
45:N could be written as 45!!140 instead. So it is there to make programs more
readable instead of being strictly needed.

The only postfix operator is @ which reads a value from the address to its left.

The only prefix operator is \ which stores the current value of the program
counter in the variable whose name follows (it is like assignment). This is
used for defining labels. Note that \N is the same thing as .+5:N so like , and
: itself this is syntatic sugar instead of something fundamental.

Control flow is normally structured by placing code between { and } where {
is like a postfix operator that will push the expression to its left and the
current program counter to a nesting stack. If the expression is 0 then
execution skips to after the corresponding }. The # variable points to the top
of the nesting stack, so the current loop count can be accessed as #@ and the
count in the next leve of loop as #,1@ (at most 16 levels are allowed, so #,16@
will actually get the address after the opening { ). Assigning 0 to the current
loop count causes execution to skip to after the closing } and the nesting stack
to be popped, which allows premature exit from a loop. If the } is encountered 
ormally, then the loop count is decremented and if not 0 the program counter
is set to the saved value, looping back to just after the corresponding {. To exit
from three levels of {...} you would do something like 0!!#0!!(#,1)0!!(#,2)

Note that since comparison operators return either 0 or 1, placing such an
expression before a {..} is an IF. To have an ELSE part the expression should be
saved, like in

   X>25:C C{ then part } 1-C{ else part }
   
There is no syntax for comments, but since any characters between 0{ and } will
be ignored (except for checking that nested { } pairs are balanced) they can
be used as comments though with both a space and run time cost.

Two other special variables allow non structed control flow. The . is the
current program counter and assigning to it will make execution jump to the
new location while saving the current value (pointing after the .) in ; to
allow one level of subroutine calls. Return is just ;:. but it is possible
to save ; at the start of a subroutine explicitly for more levels. Jumps to
earlier locations are possible if where they are were saved previously in a
variable using \ , though using this to exit loops will cause errors. Jumps
to later locations are not practical.

Like in VTL-2, i/o uses ? for formated printing and evaluated input, while $ is
for single character reads and writes. In addition, characters between two "
are output to the terminal when executed (no assignement is needed). So " is a
bit like { but as a prefix instead of postfix operator.

The system is either in edit mode or in run mode. When switching to run mode,
execution always starts at the first character of the program. When switching
to edit mode the program source takes up the whole heap (with a gap at the
cursor position) so any values stored there are lost. The variables keep their
values between executions.

The ' special variable indicates the start of the heap in run mode. Any attempt
to execute at ' or beyond will switch to edit mode, as will any error during
execution. In the case of an error the message will be inserted at the cursor
location where the error happened and it will be selected, so a simple backspace
or control-x will restore the program leaving the cursor at the error location.
A program can force the switch to edit mode with ':. and the cursor will be at
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

   B:? ?':.
   
The space is not needed but was used to separate the interesting part from the
the trick to skip the rest of the program. After B is printed on the screen, a
value is read so the computer pauses and the printed value can be read. After
the user types anything (just a return, for example) a jump to the start of the
heap will switch to edit mode. The expression is not correct in that nothing was
done with the value the user typed, but as the evaluation stack is reset on
entering edit mode this does no harm.

As mentioned earlier, this trick won't allow the heap to be inspected as it was
destroyed when entering the edit mode after the error.

In theory characters used for operators could also be used for variable names.
For example, if we had a + variable then there would be no confusion in the
expression N++ since we start parsing as a variable, switch to operator and then
switch back to variable for the second +. But this just allows needlessly
confusing programs and would make run time errors such as XY or ?' into syntax
errors. So we will introduce the separation:

operators: + - * / < = > !! , & | ^ @ : \ { } ( ) "

digits: 0 1 2 3 4 5 6 7 8 9

special variables: . ; # % ? $ '

simple variables: A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
                  a b c d e f g h i j k l m n o p q r s t u v w x y z
                  ` _ [ ] ~

In ASCII, the operators @\^{|} overlap in the range of simple variables.!


!BLAInterp methodsFor: 'execution' stamp: 'jecel 10/13/2023 22:11'!
run
	"execute the source code from the start
     until an error happens or we jump past
     the end"

	| pc end lp ep op char inDig waitOp handlers blk |
	pc _ 1.
     end _ source size + 1 + 512. "leave space for variables and stacks"
     self varNamed: $. assign: pc.
     self varNamed: $' assign: end.
     inDig _ false.
     waitOp _ false.
     lp _ 32+256. "loop stack is 16 words in page 1 and grows down"
     ep _ 32*3+256. "expression stack is 16 words after the two loop stacks"
     op _ 32*4+256. "operator stack is 32 bytes after the previous stacks"
     handlers _ Dictionary new.
     blk _ [self halt]. "character not handled at all"
     0 to: 255 do: [ :c | handlers at: (Character value: c) put: blk ].
     blk _ [inDig _ false].  "characters to ignore, but end numbers"
     #(32 13 9 10 12) do: [ :c | handlers at: (Character value: c) put: blk ].
     blk _ [ inDig ifTrue: [ self wordAt: ep put: (((self wordAt: ep)*10) + char digitValue) ]
                     ifFalse: [ ep _ ep-2. self wordAt: ep put: char digitValue. inDig _ true ]
            ].
     '0123456789' do:  [ :c | handlers at: c put: blk ].
     [pc+512 < end] whileTrue: [
          char _ source at: pc.
          (handlers at: char) value.
          pc _ self varNamed: $. .  "in case code changed this"
          pc _ pc+1.
          self varNamed: $. assign: pc.
          "just to keep compiler happy for now". lp_lp+1.op_op+1.
     ]! !


!BLAInterp methodsFor: 'housekeeping' stamp: 'jecel 10/13/2023 12:26'!
initialize

   "maximum addressable memory"

    heap _ ByteArray new: 64*1024 withAll: 0.
    source _ ''! !

!BLAInterp methodsFor: 'housekeeping' stamp: 'jecel 10/13/2023 18:20'!
loadFileNamed: name
	"sets source to the contents of the name file"

	self source: (FileStream oldFileNamed: name) contentsOfEntireFile! !


!BLAInterp methodsFor: 'access' stamp: 'jecel 10/12/2023 19:44'!
source: text
	"sets the source to the text
     this is an alternative to the edit mode"

	source _ text! !

!BLAInterp methodsFor: 'access' stamp: 'jecel 10/13/2023 12:24'!
varNamed: char

   "return value associated with
    the variable named char"

    | index |
    index _ char asciiValue - 34.
    ((index < 1) or: [index > 92]) ifTrue: [self halt]. "not in range"
    ('+-*/<=>!!,&|@:\{}()' includes: char) ifTrue: [self halt]. "operator"
    ('0123456789' includes: char) ifTrue: [self halt]. "part of number"
    $? == char ifTrue: [self wordAt: 2*index put: (self evalString: (FillInTheBlank request: 'BLA expression'))].
    ^ self wordAt: 2*index! !

!BLAInterp methodsFor: 'access' stamp: 'jecel 10/13/2023 20:58'!
varNamed: char assign: value

   "put the value in
    the variable named char"

    | index |
    index _ char asciiValue - 34.
    ((index < 1) or: [index > 92]) ifTrue: [self halt]. "not in range"
    ('+-*/<=>!!,&|@:\{}()' includes: char) ifTrue: [self halt]. "operator"
    ('0123456789' includes: char) ifTrue: [self halt]. "part of number"
    ^ self wordAt: 2*index put: value! !

!BLAInterp methodsFor: 'access' stamp: 'jecel 10/13/2023 12:53'!
wordAt: addr
	"reads two bytes from the specified address"

	|  |
	((addr < 0) or: [addr >= (heap size - 1)]) ifTrue: [self halt]. "needs at least two valid bytes"
     ^ (heap at: addr+1) + (256*(heap at: addr+2)) "unsigned 16 bit value"! !

!BLAInterp methodsFor: 'access' stamp: 'jecel 10/13/2023 12:38'!
wordAt: addr put: value
	"stores two bytes into the specified address"

	|  |
	((addr < 0) or: [addr >= (heap size - 1)]) ifTrue: [self halt]. "needs at least two valid bytes"
     heap at: addr+1 put: (value bitAnd: 255).
     heap at: addr+2 put: ((value//256) bitAnd: 255).! !
