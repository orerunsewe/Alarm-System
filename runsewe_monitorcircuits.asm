; Sample Code for motion detection and alarm 
#include "p16f877.inc"

; CONFIG
; __config 0xFFFB
 __CONFIG _FOSC_EXTRC & _WDTE_OFF & _PWRTE_OFF & _CP_OFF & _BOREN_ON & _LVP_ON & _CPD_OFF & _WRT_ON
    
	    LIST P = 16F877	    ; target PIC
	    
STATUS	    EQU	    0x03	    ; Declare STATUS SFR - Bank0 
PORTB	    EQU	    0x06	    ; Declare PORTB SFR  - Bank0 
TRISB	    EQU	    0x86	    ; Seclare TRISB SFR  - Bank1 
PORTD	    EQU	    0x08	    ; Declare PORTD SFR  - Bank0 
TRISD	    EQU	    0x88	    ; Declare TRISD SFR  - Bank1 
	    
P0	    EQU	    0x05
P1	    EQU	    0x06
PIR	    EQU	    0x01
BUZ	    EQU	    0x02
	    
	    CBLOCK	    0x20	    ; GPR
			    TEMP	    ; declaration of GPR in Bank0
			    Kount100us
			    Kount25ms
			    Kount1s
	    ENDC 
	    
	    ORG	    0x0000 
	    GOTO    START
	    
	    
	    NOP
	    NOP
	    NOP
	    NOP
	    
START
	    bcf	    STATUS, P1	    ; Select Bank0 or 1
	    bsf	    STATUS, P0	    ; Select Bank1
	    bsf	    TRISB, PIR	    ; Set TRISB<1>='1' so PORTB<1> is an INPUT
	    bcf	    TRISD, BUZ	    ; Set TRISD<2>='0' so PORTD<2> is an OUTPUT
	    bcf	    STATUS, P0	    ; Select Bank0 
	    
AGAIN	    bcf	    PORTD, BUZ	    ; Turn PORTD<2> off (alarm off) 
	    btfss   PORTB, PIR	    ; Does PORTB<1>='0'? YES => (skip next) 
	    goto    AGAIN	    ; => No (Keep monitoring) 
	    bsf	    PORTD, BUZ	    ; => Yes (turn on alarm) 
	    call    Delay1s	    ; Delay for one second 
	    goto    AGAIN	    ; keep monitoring
	    
Delay1s	
	    movlw	    0x28	    ; Load d'40 into literal 
	    movwf	    Kount1s
R1s	    
	    call	    Delay25ms	    ; call 25ms delay 40 times 
	    decfsz	    Kount1s
	    goto	    R1s
					    ; skip 
	    return 
	    
	    
Delay25ms
	    movlw	    0xFA	   ; Load d'250 in Literal 
	    movwf	    Kount25ms
R25ms	    
	    call	    Delay100us	   ; Call 100us delay 250 times 
	    decfsz	    Kount25ms
	    goto	    R25ms 
					    ; skip
	    return 
	   
Delay100us
	    movlw	    0xA5	    ; Load d'165 into literal
	    movwf	    Kount100us
R100us	   
	    decfsz	    Kount100us
	    goto	    R100us
					    ; skip
	    return 
	   
ENDING
	    END

	     