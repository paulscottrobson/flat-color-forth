; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		dictionary.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		20th December 2018
;		Purpose :	Dictionary handler.
;
; ***************************************************************************************
; ***************************************************************************************

; ***********************************************************************************************
;
;		Add Dictionary Word. Name is a tagged string at BC ends in $80-$FF, uses the current 
;		page/pointer values. 
;
; ***********************************************************************************************

DICTAddWord:
		push 	af 									; registers to stack.
		push 	bc
		push 	de
		push	hl
		push 	ix

		push 	bc 									; put word address in HL
		pop 	hl 

		ld 		a,(hl) 								; get length from tag into B
		and 	$1F
		ld 		b,a
		inc 	hl 									; HL = first character

		ld 		a,DictionaryPage					; switch to dictionary page
		call 	PAGESwitch

		ld 		ix,$C000							; IX = Start of dictionary

__DICTFindEndDictionary:
		ld 		a,(ix+0) 							; follow down chain to the end
		or 		a
		jr 		z,__DICTCreateEntry
		ld 		e,a
		ld 		d,0
		add 	ix,de
		jr 		__DICTFindEndDictionary

__DICTCreateEntry:
		ld 		a,b
		add 	a,5
		ld 		(ix+0),a 							; offset is length + 5

		ld 		a,(HerePage)						; code page
		ld 		(ix+1),a

		ld 		de,(Here) 							; code address
		ld 		(ix+2),e
		ld 		(ix+3),d 

		ld 		(ix+4),b 							; put length in.

		ex 		de,hl 								; put name in DE
__DICTAddCopy:
		ld 		a,(de) 								; copy byte over as 7 bit ASCII.
		ld 		(ix+5),a
		inc 	ix 									
		inc 	de
		djnz	__DICTAddCopy 						; until string is copied over.

		ld 		(ix+5),0 							; write end of dictionary zero.

		call 	PAGERestore
		pop 	ix 									; restore and exit
		pop 	hl
 		pop 	de
		pop 	bc
		pop 	af
		ret

; ***********************************************************************************************
;
;			Find word in dictionary. BC points to tagged string which is the name.
; 
;			On exit, HL is the address and E the page number with CC if found, 
;			CS set and HL=DE=0 if not found.
;
; ***********************************************************************************************

DICTFindWord:
		push 	bc 								; save registers - return in EHL Carry
		push 	ix

		ld 		h,b 							; put address of name in HL. 
		ld 		l,c

		ld 		a,DictionaryPage 				; switch to dictionary page
		call 	PAGESwitch

		ld 		ix,$C000 						; dictionary start			
__DICTFindMainLoop:
		ld 		a,(ix+0)						; examine offset, exit if zero.
		or 		a
		jr 		z,__DICTFindFail

		ld 		a,(ix+4) 						; length
		xor 	(hl) 							; xor with tag length
		and 	$1F 							; check lower 5 bits
		jr 		nz,__DICTFindNext 				; if different can't be this word.

		push 	ix 								; save pointers on stack.
		push 	hl 

		ld 		a,(ix+4)						; get the word length to test into B
		and 	$1F
		ld 		b,a 							; into B
		inc 	hl 								; skip over tag byte
__DICTCheckName:
		ld 		a,(ix+5) 						; compare dictionary vs character.
		cp 		(hl) 							; compare vs the matching character.
		jr 		nz,__DICTFindNoMatch 			; no, not the same word.
		inc 	hl 								; HL point to next character
		inc 	ix
		djnz 	__DICTCheckName

		pop 	hl 								; Found a match. restore HL and IX
		pop 	ix
	
		ld 		d,0 							; D = 0 for neatness.
		ld 		e,(ix+1)						; E = page
		ld 		l,(ix+2)						; HL = address
		ld 		h,(ix+3)		
		xor 	a 								; clear the carry flag.
		jr 		__DICTFindExit

__DICTFindNoMatch:								; this one doesn't match.
		pop 	hl 								; restore HL and IX
		pop 	ix
__DICTFindNext:
		ld 		e,(ix+0)						; DE = offset
		ld 		d,$00
		add 	ix,de 							; next word.
		jr 		__DICTFindMainLoop				; and try the next one.

__DICTFindFail:
		ld 		de,$0000 						; return all zeros.
		ld 		hl,$0000
		scf 									; set carry flag
__DICTFindExit:
		push 	af
		call 	PAGERestore
		pop 	af
		pop 	ix 								; pop registers and return.
		pop 	bc
		ret

; ***********************************************************************************************
;
;						Remove underscore prefixed words from the dictionary.
;
; ***********************************************************************************************

DICTCrunchDictionary:
		push 	bc 							
		push 	de
		push	hl
		push 	ix

		ld 		a,DictionaryPage 				; switch to dictionary page
		call 	PAGESwitch
		ld 		ix,$C000 						; dictionary start			
__DICTCrunchNext:
		ld 		a,(ix+0)
		or 		a
		jr 		z,__DICTCrunchExit
		ld 		a,(ix+5) 						; check first character
		cp 		'_'								; if not _, try next
		jr 		nz,__DICTCrunchAdvance.
		db 		$DD,$01
		push 	ix
		pop  	de 								; DE = start position
		ld 		l,(ix+0)						; HL = start + offset
		ld 		h,0
		add 	hl,de
		ld	 	a,h 							; BC = count
		cpl 	
		ld 		b,a
		ld 		a,l
		cpl
		ld 		c,a
		ldir 									; copy it
		jr 		__DICTCrunchNext 				; retry from the same position.


__DICTCrunchAdvance:							; go to next slot.
		ld 		e,(ix+0)						; DE = offset
		ld 		d,0
		add 	ix,de 							; go gorward
		jr 		__DICTCrunchNext

__DICTCrunchExit:
		pop 	ix
		pop 	hl
		pop 	de
		pop 	bc
		ret

