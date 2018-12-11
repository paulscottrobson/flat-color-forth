; *********************************************************************************
; *********************************************************************************
;
;		File:		command.asm
;		Purpose:	Command line code
;		Date : 		10th December 2018
;		Author:		paul@robsons.org.uk
;
; *********************************************************************************
; *********************************************************************************

CommandLineStart:
		ld 		hl,__CLIWelcome
		ld 		c,5
		jr 		WarmStartSetup
WarmStart:
		ld 		hl,__CLIWarmStart
		ld 		c,4
		jr 		WarmStartSetup
ErrorHandler:										; error routines.
		ld 		c,2
WarmStartSetup:
		ld 		sp,StackTop							; reset Z80 Stack

		ld 		a,FirstCodePage 					; reset the paging system
		call 	PAGEInitialise
		push 	hl 									; save error message

		ld 		hl,(__DIScreenSize) 				; clear the 2nd line
		ld 		de,-64
		add 	hl,de
		ld 		b,32
__CLIClear:
		ld 		de,$0120
		call 	GFXWriteCharacter
		inc 	hl
		djnz 	__CLIClear

		ld 		hl,(__DIScreenSize) 				; half way down 2nd line.
		ld 		de,-48
		add 	hl,de

		ld 		d,c 								; colour in D
		pop 	bc 									; text in BC
__CLIPrompt: 										; write prompt / message / etc.
		ld 		a,(bc)
		or 		a
		jr 		z,__CLIPromptExit
		jp 		m,__CLIPromptExit
		ld 		e,a
		call 	GFXWriteCharacter
		inc 	bc
		inc 	hl
		jr 		__CLIPrompt
__CLIPromptExit:
		ld 		hl,(__ARegister) 					; load A/B in
		ld 		de,(__BRegister) 					; update that part of the display.
		call 	DEBUGShow

		ld 		hl,(__DIScreenSize)					; bakck to start of 2nd to last row
		ld		de,-64
		add 	hl,de
		ld 		ix,__CLIBuffer 						; IX points to buffer
__CLILoop:
		ld 		de,$057F 							; display prompt
		call 	GFXWriteCharacter
		call 	__CLIGetKey 						; get key
		cp 		13 									; exec on CR
		jr 		z,__CLIExecute
		cp 		' ' 								; exec on space
		jr 		z,__CLIExecute
		jp 		c,WarmStart 						; any other < ' ' warm start e.g. start again

		ld 		(ix+0),a 							; save char in buffer
		ld 		d,6 								; draw it
		ld 		e,a
		call 	GFXWriteCharacter

		ld 		a,l 								; reached 15 chars, don't add
		and 	15
		cp 		15
		jr 		z,__CLILoop
		inc 	hl 									; move forward
		inc 	ix
		jr 		__CLILoop

__CLIExecute:
		ld 		(ix+0),$80 							; mark end

		ld 		bc,__CLIBuffer-1 					; get address of buffer into BC
		ld 		a,l 								; get length
		and 	$0F 
		or 		$C0 								; 1 10 lllll
		ld 		(bc),a 								; make that the tag/

		ld 		ix,ExecFrameSpace2 					; compile it here
		call 	COMCompileCodeAtIX

		ld 		hl,(__ARegister) 					; load A/B in
		ld 		de,(__BRegister)
		call 	ExecFrameSpace2 					; execute the word.
		ld 		(__BRegister),de 					; save A/B
		ld 		(__ARegister),hl
		jp 		WarmStart

__CLIGetKey:
		call 	__CLIGetChange
		or 		a
		jr 		z,__CLIGetKey
		ret
__CLIGetChange:
		push 	bc
		ld 		a,(__CLICurrentKey)
		ld 		b,a
__CLIChangeLoop:
		call 	IOScanKeyboard
		cp 		b
		jr 		z,__CLIChangeLoop
		ld 		(__CLICurrentKey),a
		pop 	bc
		ret

__CLIWelcome:
		db 		"flat color forth",$00
__CLIWarmStart:
		db 		"ready",$00
