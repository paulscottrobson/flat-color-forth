; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		com_execute.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		10th December 2018
;		Purpose :	Executes a yellow word.
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
;						Execute the Yellow tagged word at BC
;
; ***************************************************************************************

COMXExecuteYellowWord:
		push 	bc 									; save BC and IX
		push 	ix
		ld 		ix,ExecFrameSpace1 					; compile the code here.
		call 	COMCompileCodeAtIX  			
		call 	ExecFrameSpace1 					; execute the code.
		pop 	ix 									; restore IX and BC
		pop 	bc 
		ret

; ***************************************************************************************
;
;		Compile code to execute the word at BC at address IX, DEHL contain A&B
;
; ***************************************************************************************

COMCompileCodeAtIX:
		push 	ix 									; save new HERE on the stack
		ld 		ix,(Here) 							; get old Here
		ex 		(sp),ix 							; old here on stack, new HERE in IX
		ld 		(Here),ix 							; set new Here.
		call 	COMCCompileGreenWord 				; do the compilation using the Green code.
		ld 		a,$C9 								; compile "RET"
		call 	FARCompileByte
		pop 	ix 									; restore old HERE
		ld 		(Here),ix 							; and write it back.
		ret 									




