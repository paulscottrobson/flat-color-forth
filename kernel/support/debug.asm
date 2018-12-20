; *********************************************************************************
; *********************************************************************************
;
;		File:		debug.asm
;		Purpose:	Show A/B Registers on the screen.
;		Date : 		20th December 2018
;		Author:		paul@robsons.org.uk
;
; *********************************************************************************
; *********************************************************************************

DEBUGShow:
		push 	bc
		push 	de
		push 	hl 					

		push 	de 									; save B then A
		push 	hl

		ld 		hl,(__DIScreenSize) 				; clear bottom line.
		ld 		de,-32
		add 	hl,de
		push 	hl
		ld 		b,32
__DEBUGShowClear:
		ld 		de,$0620
		call 	GFXWriteCharacter
		inc 	hl
		djnz 	__DEBUGShowClear

		pop 	hl 									; HL now points to start of bottom line

		ld 		de,$0500+'A'
		call 	GFXWriteCharacter
		inc 	hl
		ld 		de,$0500+':'
		call 	GFXWriteCharacter
		inc 	hl
		pop 	de 									; get pushed A
		call 	__DEBUGPrintDecimalInteger 			; print DE at position HL, C Chars remaining.
		inc 	hl 									; allow a space

		ld 		de,$0500+'B'
		call 	GFXWriteCharacter
		inc 	hl
		ld 		de,$0500+':'
		call 	GFXWriteCharacter
		inc 	hl
		pop 	de 									; get pushed B
		call 	__DEBUGPrintDecimalInteger 			; print DE at position HL, C Chars remaining.

		pop 	hl 									
		pop 	de 									
		pop 	bc
		ret

__DEBUGPrintDecimalInteger:
		push 	de
		bit 	7,d 								; is it negative.
		jr 		z,__DEBUGPrintDecNotNegative
		ld 		a,d 								; if so, negate the value.
		cpl
		ld 		d,a
		ld 		a,e
		cpl
		ld 		e,a
		inc 	de
__DEBUGPrintDecNotNegative:
		call 	__DEBUGPrintDERecursively

		pop 	de
		bit 	7,d 								; was it -VE
		ret 	z
		ld 		de,$0600+'-'						; print a -ve sign
		call 	GFXWriteCharacter
		inc 	hl
		ret

__DEBUGPrintDERecursively:
		push 	hl 									; save screen position
		ld 		hl,10 								; divide by 10, DE is division, HL is remainder.
		call 	DIVDivideMod16
		ex 		(sp),hl 							; remainder on TOS, HL contains screen position
		ld 		a,d 								; if DE is non zero call Recursively
		or 		e
		call 	nz,__DEBUGPrintDERecursively
		pop 	de 									; DE = remainder
		ld 		a,e 								; convert E to a character
		or 		'0'
		ld 		e,a
		ld 		d,6 								; yellow
		call 	GFXWriteCharacter 					; write digit.
		inc 	hl 	
		ret
