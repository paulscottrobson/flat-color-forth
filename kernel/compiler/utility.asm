; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		utility.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		20th December 2018
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
		push 	bc

		ld 		a,h 								; is it a call to $Cxxx ?
		cp 		$C0
		jr 		c,__COMUSimpleCallCompile

		ex 		af,af'								; get the current page e.g. the one we are calling because
		ld 		b,a 								; we compile by calling this routine
		ex 		af,af' 
		ld 		a,(HerePage)						; and this is the page where the call will be compiled
		cp 		b 									; if they are the same, a simple call will do.
		jr 		z,__COMUSimpleCallCompile

;		ld 		a,$DD
;		call 	FARCompileByte
;		ld 		a,$01
;		call 	FARCompileByte

		ld 		a,$01 								; compile LD BC,<target address>
		call 	FARCompileByte
		call 	FARCompileWord
		push 	de 									; save DE

		ld 		a,b 								; BC = (target page - $20)/2
		sub 	$20 								; page pair index.
		srl 	a
		ld 		c,a
		ld 		b,0
		ld 		h,b 								; multiply by 5 into HL
		ld 		l,c
		add 	hl,hl
		add 	hl,hl
		add 	hl,bc
		ld 		bc,CrossPageTable 					; add the cross page table base
		add 	hl,bc

		ld 		a,$CD								; CALL xxxx
		call 	FARCompileByte
		call 	FARCompileWord						; compile address in cross page table.

		pop 	de 									; restore DE + HL
		pop 	bc
		pop 	hl
		ret		

__COMUSimpleCallCompile:
		ld 		a,$CD								; CALL xxxx
		call 	FARCompileByte
		call 	FARCompileWord						; compile address
		pop 	bc
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


