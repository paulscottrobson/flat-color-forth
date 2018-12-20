; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		compiler.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		12th December 2018
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
		db 		$DD,$01
		ret
	
; ***************************************************************************************
;
;										Green word.
;
; ***************************************************************************************

COMCCompileGreenWord:	
		db 		$DD,$01
		ret

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

		
