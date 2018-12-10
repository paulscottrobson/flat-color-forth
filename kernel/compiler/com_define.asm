; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		com_define.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		10th December 2018
;		Purpose :	Executes a red or magenta word.
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
;					Compile the magenta word (variable definition)
;
; ***************************************************************************************

COMDCompileMagentaWord:
	ld 		a,$80 									; put in MACRO
	call 	DICTAddWord
	push 	hl
	ld 		a,$CD 									; code is CALL VariableHandler
	call 	FARCompileByte
	ld 		hl,COMDVariableHandler
	call 	FARCompileWord
	ld		hl,$0000								; compile var space
	call 	FARCompileWord
	pop 	hl
	ret
;
;	This code is executed when the word is 'compiled' (it's in Macro)
;
COMDVariableHandler:
	ld 		a,$EB 									; ex de,hl
	call 	FARCompileByte
	ld 		a,$21 									; ld hl,xxxx
	call 	FARCompileByte
	ex 		(sp),hl 								; address on TOS (preserves HL)
	call 	FARCompileWord
	pop 	hl
	ret

; ***************************************************************************************
;
;	 		Compiles a red word. Add to the currently selected dictionary
;
; ***************************************************************************************

COMDCompileRedWord:
	ld 		a,(__DICTSelector)						; put in relevant dictionary
	call 	DICTAddWord
	ret

