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
		db 		$DD,$01
		ret

		
