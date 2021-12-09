TITLE Project #4     (Program#4.asm)

;__|Header Block__________________________________________________________________________________________________________________________________
;- Author:                             Brandon Schultz
;-- Date:                              10.29.21
;--- OSU email address:                schulbra@oregonstate.edu
;---- Course Section:                  CS 271 400 F2021
;----- References:                     1. https://docs.microsoft.com/en-us/cpp/assembler/masm/comment-masm?view=msvc-170&viewFallbackFrom=vs-2019               
;----- References:                     2. http://www.cs.virginia.edu/~evans/cs216/guides/x86.html                                                 
;----- References:                     2. https://www.tutorialspoint.com/assembly_programming/assembly_variables.htm
;_________________________________________________________________________________________________________________________________________________


INCLUDE Irvine32.inc

; Defines upper range value for pool of primes.
UPPER = 200
TRUE = 1
FALSE = 0

.data
	displayboardTOP					BYTE	" ______________________________________/\___/\____________    ", 0;
	displayName				      	BYTE	"/ -Author:     Brandon Schultz                             \   ", 0;
	displayProgram		            BYTE	"| -Assignment: Project 4 - Nested Loops and Procedures     |  ", 0;
	displayECPrompt1				BYTE	"| **EC #1: Output columns aligned.                         |  ", 0;
	; displayECPrompt2				BYTE	"| **EC #2: Avg of user input values is calculated and      |  ", 0;
	displayboardBott				BYTE	"\_/\______________________________________________________/   ", 0;
	displaybardAlt					BYTE	"  __________________________________________________       ", 0;
	getPrimesIntroPrompt            BYTE	" /  ~~~~~~~~~~~~~~  ITS PRIME TIME  ~~~~~~~~~~~~~~  \           ", 0;
	getPrimesAlarmPrompt            BYTE	"   ** Note that my primeness is confined to [1 200]               ", 0;
	blankSpaceLine		        	BYTE	"                                                                  ", 0
	getPrimesTotalPrompt            BYTE	"    - How many prime numbers should be displayed?                ", 0;
	getPrimesTotalPrompt2           BYTE	"    - [ ENTER VALUE ] :  ", 0;
	;getPrimesAlarmPrompt           BYTE	" |  ** Note that my primeness is confined to [1 200]               ", 0;
	N								DWORD   ?
	truePrime						BYTE	0
    farewellPrompt				    BYTE    " \   ~~~~~~~~~~~~~ PRIME TIMES OVER ~~~~~~~~~~~~~   /       ", 0
     displaybardAltPT		     	BYTE	"  \________________________________________________/             ", 0;
	blankSpace						BYTE	"  "              , 0
	lineCountB						BYTE	"|", 0
	primeTenPerLineCount            DWORD	1
	primeTotalCount                 DWORD	1
	primeTime						DWORD   ?

	arrPrimeLoopS					DWORD	0
	primeNumTst						DWORD	?
	primeNumModF					DWORD	?
	arr								DWORD 200 DUP(?)

.code




;__|Main Procedure____________________________________________________________________________________________________
; Main procedure containing four sub-procs in which user is... 
; 1. Greeted 
; 2. Asked for input detailing number of primes caulculated,
; 3. Given output based on the above.
; 4. Given farewell message.
;__________________________________________________________________________|    |_____________________________________
main PROC

	; Displays programmer info
	call	introduction
	
	; Get users choice for range of primes displayed.
	call	getUserData
	
	; Displays primes in range defined by user if users input falls between 1, 200.
	call	showPrimes
	; End Program.
	
	call	farewell
	exit
	
main ENDP

;__|Intro Procedure______________________________________________________________________________________________________
; |      -Receives: displayboardTOP, displayName,displayProgram, displayECPrompt1, displayECPrompt2, displayboardBott,
;        displaybardAlt, getPrimesIntroPrompt, getPrimesTotalPrompt, getPrimesAlarmPrompt
; ||    -Returns: N/A
; |||   -Pre: Initialization of edx.
; ||||  -Registers Altered: edx
;_________________________________________________________________________________________________|    |_________________
introduction PROC

		; Displays Boarder for top/bottom of assignment info template.
		mov		edx, OFFSET	displayboardTOP
		call	WriteString
		call	Crlf

		; Displays programmer name.
		mov		edx, OFFSET displayName
		call	WriteString
		call	Crlf

		; Displays program title.
		mov		edx, OFFSET displayProgram
		call	WriteString
		call	Crlf


		; EC Prompt(s).
		mov		edx, OFFSET displayECPrompt1
		call	WriteString
		call	Crlf
		
		;mov	edx, OFFSET displayECPrompt2
		;call	WriteString
		;call	Crlf

		; Displays Boarder for top/bottom of assignment info template.
		mov		edx, OFFSET	displayboardBott
		call	WriteString
		call	Crlf
		call	Crlf


		mov		edx, OFFSET	displaybardAlt
		call	WriteString
		call	Crlf
		
		mov		edx, OFFSET	getPrimesIntroPrompt
		call	WriteString
		call	Crlf
		
        mov		edx, OFFSET	blankSpaceLine
		call	WriteString
		call	Crlf
                
		mov		edx, OFFSET	getPrimesAlarmPrompt
		call	WriteString
		call	Crlf


		mov		edx, OFFSET	blankSpaceLine
		call	WriteString
		call	Crlf

		mov		edx, OFFSET	getPrimesTotalPrompt
		call	WriteString
		call	Crlf
		


		ret	
introduction ENDP


