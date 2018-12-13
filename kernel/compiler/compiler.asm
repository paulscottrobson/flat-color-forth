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
		call 	DICTAddWord 						; add word to the dictionary.
		ret
	
; ***************************************************************************************
;
;										Green word.
;
; ***************************************************************************************

COMCCompileGreenWord:	
		push 	de 									; save A & B
		push 	hl
		ld 		a,$80 								; check for "compiles" entries
		call 	DICTFindWord
		jr 		nc,__COMXExecuteWord 				; if found execute it.
		ld 		a,$00 								; check for normal entries
		call 	DICTFindWord
		jr 		nc,__COMCCompile 					; if found, then compile it.
		call 	DICTFindWord
		call 	CONSTConvert 						; convert to integer
		jp 		c,COMError 							; failure
		call 	COMUCompileConstant 				; compile as constant.
		pop 	hl
		pop 	de
		ret
;
__COMCCompile:
		call 	COMUCompileCall 					; compile a call to E:HL
		pop 	hl
		pop 	de
		ret
;

; ***************************************************************************************
;
;						Execute the Yellow tagged word at BC
;
; ***************************************************************************************

COMXExecuteYellowWord:		
		push 	de 									; save A & B
		push 	hl
		ld 		a,$00 								; look in normal words
		call 	DICTFindWord
		jr 		nc,__COMXExecuteWord
		call 	CONSTConvert 						; check if number
		jp 		c,COMError 							; if not, report error.

		pop 	de 									; restore A into DE, keep HL the same
		inc 	sp
		inc 	sp
		ret

__COMXExecuteWord:
		ld 		a,e 								; switch to the relevaant page
		call 	PAGESwitch 						
		pop 	de 									; restore A into DE, wrongly.
		ex 		(sp),hl 							; now A and B are the wrong way round and exec is on TOS
		ex 		de,hl 								; A and B are now correct.
		ex 		(sp),ix 							; IX now contains address, old IX on TOS
		call 	__CallIX 							; call (IX)
		call 	PAGERestore 						; restore original page
		pop 	ix 									; restore original IX.
		ret

__CallIX:	 										; call here does CALL (IX)
		jp 		(ix)

		
