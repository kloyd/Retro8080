	ORG $0
	            ;  **********
	            ;  Inner Interpreter of TIL
	            ;  **********

	            ;  ********************
	            ;  Initialization - more to come, but first, get the address of NEXT
	            ;  ********************
	            ;  See default value below.

SEMI:	DW $+2
	            ;  POP RS -> IR
	LHLD RS     ;  Reverse of PSH. increment RS, grab byte, store at DE (location of IR)
	LXI D,IR
	INR L       ;  RS++
	MOV A,M
	STAX D
	DCR E       ;  IR--
	INR L       ;  RS++
	MOV A,M     ;  high byte
	STAX D
	SHLD RS     ;  save HL to RS (updated value)

NEXT:	            ;  @IR -> WA
	LHLD IR
	LXI D,WA
	MOV A,M
	STAX D
	INR L
	INR E
	MOV A,M
	STAX D
	INR L       ;  IR = IR + 2 (INR twice)
	INR L
	SHLD IR     ;  save IR

RUN:
	LHLD WA     ;  @WA -> CA
	LXI D,CA
	MOV A,M
	STAX D
	INR L
	INR E
	MOV A,M
	STAX D
	INR L       ;  WA = WA + 2
	INR L
	SHLD WA
	            ;  CA -> PC

	LXI D,CA
	LDAX D
	MOV H,A
	INR E
	MOV L,A
	PCHL        ;  Causes jump to contents of CA

COLON:
	            ;  PSH I -> RS
	LHLD RS     ;  get RS address to HL, then get contents of RS into DE, then copy DE to HL
	LXI D,IR    ;  Address of IR to DE
	LDAX D      ;  A <- (DE)
	DCR L       ;  RS--
	MOV M,A     ;  (HL) < IR.L
	INR E       ;  DE++
	LDAX D      ;  A <-(DE+1)
	DCR L       ;  RS--
	MOV M,A     ;  (HL) <- IR.H
	            ;  save contents of HL to RS memory location
	SHLD RS     ;  store HL @ RS

	            ;  WA -> IR
	LXI D,WA    ;  General form for Rx -> Ry Get Address Rx [WA]
	LXI H,IR    ;  Get address of Ry [IR]
	LDAX D      ;  A <- Rx.L
	MOV M,A     ;  (Ry) <- A
	INR L       ;  Rx++
	INR E       ;  Ry++
	LDAX D      ;  A <- Rx.L
	MOV M,A     ;  (Ry) <- A

	            ;  JMP NEXT
	LHLD NXTR   ;  HL <- next
	PCHL        ;  set PC = HL (effective computed jump)

; EXECUTE word definition dictionary entry. 7EXE (length 7, first three chars EXE)

	DB 7,'E','X','E'
	DW 00	; Pointer to next Word Definition (filled when next word defined)
EXECUTE:
	DW $+2
	            POP H
	            JMP RUN


	            ;



PSEUDO:
	MvI A,$AA
	HLT

	            ;  Testing virtual 16-bit registers held in memory.
	            ;  8080 cpu is limited to 3 general purpose 16 bit registers
	            ;  The Threaded Interpetive Language (TIL) requires the following virtual registers.
	            ;  IR Instruction Register - Address of next instruction in threaded list.
	            ;  WA Word Address Register - word address of current keyword
	            ;  CA Code Address Register
	            ;  RS Return Stack Register
	            ;  SP Stack Pointer == 8080 SP
	            ;  PC Program Counter == 8080 PC
	            ;  Virtual Registers
IR	DW $140     ;  arbitrary starting values for testing. will get better numbers when building TIL.
WA	DW $1AA
CA	DW PSEUDO	; for testing... point to a 'pseudo' word.
RS	DW $A0      ;  Return Stack Pointer at 00A0 for ease of checking in first memory page.
NXTR	DW NEXT     ;  set NXTR (NeXT Register) to next.

	ORG $A0
STACK	DB 1,2,3,4,5,6
	ORG $C0
	MVI A,$FF
	HLT

