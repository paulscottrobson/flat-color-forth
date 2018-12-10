; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		com_compile.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		10th December 2018
;		Purpose :	Executes a green/cyan word.
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
;										Green word.
;
; ***************************************************************************************

COMCCompileGreenWord:
	ret

; ***************************************************************************************
;
;							Compile code to do a call to E:HL
;
; ***************************************************************************************

COMCCompileCallEHL:
	;
	;		TODO: Cross page if target >= $C000 and not current page.
	;
	ld 		a,$CD 									; Z80 call
	call 	FARCompileByte
	call 	FARCompileWord
	ret

; ***************************************************************************************
;
;						Cyan word - compile if in MACRO
;
; ***************************************************************************************
	
COMCCompileCyanWord:
	ret

	