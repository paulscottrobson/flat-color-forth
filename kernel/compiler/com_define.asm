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
;	 		Compiles a red word. Add to the currently selected dictionary
;
; ***************************************************************************************

COMDCompileRedWord:
	call 	DICTAddWord 							; add to dictionary
	push 	hl
	ld 		a,$CD 									; Compile CALL <SelfCompiler>
	call 	FARCompileByte
	ld 		hl,COMUCompileCallToSelf 		
	call 	FARCompileWord
	pop 	hl
	ret
	
