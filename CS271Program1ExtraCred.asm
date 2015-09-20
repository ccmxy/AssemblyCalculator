; Name: Colleen Minor		Email:  minorc@onid.oregonstate.edu 
; CS271-400 / Assignment 1         Date: 1/18/2015
; Description: Program that allows users to enter two numbers and see them added, subtracted, multiplied and divided.

INCLUDE Irvine32.inc							;include macro files
INCLUDE Macros.inc

.data
firstNum SDWORD ?								;declare signed double-words for both numbers
secondNum SDWORD ?
sum SDWORD ?									;declare signed double-words to store the calculation results
difference SDWORD ?
product SDWORD ?
quotient SDWORD ?
remainder SDWORD ?                                
thousand SDWORD 1000							;number to multiply by remainder to get the floating point to the nearest .001
quit BYTE 'q'									;char to compare to user's answer for if they want to quit
testQuit BYTE ?									;char to fill user's answer for if they want to quit

.code											;beginning of area that contains executable instructions
main PROC										;entry point (procedure named main)

;INTRODUCTION
	mWrite "Easy Calc by Colleen Minor"
	call Crlf                                   ;start a new line in console window.
	call Crlf
	mWrite "Welcome to your virtual calculator."
	call Crlf
	mWrite "After entering two numbers, this program will give you "
	call Crlf
	mWrite "the sum, remainder, product, and divisor with the remainder. "
	call Crlf

;GET THE DATA
	L1:                                         ;first loop, for reading in numbers
		call Crlf
		mWrite "Enter the first number: "
		call readInt                            ;reads number into eax
		mov firstNum, eax                       ;copies number from eax to firstNum
		mov ecx, eax                            ;copies first number into ecx
		mWrite "Enter the second number: "                
		call readInt                            ;reads second number into eax
		cmp ecx, eax                            ;compares first number to second number
		jl L2                                   ;jumps to label L2 if cmp showed ecx is less than eax
		jmp L3                                  ;jump to L3 if the L2 jump didn't happen
	L2:
		mWrite "Sorry, but the first number must be larger than the second. Please try again."
		call Crlf
		jmp L1									;return to L1 to try again
	L3:    
		mov secondNum, eax                      ;number is copied from eax (where readInt put it) into secondNum

;CALCULATE THE REQUIRED VALUES      
	add eax, firstNum							;adds first number to eax (which still contains secondNum from the last readInt)
	mov sum, eax								;copies eax into sum  

	mov eax, firstNum							;copy first number into eax                      
	sub eax, secondNum							;subtract second number from eax (first number)
	mov difference, eax							;store the difference in "difference" variable

	mov eax, firstNum
	mul secondNum								;mul secondNum by the ax register (eax in this case cos double-word is 4 bytes)
	mov product, eax							;store the eax register in "product" variable

	mov eax, firstNum
	div secondNum								;this puts the quotient in eax and the remainder in edx
	mov quotient, eax
	mov remainder, edx

;DISPLAY THE RESULTS
	mov eax, firstNum                            ;copy the number in the variable "firstNum" into eax register
	call writeDec                                ;writes number in eax to output
	mWrite " + "                                 ;write " + " to output
	mov eax, secondNum                           ;copy secondNum to eax...
	call writeDec
	mWrite " = "
	mov eax, sum                                 ;copy the number in the variable "sum" into eax register
	call writeDec                                ;writes number that is in eax to the output
	call Crlf                                    ;start newline
 
	mov eax, firstNum
	call writeDec
	mWrite " - "
	mov eax, secondNum
	call writeDec
	mWrite " = "          
	mov eax, difference                               
	call writeDec
	call Crlf 

	mov eax, firstNum
	call writeDec
	mWrite " * "
	mov eax, secondNum
	call writeDec
	mWrite " = "
	mov eax, product
	call writeDec
	call Crlf 

	mov eax, firstNum
	call writeDec
	mWrite " / "
	mov eax, secondNum
	call writeDec
	mWrite " = "
	mov eax, quotient
	call writeDec 

	mov eax, remainder
	mWrite " remainder  "
	call writeDec
	call Crlf 
	jnz L5										;if eax is not 0, jump to L5
	jmp L6 

	L5:											;floating point in the case of a remainder
		mWrite "Floating point: "
		mov eax, quotient
		call WriteDec
		mWrite "."
		mov eax, remainder
		mul thousand							;multiply remainder by 1000
		div secondNum							;(remainder * 1000)/second number = insignificant digits to the .001
		call WriteDec
		call Crlf
		jmp L7                
	L6:											;in case there is no remainder
		call Crlf 
		mWrite "Floating point: "
		mov eax, quotient
		call WriteDec
		mWrite ".0"
		jmp L7

	L7:
		mWrite "Enter lower-case q to quit, or anything else to continue: "
		call ReadChar							;waits for a single character to be typed, returns it into al register  
		mov testQuit,al							;copy char from al register into testQuit
		mov dl, quit							;copy the variable in quit (q) into dl
		cmp al,dl								;compare if the chars in al and dl are equal (both q)
		je L4									;if both characters are equal, jump to L4 (exit)
		jmp L1									;if not, go back to loop to enter numbers


	L4:											;goodbye jumped to after q is intered
;GOODBYE
	call Crlf
	mWrite "Thank you for using virtual calculator! Goodbye!"
	call Crlf 


	exit   ; exit to operating system
	main ENDP									;end of main procedure
END main										;end of program
