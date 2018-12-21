; *********************************************************************************
; *********************************************************************************
;
;		File:		xpage.asm
;		Purpose:	Cross Page Calling code.
;		Date : 		21st December 2018
;		Author:		paul@robsons.org.uk
;
; *********************************************************************************
; *********************************************************************************



; *********************************************************************************
;
;							  Call Generator Macro
;
; *********************************************************************************


CROSSExec: macro 									; groups of four calls. each calls for a different page	
		ld 		a,\0+0
		jp 		CROSSPageMain
		ld 		a,\0+2
		jp 		CROSSPageMain
		ld 		a,\0+4
		jp 		CROSSPageMain
		ld 		a,\0+6
		jp 		CROSSPageMain
		endm

; *********************************************************************************
;
;						Table of function calls for each page.
;
; *********************************************************************************

CROSSPageTable: 									; do for every page we use.
		CROSSExec 	$20	
		CROSSExec 	$28	
		CROSSExec 	$30	
		CROSSExec 	$38	
		CROSSExec 	$40	
		CROSSExec 	$58	
		CROSSExec 	$50	
		CROSSExec 	$58	

; *********************************************************************************
;
;						 Common code for CrossPage Calls
;
; *********************************************************************************

CROSSPageMain:
		db 		$ED,$92,$56							; switch to page A
		inc 	a
		db 		$ED,$92,$57						
		dec 	a

		ex 		af,af' 								; put new page in A', old page in A.
		push 	af 									; save old page.

		call 	CROSSReturnViaBC 					; returns to here via BC.

		pop 	af 									; restore old page

		db 		$ED,$92,$56							; switch to old page
		inc 	a
		db 		$ED,$92,$57						
		dec 	a

		ex 		af,af'								; update A' and exit.
		ret

CROSSReturnViaBC:
		push 	bc
		ret

