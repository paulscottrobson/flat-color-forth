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
		push 	hl 									; save A & B
		push 	de 
		xor 	a 									; search FORTH
		call 	DICTFindWord
		jr 		nc,__COMXFoundWord 					; found word ?
		call 	CONSTConvert 						; check if constant
		jp 		c,COMError 							; failed
;
;		Execute a constant
;
		pop 	de									; restore A & B, doing it this way does "HL->DE"
		pop 	de 									; HL already contains the constant.
		ret
;
;		Execute word in E:HL. DE/HL are on stck.
;
__COMXFoundWord:
		ld 		a,e 								; switch Page
		call 	PAGESwitch
		push 	hl 									; code address in IX
		pop 	ix
 		pop 	de 	 								; restore A/B
		pop 	hl 
		push 	bc 									; preserve BC
		call 	__COMXCallIX 						; do CALL (IX)
		pop 	bc 									; restore BC
		call 	PAGERestore 						; restore page.
		ret

__COMXCallIX:
		jp 		(ix)		