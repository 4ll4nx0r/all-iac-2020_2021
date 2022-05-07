; Allan Cravid Fernandes
; date - 18-11-2020 

;=================================================================
; CONSTANTS
;-----------------------------------------------------------------


TERM_READ EQU FFFFh                     ;read characters
TERM_WRITE EQU FFFEh	                ;write characters
TERM_STATUS EQU FFFDh	                ;status (0-no key pressed; 1-key pressed)
TERM_CURSOR EQU FFFCh	                ;position the cursor
TERM_COLOR EQU FFFBh	                ;change the colors


SP_INIT EQU 7000h	                    ;initial stack location

LEDS            EQU     FFF8h	        ;LEDS (one bit per led: 0 off/1 on)
;=================================================================
; MAIN: the starting point of your program
;-----------------------------------------------------------------
                ORIG    0
				                        ; initialize the stack pointer
MAIN:           MVI     R6,SP_INIT

				                        ; wait for a key to be pressed
                MVI     R4,TERM_STATUS
.LOOP:          LOAD    R1,M[R4]		; read the terminal status
                CMP     R1,R0
                JAL.NZ  PROCESS_CHAR	; call process_char when a key is pressed
                BR      .LOOP


;=================================================================
; PROCESS_CHAR: function that process characters on text window
;-----------------------------------------------------------------
PROCESS_CHAR:   ; SAVE CONTEXT
                DEC     R6
                STOR    M[R6],R7
                                        ;ECHO CHARACTER FROM TERMINAL
                MVI     R1,TERM_READ
                LOAD    R2,M[R1]
                MVI     R1,TERM_WRITE
                STOR    M[R1],R2
				; ----------------------
				; 
				; ----------------------
                
                
                
                                        ;se for minuscula acender os leds mais a direita
                MVI     R1,'z'
                CMP     R2,R1
                BR.P    .DESLIGA        ; if key>'z' go out
                MVI     R1,'a'
                CMP     R2,R1           ; if key<'a' go out
                BR.N    .M              ; 'a' = 96
                                        ; ... WRITE ON LEDS
                MVI     R3,LEDS
                MVI     R2,0001h
                STOR    M[R3],R2
                BR      .RETURN

                
.M:             MVI     R1,'Z'
                CMP     R2,R1
                BR.P    .DESLIGA        ;if key > 'Z' 
                MVI     R1,'A'
                CMP     R2,R1
                BR.N    .DESLIGA        ;if key < 'A'
                                        ;acender os leds mais a esquerda
                MVI     R2,0200h
                MVI     R3,LEDS
                STOR    M[R3],R2

.RETURN:        JMP     R7
                
.DESLIGA:       MOV     R2,R0           ;desligar os leds todos 
                MVI     R3,LEDS
                STOR    M[R3],R2
                BR      .RETURN

