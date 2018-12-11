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
		push 	bc 									; save BC and IX
		push 	ix

		push 	de 									; save A+B
		push 	hl

		call 	DICTFindWord 						; if found in dictionary
		jr 		nc,__COMCExecuteWord 				; execute to compile
		call 	CONSTConvert 						; try as a constant.
		jp 		c,COMError 							; no fail
		call 	COMUCompileConstant 				; constant code
		pop 	hl 									; restore A+B
		pop 	de
		pop 	ix 									; restore BC and IX.
		pop 	bc
		ret
;
;		Execute word at E:HL
;
__COMCExecuteWord:
		call 	COMCExecuteWord 					; execute the word at E:HL
		pop 	hl  								; restore possibly changed A+B
 		pop 	de
		pop 	ix 									; restore BC and IX.
		pop 	bc
		ret

; ***************************************************************************************
;
;			Execute word at E:HL. Below return address on stack is A then B
;
; ***************************************************************************************

COMCExecuteWord:
		pop 	ix 									; IX contains the return address now.
		ld 		a,e 								; go to the page with the routine on it.
		call 	PAGESwitch
		ld 		(__CALLIndirect+1),hl				; save Jump vector address
		pop 	hl 									; restore A + B
		pop 	de
		push 	ix 									; save IX
		call 	__CALLIndirect 						; go do the routine
		pop 	ix 									; restore IX
		push 	de 									; push DE/HL back on stack.
		push 	hl
		call 	PAGERestore 						; restore page.
		jp 		(ix) 								; and return.
