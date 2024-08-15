	; this is the famous Sieve of Eratosthenes benchmark originally
	; published in Basic in Byte magazine translated here to Baby8
	; assembly language by Jecel Assumpcao Jr in October 2023 and
        ; rewritten in the new assembly in May 2024

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

        .macro FOR rh, rl, start, end, lstart, lend
	    K #\start&255   ; low 8 bits
            MOV \rl,\rl
	    K #\start>>8    ; high 8 bits
            MOV \rh,\rh
	    .equ \lstart, .    ; remember where the loop starts
            MOV \rh,\rh ?Z
	    PUG 0f
            K #\end>>8      ; first compare high 8 bits
	    SUB r0,K,\rh ?C  ; we have already checked that lh is not zero
            PUG \lend        ; we have reached the limit
0:
            MOV \rl,\rl ?Z
	    PUG 1f
            K #\end&255     ; compare low 8 bits
	    SUB r0,K,\rl ?C
            PUG \lend
1:
	.endm

        .macro NEXT rh, rl, lstart, lend
	    INC \rl,\rl ?C
            INC \rh,\rh
	    PUG \lstart
            .equ \lend, .  ; remember where the loop ends
	.endm

	.equ size, 8190
	.equ true, 1
	.equ false, 0
 
	.data
 
fip:    .word 0
fp:     .word flags    ; after the program in memory
count:  .word 0
prime:  .word 0
i:      .word 0
k:      .word 0
tp:     .word 0
text1:  .asciz "Only 1 iteration\n"
text2:  .asciz " PRIMES\n"
flags:

        .text

sieve:
	W = #text1&255
	X = #text1>>8
	>>>>$ printText
	count = #0
	(count+1) = #0
	for i 0 size [
		setFP i
		*fip = #true
	] .   ; note the current PC as the gen argument
	for i 0 size [
		setFP i
		Y = *fip
		Z ?
			>>>> L18
		mov16 prime i
		add16 prime i
		prime += #3
		C ?
			(prime+1) += #1
		k = prime
		(k+1) = (prime+1)
		add16 k i
while:
			Y = (k+1)
			Y -= #size>>8  ; compare high bytes
			> ?
				>>>> endwhile
			!Z ?
				>>>> whilebody
			Y = k
			Y -= #size&255
			> ?
				>>>> endwhile
whilebody:
			setFP k
			*fip = #false
			add16 k prime
endwhile:
		count += #1
		C ? (count+1) += #1
L18:
	] .
	W = count
	X = count+1
	>>>>$ printNum
	W = #text2&255
	X = #text2>>8
	>>>>$ printText
halt:   PUG halt

printText:
	; r2,r3 hold the text address
        K LinkH
	MOV r10,r10
        K LinkL
	MOV r11,r11
ptloop:
        CAR r2,r3++
	MOV r0,r0 ?Z
        PR r10,r11   ; nul is end of text
	MOV K,r0,r0
	SAI r10,r11  ; there is only one port, so the address doesn't matter
	PUG ptloop
	
	.macro convBase factor 
		OUX r0,r0   ; count is resulting decimal digit
0:
		Y = (tp+1)
		Y -= #factor>>8
		< ?
	        PUG 2f
		(tp+1) = Y
		!Z ?
	        PUG 1f
		Y = tp
		Y -= #factor&255
		< ?
		PUG 2f
1:
		tp -= #factor&255
		INC r0,r0
		PUG 0b
2:
	.endm
 
printNum:
        K LinkH
	MOV r10,r10
        K LinkL
	MOV r11,r11
	MOV r2,r4
        MOV r3,r5
	convBase 10000
	K #0x30   ; digit to ASCII
        SOM r0,K,r0
	SAI r10,r11
	MOV r2,r4
        MOV r3,r5
	convBase 1000
	K #0x30   ; digit to ASCII
        SOM r0,K,r0
	SAI r10,r11
	MOV r2,r4
        MOV r3,r5
	convBase 100
	K #0x30   ; digit to ASCII
        SOM r0,K,r0
	SAI r10,r11
	MOV r2,r4
        MOV r3,r5
	convBase 10
	K #0x30   ; digit to ASCII
        SOM r0,K,r0
	SAI r10,r11
        PR r10,r11	