;__|getUserData Procedure__________________________________________________________________________
; |      -Receives: Global Variable N
; ||    -Returns: Gloabl  Variable N
; |||   -Pre: Initialization of edx.
; ||||  -Registers Altered: edx
;__________________________________________________________________________|    |__________________
getUserData proc
		;mov		edx, OFFSET	getPrimesTotalPrompt
		;call		WriteString
		;call		Crlf

		; Direscts user to add input vals for prime vals to be dispalyed.
		; Input is read by ReadDec, jumps occur if input is not within the
		; range [1 ... 200]
		mov			edx, OFFSET getPrimesTotalPrompt2
		call		WriteString
		call		ReadDec

		; Compares user input to lower (1) and upper bounds (200)
		mov			N, eax
		; Jump to get input again if user input < 1
		cmp			N, 1
		jl			inputValidation
		;Jump to get input again if user input > 200
		cmp			N, 200
		jg			inputValidation
		ret	

 inputValidation:		
		; User is made aware of their poor behavior and redirected for input again.
		mov			edx, OFFSET getPrimesAlarmPrompt	; Invalid input prompt displayed
		call		WriteString
		call		Crlf
		jmp			getUserData						; jump back to user input entry
		ret		
getUserData ENDP

;__|showPrimes Procedure____________________________________________________________________
; - Caulculate + displays N prime numbers.
; |		-Recieves N, primeTenPerLineCount, primeTenPerLineCount, primeTotalCount, truePrime
; ||    -Returns: N/A
; |||   -Pre: Requires valid user input in  [1-200] range
; ||||  -Registers Altered: edx
;__________________________________________________________________________|    |___________
showPrimes PRoc

	; Methods for printing inital
        ; primes 2, 3.
	; Prints inital prime val
	mov			eax, 2
	call		Crlf
	call		WriteDec
	
	; Prints space seperating prime 
	; value printed and next value.
	mov			edx, OFFSET blankSpace
	call		WriteString	

	; Adds one to counter tracking primes/ line of output.
	; N=1, end of primes to be printed.
	inc			primeTenPerLineCount
	cmp			N, 1
	je			primeTimeOver

	; N < or > c, continue by pointing to array,
	; adding two and incrementing its size.
	; At three, loop for primes begins.
	inc			primeTotalCount	;primeTenPerLineCount	
	mov			esi,	OFFSET arr
	mov			[esi],	eax
	inc			arrPrimeLoopS
	mov		ecx, 3

 primeTimeLoopGo:

	; Odd numbers are looped through via ecx register
	; until primeTotalCount > N
	mov		eax, primeTotalCount
	cmp		eax, N
	jg		primeTimeOver

	; If primeTotalCount < N, continue processing
	; numbers by calling isPrime PROC if val is
	; determined to be prime loop stops.
	pushad
 	call	isPrime
	popad
	cmp		truePrime, TRUE
	jne		loopNextPrime

	; Methods for adding vals determined to be prime to
	; arry displayed as output:
	mov			esi,OFFSET arr
	mov			eax,4
	mul			arrPrimeLoopS
	add			esi,eax
	mov			[esi],ecx
	inc			arrPrimeLoopS
	mov			eax, [esi]

	; Resets output/row when line output = 10
	; by ccreating additional line for ten more
	; vals.			
	cmp		primeTenPerLineCount, 10
	jle		primeTimeLineTen

	mov		primeTenPerLineCount, 1
	call		Crlf
	call		Crlf

	; Displays values, spaces as output and increments
	; counters tracking output/linbe.
	primeTimeLineTen:
	mov		eax, ecx
	; prime val to be printed
	call		WriteDec
	mov		edx, OFFSET blankSpace
	; space between prime vals to be printed
	call		WriteString
	; +1 to line count
	inc			primeTenPerLineCount
	; +1 to total primes count
	inc			primeTotalCount

	; checks next value for 
	; primeness via ecx 
	loopNextPrime:
	add			ecx,2
	jmp			primeTimeLoopGo

primeTimeOver: 
	call		Crlf
	ret

showPrimes ENDP

;__|isPrimes Procedure__________________________________________________________________________
; This procedure checks numbers in deginated set for prime/non-prime status.
; |	-Recieves primeNumModF, truePrime, primeNumTst.
; ||    -Returns: 0 or 1 of truePrime
; |||   -Pre: Requires valid user input in [1-200] range and valid array size.
; ||||  -Registers Altered: edx, eax,ecx,ebx
;__________________________________________________________________________|    |_______________
isPrime PROC
	; cur arr index val
	mov			ebx, 0
	; points to ebx index
	mov			esi, OFFSET arr
	; value being tested for primeness
	mov			primeNumTst, ecx
	cmp			ecx, 3
	je			isItReallyPrime

	; primeNumTst is divided by all arr nums.
	; until arrs edns is reached. if a remainder
	; is found other than 0, val is prime and loop
	; ends.
	PrimeLoop:
	cmp			ebx, arrPrimeLoopS
	jge			isItReallyPrime
	mov			ecx, [esi]
	mov			edx,0
	mov			eax, primeNumTst
	div			ecx
	cmp			edx,0

	; r = 0, test val has divisor
	; continue through arr
	je			NotPrime
	add			esi,4
	inc			ebx
	jmp			isItReallyPrime

isItReallyPrime:	
	mov			 truePrime, TRUE
	ret

notPrime:
	mov			 truePrime, FALSE
	ret
isPrime ENDP

;__|farewell Procedure__________________________________________________________________________
farewell PROC

	call		Crlf
	mov		edx, OFFSET farewellPrompt
	call		WriteString
	call		Crlf

        ; Displays Boarder for top/bottom of assignment info template.
	mov		edx, OFFSET	        displaybardAltPT			
	call	WriteString
	call	Crlf
        
	ret

farewell ENDP


END main






