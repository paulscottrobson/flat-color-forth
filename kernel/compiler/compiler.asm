; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		compiler.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		10th December 2018
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
		ld 		a,(bc) 								; central dispatcher.
		cp 		$82
		call 	z,COMCCompileGreenWord
		ld 		a,(bc)
		cp 		$83
		call 	z,COMDCompileMagentaWord
		ld 		a,(bc)
		cp 		$84
		call 	z,COMDCompileRedWord
		ld 		a,(bc)
		cp 		$85
		call 	z,COMCCompileCyanWord
		ld 		a,(bc)
		cp 		$86
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

