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
	            ;  PSH I -> RS
	            ;  get RS address to HL, then get contents of RS into DE, then copy DE to HL
	LXI H,RS    ;  address of register RS into HL
	MOV E,M     ;  low order to E (HL) -> E
	DCR L       ;  bump HL for hi order
	MOV D,M     ;  hi order to D (HL) -> D
	MOV H,D     ;  Set memory pointer HL to DE (RS)
	MOV L,E     ;  low byte
	            ;  Now DE == RS pointer, next grab 16 bit IR register from memory and push to RS stack.
	LXI D,IR    ;  Address of IR to DE
	LDAX D      ;  A <- (DE)
	DCR L       ;  RS--
	MOV M,A     ;  (HL) < IR.L
	INR E       ;  DE++
	LDAX D      ;  A <-(DE+1)
	DCR L       ;  RS--
	MOV M,A     ;  (HL) <- IR.H
	            ;  save contents of HL to RS memory location
	MOV D,H     ;  HL = RS, SAVE HL to DE, then set HL to RS memory location.
	MOV E,L
	LXI H,RS
	MOV M,E     ;  write E to RS.0
	DCR L
	MOV M,D     ;  write D to RS.1

	            ;  WA -> I

	            ;  JMP NEXT
	            ;  End for now
	HLT

	            ;  Virtual Registers
IR	DW $140 ;arbitrary starting values for testing. will get better numbers when building TIL.
WA	DW 0
CA	DW 0
RS	DW $A0	; Return Stack Pointer at 00A0 for ease of checking in first memory page.

	ORG $A0
STACK	DB 1,2,3,4,5,6
