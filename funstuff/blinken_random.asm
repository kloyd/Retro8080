	            ;  Altair blinken lights with memory array of light patterns.
	            ;  Fill up the memory starting at DATA with patterns you like.
	            ;  Or just generate bunch of random bytes.
	            ;  Whatever you want, put it at DATA and terminate the list with 0.

	ORG 0h
INIT	LXI H,DATA   ;  HL points to blinken data
	SHLD SAVE_HL

GETD	LHLD SAVE_HL   ;  restore HL
	MOV A,M     ;  get data @ HL
	CPI EOF     ;  End of the data list?
	JZ INIT     ;  Yes, reset HL pointer.
	MOV D,A     ;  No, put in D register for the display pattern.
	INR L       ;  HL++
	SHLD SAVE_HL   ;  Save data


INPDEL	LXI H,0     ;  Init HL to zero before starting the delay loop
	IN 0ffh
	CPI 0ffh    ;  All Sense switches on is a HALT.
	JZ DONE
	ADI 1
	MOV C,A     ;  sense switches to B
	MVI B,0     ;  BC = <sense>00

BLINK	LDAX D
	LDAX D
	LDAX D
	LDAX D
	DAD B
	JNC BLINK
	            ;  Done with this loop go get the next D
	JMP GETD

	            ;  Halt if FF on sense switches. Some way to drop out.
DONE	HLT

	            ;  Somewhere to save HL, since it will get clobbered by the delay routine.
SAVE_HL	DW 0
	            ;  Put your pattern list here... this is just jiggy wiggy back forth here.

DATA	DW 13A6h,61AEh,B83Eh,E260h
	DW 56EFh,6684h,F657h,6623h
	DW 637Eh,D2BFh,1E17h,092Eh



	DB EOF


EOF	EQU 042     ;  end of data
	END
