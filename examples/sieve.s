	; this is the famous Sieve of Eratosthenes benchmark originally
	; published in Basic in Byte magazine translated here to Baby8
	; assembly language by Jecel Assumpcao Jr in October 2023

	; for reference, the original Basic program:
	; 1 SIZE = 8190
	; 2 DIM FLAGS(8191)
	; 3 PRINT "Only 1 iteration"
	; 5 COUNT = 0
	; 6 FOR I = 0 TO SIZE
	; 7 FLAGS (I) = 1
	; 8 NEXT I
	; 9 FOR I = 0 TO SIZE
	; 10 IF FLAGS (I) = 0 THEN 18
	; 11 PRIME = I+I + 3
	; 12 K = I + PRIME
	; 13 IF K > SIZE THEN 17
	; 14 FLAGS (K) = 0
	; 15 K = K + PRIME
	; 16 GOTO 13
	; 17 COUNT = COUNT + 1
	; 18 NEXT I
	; 19 PRINT COUNT," PRIMES"

	; to make the program prettier, let us have a FOR loop
	; step is always 1 and both start and end are constants

	\FOR var start end body gen '
	var = #start&255   ; low 8 bits
	var+1 = #start>>8  ; high 8 bits
	>>>> for/gen
for/gen:
	Y = (var+1)
	Y -= end>>8     ; compare high bits
	> ? >>>> endfor/gen
	!Z ? >>>> mainfor/gen
	Y = var
	Y -= end&255    ; compare low bits if high bits were equal
	> ? >>>> endfor/gen
mainfor/gen:
	body
	var += #1;
	!Z ? >>>> for/gen
	(var+1) += #1   ; low byte turned zero, increment high byte
	>>>> for/gen
endfor/gen:
	'

	>>>> sieve    ; start of zero page is first instruction
	size: 8190
	true: 1
	false: 0
	% ((.+1)/2)*2 ; pointers must be at even address
fip:
	##0
fp:
	##flags    ; after the program in memory
count:
	##0
prime:
	##0
i:
	##0
k:
	##0
text1:
	"Only 1 iteration", #0
text2:
	" PRIMES", #0

	\add16 za zb '
	za += zb
	C ? (za+1) += #1   ; carry to high byte
	(za+1) += (zb+1)
	'

	\mov16 za zb '
	za = zb
	(za+1) = (zb+1)
	'

	\setFP var '
	mov16 fip fp     ; start of array
	add16 fip var    ; fip now points to element
	'

sieve:
	W = #text1&255
	X = #text1>>8
	>>>> printText [
	count = #0
	(count+1) = #0
	for i 0 size '
		setFP i
		*fip = #true
	' .   ; note the current PC as the gen argument
	for i 0 size '
		setFP i
		Y = *fip
		Z ? >>>> L18
		mov16 prime i
		add16 prime i
		prime += #3
		C ? (prime+1) += #1
		k = prime
		(k+1) = (prime+1)
		add16 k i
while:
			Y = (k+1)
			Y -= #size>>8  ; compare high bytes
			> ? >>>> endwhile
			!Z ? >>>> whilebody
			Y = k
			Y -= #size&255
			> ? >>>> endwhile
whilebody:
			setFP k
			*fip = #false
			add16 k prime
endwhile:
		count += #1
		C ? (count+1) += #1
L18:
	' .
	W = count
	X = count+1
	>>>> printNum [
	W = #text2&255
	X = #text2>>8
	>>>> printText [
halt:
	>>>> halt

printText:
	]
printNum:
	]

flags:
	%.+size+1
endMemory:
