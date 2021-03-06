; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		compiler.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		20th December 2018
;		Purpose :	Compiles a list of word split by tags.
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
;					Compile word list at BC. HLDE contain A/B
;
; ***************************************************************************************

COMCompileWordList:
		push 	bc 									; save non value registers (HLDE can change)
		push 	ix

__COMWLoop:
		ld 		a,(bc) 								; reached the end ?
		cp 		$80
		jr 		z,__COMWExit

		ld 		a,(bc) 								; 1 00 lllll (Red)
		and 	$60
		call 	z,COMDCompileRedWord 				

		ld 		a,(bc) 								; 1 01 lllll (Green)
		and 	$60
		cp 		$20
		call 	z,COMCCompileGreenWord

		ld 		a,(bc) 								; 1 10 lllll (Yellow)
		and 	$60
		cp 		$40
		call 	z,COMXExecuteYellowWord

__COMWNext: 										; advance to next tag.
		inc 	bc 
		ld 		a,(bc)
		bit 	7,a
		jr 		z,__COMWNext
		jr 		__COMWLoop 							; go do that.
		
__COMWExit: 										; exit the routine
		pop 	ix
		pop 	bc
		ret
;
;		Jump here on error.
;
COMError:
		push 	bc
		pop 	hl
		inc 	hl
		jp 		ErrorHandler


; ***************************************************************************************
;
;	 		Compiles a red word. Add to the currently selected dictionary
;
; ***************************************************************************************

COMDCompileRedWord:
		call 	DICTAddWord 						; add dictionary
		push 	hl 									; compile standard prefix		
		ld 		a,$CD 							
		call 	FARCompileByte
		ld 		hl,COMUCompileCallToSelf
		call 	FARCompileWord
		pop 	hl
		ret
	
; ***************************************************************************************
;
;										Green word.
;
; ***************************************************************************************

COMCCompileGreenWord:	
		push 	de 									; save DE & HL
		push	hl
		call 	DICTFindWord 						; look in dictionary.
		jr 		nc,__COMCGreenExecuteToCompile
		inc 	bc 									; get first character
		ld 		a,(bc)
		dec 	bc
		cp 		'"'									; string ?
		jr 		z,__COMCString
		call 	CONSTConvert 						; is it a number
		jp 		c,COMError 							; no error.
		call 	COMUCompileConstant 				; compile constant code
		pop 	hl 									; restore A/B
		pop 	de
		ret

__COMCString:
		ld 		a,$18 								; JR <size>
		call 	FARCompileByte
		ld 		a,(bc)
		and 	$1F
		call 	FARCompileByte
		ld 		hl,(Here) 							; save address start
		push 	hl
		dec 	a 									; empty string ?
		jr 		z,__COMCStringOver
		ld 		e,a
		inc 	bc 									; skip tag
__COMCOut: 											; output each character
		inc 	bc
		ld 		a,(bc)
		cp 		'_'
		jr 		nz,__COMCNotSpace
		ld 		a,' '
__COMCNotSpace:
		call 	FARCompileByte
		dec 	e
		jr 		nz,__COMCOut
__COMCStringOver:
		xor 	a 									; null byte
		call 	FARCompileByte
		pop 	hl
		call 	COMUCompileConstant 				; compile the constant.
		pop 	hl 									; restore AB
		pop 	de
		ret


__COMCGreenExecuteToCompile:
		ld 		a,e 								; switch to page
		call 	PAGESwitch
		jr 		__COMXExecute 						; and use the 'yellow' execution code.

; ***************************************************************************************
;
;						Execute the Yellow tagged word at BC
;

; ***************************************************************************************

COMXExecuteYellowWord:		
		push 	de 									; save A & B
		push 	hl 
		call 	DICTFindWord 						; try to find the word.
		jr 		nc,__COMXYellowWord
		call 	CONSTConvert 						; try as a constant ?
		jp 		c,COMError 							; fail then error.

		pop 	de 									; pop old HL into DE
		inc 	sp 									; throw away the old DE
		inc 	sp
		ret

__COMXYellowWord:
		ld 		a,e 								; switch to page E
		call 	PAGESwitch
		push 	hl 									; save HL
		call 	__COMXIsStandard 					; is it a standard / executable word
		ld 		hl,__COMX_NoExec
		jp		nz,ErrorHandler 					; if not, go to error handler.

		pop 	hl 									; address
		inc 	hl 									; skip over leading CALL
		inc 	hl
		inc 	hl

__COMXExecute:
		pop 	de 									; restore A/B, the wrong way round
		ex 		(sp),hl 							; address now on TOS.
		ex 		de,hl 								; right way round.
		ex 		(sp),ix 							; now in IX, old IX on TOS.
		call 	__CALLIX 							; call (IX)
		pop 	ix 									; restore IX
		call 	PAGERestore 						; restore page
		ret
__CALLIX:	
		jp 		(ix)
__COMX_NoExec:
		db 		"can't exec",0
;
;		Check the call at HL is to either COMUCopyCode or COMUCompileCallToSelf. We cannot execute
; 		anything else.
;
__COMXIsStandard:
		ld 		a,(hl) 								; check first is a CALL.
		inc 	hl
		cp 		$CD
		ret 	nz		

		ld 		a,(hl)
		inc 	hl
		cp 		COMUCompileCallToSelf&255
		jr 		z,__COMXTest1
		cp 		COMUCopyCode&255
		ret 	nz

		ld 		a,(hl)
		cp 		COMUCopyCode/256
		ret
__COMXTest1:
		ld 		a,(hl)
		cp 		COMUCompileCallToSelf/256
		ret
		ret

		
