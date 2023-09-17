	ORG $0
COLON
	            ;  PSH I -> RS - concept RS -> HL
	            ;  RS-- IR.0 -> A, (RS) <- A, RS--, (RS) <- A
	LXI H,RS    ;  address of register RS into HL
	MOV E,M     ;  low order to E (HL) -> E
	DCR L     ;  bump HL for hi order
	MOV D,M     ;  hi order to D (HL) -> D
	            ;
	MOV H,D     ;  Set memory pointer HL to DE (RS)
	MOV L,E     ;  low byte

	LXI D,IR    ;  Address of IR to DE
	LDAX D      ;  A <- (DE)
	DCR L       ;  RS--
	MOV M,A     ;  (HL) < I.lo
	INR E       ;  DE++
	LDAX D      ;  A <-(DE+1)
	DCR L       ;  RS--
	MOV M,A     ;  (HL) <- I.hi
	            ;  save contents of HL to RS memory location
	MOV D,H     ;  HL = RS, SAVE HL to DE, then set HL to RS memory location.
	MOV E,L
	LXI H,RS
	MOV M,E     ;  write E to RS.0
	DCR L
	MOV M,D     ;  write D to RS.1

	            ;  End for now
	HLT

	            ;  Virtual Registers
IR	DW $140
WA	DW 0
RS	DW $A0

	ORG $A0
STACK	DB 1,2,3,4,5,6
