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
	ret

; ***************************************************************************************
;
;	 Compiles a red word. If the previous word is open (e.g. CurrentDef is non-zero)
;	 throw an error as previous not closed. Store current def and compile prefix, set
;	 CurrentExit to zero so ;s can compile the postfix.
;
; ***************************************************************************************

COMDCompileRedWord:
	ret

