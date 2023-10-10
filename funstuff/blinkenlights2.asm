; Altair simple blinken lights
; Does what Kill-The-Bit does, only it doesn't kill bits
; Reads the SENSE switches and puts that into C making BC = 00SS where SS is sense switches
; if Sense == 0, it adds one otherwise it would be an endless loop
; See DAD B (Add BC to HL... HL will never increment)
;
; Start at 0000

	ORG 0h
MAIN	LXI H,0		; hl = 0000
	MVI D, 080h	; Initial pattern = bit 15 will be on.

INPDEL	IN 0ffh
	CPI 0ffh	; All Sense switches on is a HALT.
	JZ DONE
	ADI 1
	MOV C, A	; sense switches to B
	MVI B, 0	; BC = <sense>00


BLINK	LDAX D
	LDAX D
	LDAX D
	LDAX D
	DAD B
	JNC BLINK
	MOV A,D
	RRC
	MOV D,A
	JMP INPDEL

DONE	HLT

SEMI	DW *+2
	END