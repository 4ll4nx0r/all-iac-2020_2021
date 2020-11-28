; I/O addresses (ff00h to ffffh)
TERM_READ       EQU     FFFFh
TERM_WRITE      EQU     FFFEh
TERM_STATE      EQU     FFFDh
TERM_CURSOR     EQU     FFFCh
TERM_COLOR      EQU     FFFBh
INT_MASK        EQU     FFFAh
SWITCHES        EQU     FFF9h
LEDS            EQU     FFF8h
TIMER_CONTROL   EQU     FFF7h
TIMER_VALUE     EQU     FFF6h
LCD_WRITE       EQU     FFF5h
LCD_CONTROL     EQU     FFF4h
DISP7SEG_3      EQU     FFF3h
DISP7SEG_2      EQU     FFF2h
DISP7SEG_1      EQU     FFF1h
DISP7SEG_0      EQU     FFF0h
DISP7SEG_5      EQU     FFEFh
DISP7SEG_4      EQU     FFEEh
GSENSOR_Z       EQU     FFEDh
GSENSOR_Y       EQU     FFECh
GSENSOR_X       EQU     FFEBh

; Other constants
STR_END         EQU     0000h
SP_ADDRESS      EQU     fdffh
FIM_STRING      EQU     '@'
INT_MASK_VALUE  EQU     FFFFh

;============== Data Region (starting at address 8000h) ========================

                ORIG    8000h
TerminalStr     STR     0,1,000h,0,2,9a00h,'████████████████████████████████████████████████████████████████████████████████',FIM_STRING
SNAKE           STR     00FFh,'█'
CAMINHO         STR     0,0  ;  POSICAO , DIRECAO
;===============Terminal========================================================

;============== Code Region (starting at address 0000h) ========================

                ORIG    0000h
                JMP     Main                    ; jump to main

;===============Terminal========================================================
TERMINAL:       
                
                MVI     R1, TERM_WRITE
                MVI     R2, TERM_CURSOR
                MVI     R3, TERM_COLOR
                MVI     R4, TerminalStr

TerminalLoop:
                LOAD    R5, M[R4]
                INC     R4
                MVI     R2,FIM_STRING
                CMP     R5,R2
                BR.Z    .Control
                STOR    M[R1], R5
                BR      TerminalLoop

.Control:
                LOAD    R5, M[R4]
                INC     R4
                DEC     R5
                BR.Z    .Position
                DEC     R5
                BR.Z    .Color
                BR      .End

.Position:
                LOAD    R5, M[R4]
                INC     R4
                STOR    M[R2], R5
                BR      TerminalLoop

.Color:
                LOAD    R5, M[R4]
                INC     R4
                STOR    M[R3], R5
                BR      TerminalLoop

.End:
                JMP     R7


;-------------- Routines -------------------------------------------------------

BUTTON:         DEC     R6
                STOR    M[R6],R7
                
                MVI     R1, TERM_READ
                LOAD    R1, M[R1]
                
                MVI     R2,24
                CMP     R1,R2
                JAL.Z   UP
                
                MVI     R2,25
                CMP     R1,R2
                JAL.Z   DOWN
                
                MVI     R2,26
                CMP     R1,R2
                JAL.Z   RIGHT
                
                MVI     R2,27
                CMP     R1,R2
                JAL.Z   LEFT
                
                LOAD    R7,M[R6]
                INC     R6
                
                JMP     R7
                
DOWN:           MVI     R1,CAMINHO
                INC     R1
                MVI     R2,0100h
                STOR    M[R1],R2
                JMP     R7
                
UP:             MVI     R1,CAMINHO
                INC     R1
                MVI     R2,0100h
                NEG     R2
                STOR    M[R1],R2
                JMP     R7
                
LEFT:           MVI     R1,CAMINHO
                INC     R1
                MVI     R2,0001h
                NEG     R2
                STOR    M[R1],R2
                JMP     R7
      
RIGHT:          MVI     R1,CAMINHO
                INC     R1
                MVI     R2,0001h
                STOR    M[R1],R2
                JMP     R7

;-------------- Main Program ---------------------------------------------------

Main:
                MVI     R6, SP_ADDRESS          ; set stack pointer
                
                JAL     TERMINAL
                
Stop:           BR      Stop

=
