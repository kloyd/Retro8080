	ORG $0
	            ;  Testing virtual 16-bit registers held in memory.
	            ;  8080 cpu is limited to 3 general purpose 16 bit registers
	            ;  The Threaded Interpetive Language (TIL) requires the following virtual registers.
	            ;  IR Instruction Register - Address of next instruction in threaded list.
	            ;  WA Word Address Register - word address of current keyword
	            ;  CA Code Address Register
	            ;  RS Return Stack Register
	            ;  SP Stack Pointer == 8080 SP
	            ;  PC Program Counter == 8080 PC

	            ;  Basic definition of COLON routine
	            ;  PSH IR -> RS
	            ;  WA -> IR
	            ;  JMP NEXT
COLON
	            ;  **********
	            ;  PSH I -> RS
	            ;  **********
	            ;  get RS address to HL, then get contents of RS into DE, then copy DE to HL
	LHLD RS     ;  Load HL Direct (contents of memory RS go to HL)
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

	            ;  **********
	            ;  WA -> IR
	            ;  **********
	LXI D,WA    ;  General form for Rx -> Ry Get Address Rx [WA]
	LXI H,IR    ;  Get address of Ry [IR]
	LDAX D      ;  A <- Rx.L
	MOV M,A     ;  (Ry) <- A
	INR L       ;  Rx++
	INR E       ;  Ry++
	LDAX D      ;  A <- Rx.L
	MOV M,A     ;  (Ry) <- A

	            ;  **********
	            ;  JMP NEXT
	            ;  **********
	LHLD NEXT   ;  HL <- next
	PCHL        ;  set PC = HL (effective computed jump)

	            ;  **********
	            ;  (TODO) Write & Test POP RS -> I
	            ;  **********

	HLT

	            ;  Virtual Registers
IR	DW $140     ;  arbitrary starting values for testing. will get better numbers when building TIL.
WA	DW $1AA
CA	DW 0
RS	DW $A0      ;  Return Stack Pointer at 00A0 for ease of checking in first memory page.
NEXT	DW $C0      ;  Next instruction

	ORG $A0
STACK	DB 1,2,3,4,5,6
	ORG $C0
	MVI A,$FF
	HLT

