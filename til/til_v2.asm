; TIL for 8080
; Register Usage
; SP = SP
; I (Instruction Register) => BC
; WA (Word Address) => DE
; RSP Return Stack Pointer => ??

; HL scratch used for memory moves
; SP data stack pointer

; Virtual Registers
; I = Instruction Register - Address of next instruction in threaded list.
; WA = Word Address - Word Address of current keyword or address of first keyword
; CA = Code Address
; RS = Return Stack
; SP = Stack Pointer ... Same as 8080 SP
; PC = Program Counter... same as 8080 PC


	JP START

	ORG 1000h

; Startup
START:
	LXI D, RSTMSG   ;LD DE, RSTMSG
	; rickety Memory move of 8080 cpu... set  HL then use mov a,m or mov m,a
	LXI H, BASE
	MOV A, M
	ANA A
	JNZ ABORT ;JR NZ, ABORT
	MVI A, 10 ;LD A, 10
	MOV M,A   ; LD M, A
	LXI D, SRTMSG ; LD DE, SRTMSG

ABORT:
	LXI SP,STACK
	PUSH D
	LXI H, 0	;LD HL, 0 ; INIT
	LXI D, MODE
	MOV M, H
	LXI IY, NEXT
	LXI IX, RETURN
	LXI HL,8080h
	LD (LBEND), HL
	LD BC, OUTER
	JP NEXT

INLINE:	DW $+2
	PUSH BC
STARIN:	CALL CRLF	; BIOS output cr / lf
	LD HL, LBADD
	;LD (LBP), HL
	LD B, LENGTH
CLEAR:	LD (HL), 20
	INC HL
	DJNZ CLEAR
ZERO:	LD L,0
INKEY:	CALL KEY	; BIOS read a key
	CP 08h ; line delete?
	JR NZ, TSTBS  ; test backspace
	CALL ECHO

TSTBS NOP

OUTER:
	JP TYPE
	JP INLINE


	JP NEXT


TYPE: JP NEXT


; Inner Interpreter
SEMI:	DW $+2
	LD C, (IX + 0)
	INC IX
	LD B, (IX + 0)
	INC IX
NEXT:	LD A, (BC)
	LD L, A
	INC BC
	LD A, (BC)
	LD H, A
	INC BC
RUN:	LD E, (HL)
	INC HL
	LD D, (HL)
	INC HL
	EX DE, HL
	JP (HL)

COLON:
	; PSH I -> RS
	LXI B, RS ; address of register RS into HL
	DCR B
	LXI D, I  ;
	LDAX D
	STAX B
	DCR B
	INR D
	LDAX D
	STAX B
	; SAVE RS BACK TO MEMORY
	LXI D, RS
	MOV A, B
	STAX D
	INR D
	MOV A, C
	STAX D
	;
	;DEC IX
	;LD (IX + 0), B
	;DEC IX
	;LD (IX + 0), C
	; WA -> I
	MOV C,E
	MOV B,D
	; JMP NEXT
	JP (IY)

; EXECUTE word
	DB 7, 'E','X','E'
	DB 0,0	; link address to next word.
EXECUTE: DW $+2
	POP HL
	JR RUN


CRLF:	LD A, 0Dh
	PUSH AF
	CALL ECHO
	RET

ECHO: POP AF
 	OUT (01), A
	RET

KEY:
	IN A, (00H)
	AND FFH
	JR Z, INKEY
	PUSH AF
	RET


; Virtual Registers
I	DW 0
WA	DW 0
RS	DW 0


RSTMSG DB 'R', 'E', 'S', 'E', 'T'
SRTMSG DB 'H','e','l','l','o', ' ', 'I', ' ', 'a', 'm',' ', 'a', ' ', 'T', 'I','L'
BASE	DB 0
MODE DB 0
STATE DB 0
LBEND DW 0
LBADD	DW 0,0,0,0,0,0,0
LENGTH EQU 80

LPB DW 0,0,0,0,0,0

STACK EQU FC00h	 ; Data Stack Pointer
RETURN EQU FA00h;	Return Stack
