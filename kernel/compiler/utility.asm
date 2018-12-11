; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		utility.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		10th December 2018
;		Purpose :	Compile Utilities
;
; ***************************************************************************************
; ***************************************************************************************

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
		ld 		b,(hl) 								; count to copy
__COMUCopyLoop:
		inc 	hl
		ld 		a,(hl) 								; read a byte
		call 	FARCompileByte 						; compile it
		djnz	__COMUCopyLoop
		pop 	hl 									; restore old HL.
		ret

; ***************************************************************************************
;
;		Compile code to do a call to the return address A':HL from HERE (addr+page)
;
; ***************************************************************************************

COMUCompileCallToSelf:
	ex 		(sp),hl 								; old HL on stack, return address in HL
	;
	;		TODO: Cross page if target >= $C000 and not current page.
	;
	ld 		a,$CD 									; Z80 call
	call 	FARCompileByte
	call 	FARCompileWord
	pop 	hl 										; restore old HL.
	ret

