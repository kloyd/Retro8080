CR	equ 0dh
LF	equ 0ah
	ORG 00H
	lxi h,0
	mvi d,080h
	LXI SP,2000h

	PUSH D
	LXI D,welcomemsg

	CALL PRINTIT
	POP D
	PUSH D
	LXI D,instruction
	CALL PRINTIT
	POP D

	HLT

PRINTIT
	PUSH PSW    ;  Save accumulator and status since we are going to clobber them.
OUT1CH	LDAX D      ;  LET A = (DE)
	CPI 0h      ;  Done when null terminated.
	JZ DONE
	OUT 1h      ;  Output the character at the current address to the console
	INR E       ;  Increment the address of the current character
	JMP OUT1CH
DONE	POP PSW     ;  put back accumulator and status.
	RET

welcomemsg	DB "Welcome to the gambling halls of Mooreheim!",CR,LF,0h
instruction	DB "Toggle 1st 5 switches to store your dice.",CR,LF,0h

END