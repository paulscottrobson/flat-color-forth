; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		buffer.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		20th December 2018
;		Purpose :	Scan pages for buffers.
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
;						Scan and compile all pages with buffers
;
; ***************************************************************************************

BUFFScan:
		ld 		hl,$AA01	 						; setup A and B
		ld 		de,$BB02
		ld 		hl,$0000
		ld 		de,$0000
		ld 		(__ARegister),hl
		ld 		(__BRegister),de
		ld 		e,FirstSourcePage 					; set the first source page.
;
;		Loop here to scan the next source page.
;
__BUFFScanSourcePage:
		ld 		a,e 								; switch to the source page.
		call 	PAGESwitch
		ld 		ix,$C000 							; next page to scan.
;
;		Come here to scan the buffer at E:HL
;
__BUFFScanNextPageInBuffer:
		ld 		a,(ix+0) 							; is the buffer empty ?
		cp 		$80
		jr 		z,__BUFFNextPage 					; don't bother with this whole page.

		push 	de 									; save E

		push 	ix									; copy into edit buffer.
		pop 	hl
		ld 		de,EditBuffer
		ld 		bc,EditPageSize
		ldir 

		ld 		bc,EditBuffer 						; BC is the code to compile.
		ld 		hl,(__ARegister)					; load registers
		ld 		de,(__BRegister)
		call 	COMCompileWordList 					; compile that word list.
		ld 		(__BRegister),de
		ld 		(__ARegister),hl
		pop 	de 									; restore E
		
__BUFFNextPage:		
		ld 		bc,EditPageSize 					; go to next buffer
		add 	ix,bc
		jr 		nc,__BUFFScanNextPageInBuffer

		call 	PAGERestore 						; back to original page

		inc 	e 									; go forward 2 (using 16k pages)
		inc 	e
		ld 		a,e  								; check scanned all buffers.
		cp 		FirstSourcePage+SourcePageCount 
		jr 		nz,__BUFFScanSourcePage

		jp 		CommandLineStart


