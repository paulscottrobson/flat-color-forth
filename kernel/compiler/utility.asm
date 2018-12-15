; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		utility.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		12th December 2018
;		Purpose :	Compile Utilities
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
;						 Compile call to code following this call
;
; ***************************************************************************************

COMUCompileCallToSelf:
		ex 		(sp),hl 							; addr in HL, old HL on TOS
		ld 		a,$CD								; CALL xxxx
		call 	FARCompileByte
		call 	FARCompileWord						; compile address
		pop 	hl 									; restore HL.
		ret

; ***************************************************************************************
;
;							Compile code to load constant
;
; ***************************************************************************************

COMUCompileConstant:
		ld 		a,$EB 								; EX DE,HL
		call 	FARCompileByte
		ld 		a,$21								; LD HL,xxxx
		call 	FARCompileByte
		call 	FARCompileWord						; compile constant
		ret

; ***************************************************************************************
;
;			Compile code to copy A bytes from code following caller (for MACRO)
;
; ***************************************************************************************

COMUCopyCode:
		ex 		(sp),hl 							; old HL on stack, new HL is return address
		push 	bc 									; preserve BC
		inc 	hl 									; skip the LD A opcode.
		ld 		b,(hl) 								; count to copy
__COMUCopyLoop:
		inc 	hl
		ld 		a,(hl) 								; read a byte
		call 	FARCompileByte 						; compile it
		djnz	__COMUCopyLoop
		pop 	bc 									; restore BC
		pop 	hl 									; restore old HL.
		ret


