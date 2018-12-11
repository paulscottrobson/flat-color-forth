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
		push 	de 									; save A+B
		push	hl 
		call 	DICTFindWord 						; look up word
		jr 		nc,__COMXExecute					; if found, we need to run it.
		call 	CONSTConvert 						; try as integer
		jp 		c,COMError 							; neither work.
;
;		Do a constant
;
		pop 	de 									; restore HL into DE
		inc 	sp 									; throw away the other value.
		inc 	sp
		pop 	ix 									; restore IX and BC
		pop 	bc 
		ret

__COMXExecute:
		ld 		ix,ExecFrameSpace1 					; compile it here
		call 	COMCompileEHLAtIX					; compile E:HL
		pop 	de 									; restore DE & HL
		pop 	hl
		call 	EXECFrameSpace1 					; execute the actual code.
		pop 	ix 									; restore IX & BC
		pop 	bc
		ret

; ***************************************************************************************
;
;				Compile code to execute the word at E:HL at address IX.
;
; ***************************************************************************************

COMCompileEHLAtIX:
		ld 		bc,(Here) 							; push Here on the stack
		push 	bc
		ld 		(Here),ix 							; set here to IX.

		ld 		a,e 								; switch to page E
		call 	PAGESwitch
		ld 		(__CALLIndirect+1),hl 				; set the call address
		ld 		hl,$0000 							; we provide A/B values of $0000
		ld 		de,$0000 							; executing words that are immediately compiled have no context

		call 	__CALLIndirect 						; this will compile the word, whatever it is.

		ld 		a,$C9
		call 	FARCompileByte 						; compile a byte.

		pop 	bc 									; get the old value of HERE
		ld 		(Here),bc 							; put HERE back.
		ret 									




