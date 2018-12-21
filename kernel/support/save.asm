; *********************************************************************************
; *********************************************************************************
;
;		File:		save.asm
;		Purpose:	Save memory to storage 
;		Date : 		21st December 2018
;		Author:		paul@robsons.org.uk
;
; *********************************************************************************
; *********************************************************************************

SAVEMemory:
		push 	bc
		push 	de
		push 	hl
		push 	ix
		push 	hl
		pop 	ix
		call 	WriteNextMemory
		pop 	ix
		pop 	de
		pop 	hl
		pop 	bc
		ret

SAVEImageName:

; ***************************************************************************************
;
;			Write ZXNext memory from $8000-$BFFF then pages from $C000-$FFFF
;
; ***************************************************************************************

WriteNextMemory:
		call 	FindDefaultDrive 							; get default drive
		call 	OpenFileWrite 								; open for writing
		ld 		ix,$8000  									; write $8000-$BFFF
		call 	Write16kBlock
		ld 		b,DictionaryPage 							; dictionary page first.
__WriteBlockLoop:
		ld 		a,b
		call 	PAGESwitch
		ld 		ix,$C000 									; write block out
		call 	Write16kBlock
		call 	PAGERestore
		inc 	b 											; skip forward 2 blocks
		inc 	b
		ld 		a,(NextFreePage)							; until memory all written out.
		cp 		b
		jr 		nz,__WriteBlockLoop
		call 	CloseFile 									; close file
		ret

; ***************************************************************************************
;
;								 Access the default drive
;
; ***************************************************************************************

FindDefaultDrive:
		xor 	a
		rst 	$08 										; set the default drive.
		db 		$89
		ld 		(SAVEDefaultDrive),a
		ret

; ***************************************************************************************
;
;									Open file write
;
; ***************************************************************************************

OpenFileWrite:
		push 	af
		push 	bc
		push 	ix
		ld 		b,12
		ld 		a,(SAVEDefaultDrive)
		rst 	$08
		db 		$9A
		ld 		(SAVEFileHandle),a 
		pop 	ix
		pop 	bc
		pop 	af
		ret

; ***************************************************************************************
;
;									Write 16k block
;
; ***************************************************************************************

Write16kBlock:
		push 	af
		push 	bc
		push 	ix
		ld 		a,(SAVEFileHandle)
		ld 		bc,$4000
		rst 	$08
		db 		$9E
		pop 	ix
		pop 	bc
		pop 	af
		ret

; ***************************************************************************************
;
;										Close open file
;
; ***************************************************************************************

CloseFile:
		push 	af
		ld 		a,(SAVEFileHandle)
		rst 	$08
		db 		$9B
		pop 	af
		ret		



