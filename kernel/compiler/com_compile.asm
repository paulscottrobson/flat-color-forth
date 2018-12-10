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
		push 	hl 									; save A & B
		push 	de 
		ld 		a,$80 								; search MACRO
		call 	DICTFindWord
		jp 		nc,__COMXFoundWord 					; if found, go execute it.
		xor 	a 									; search FORTH
		call 	DICTFindWord
		jp 		nc,__COMCCompileWord 				; compile a word if found.
		call 	CONSTConvert 						; convert to integer
		jp 		c,COMError 							; failed.
;
;		Compile constant
;
		call 	COMUCompileConstant 				; compile constant code
		pop 	de 									; restore A/B
		pop 	hl
		ret
;
;		Compile call
;
__COMCCompileWord:
		call 	COMCCompileCallEHL 					; compile the call.
		pop 	de 									; restore A/B
		pop 	hl
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
		push 	hl 									; save A & B
		push 	de 
		ld 		a,$80 								; search MACRO
		call 	DICTFindWord
		jp 		nc,__COMCCompileWord 				; compile a word if found.
		jp 		COMError
		
	