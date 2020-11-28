
; zona I, constantes

; I/O terminal
TERM_READ       EQU     FFFFh                ;endereco do porto de leitura   <-- read only
TERM_WRITE      EQU     FFFEh                ;endereco do porto de escrita   <-- write only
TERM_STATE      EQU     FFFDh                ;endereco do porto de estado    <-- read only
TERM_CURSOR     EQU     FFFCh                ;endereco do porto do cursor    <-- write only
TERM_COLOR      EQU     FFFBh                ;endereco do porto de cor       <-- write only




                
STACKBASE       EQU     8000h

INT_MASK_VALUE  EQU     FFFFh
INT_MASK        EQU     FFFAh

; temporizador 
TIMER_CONTROL   EQU     FFF7h
TIMER_VALUE     EQU     FFF6h

; Dino
dino_0          EQU     '~'
dino_1          EQU     '-'
dino_2          EQU     '-'
dino_3          EQU     '('
dino_4          EQU     ')'
dino_5          EQU     '/'


pos             EQU     2Ch		;(23a linha, 78a coluna(23,78))

FIM_TEXTO       EQU     '@'



                ORIG    4000h
                
WelcomeString   STR     'Welcome to Dino (P4) , W E   A R E   P L E A S E D   T O    H A V E   Y O U',FIM_TEXTO   
StartGame       STR     'Press KEY0 to start a new game ! ! !',FIM_TEXTO
GameOver        STR     '"G A M E   O V E R"',FIM_TEXTO
PlayAgain       STR     'U L O S T,  want to play again,press KEY0 to start a new game',FIM_TEXTO


                ORIG    0000h
                
                JMP     main
                
;-------------------------------------------------------------------------------
; rotinas associadas a escrita no terminal

;--------------------------------------------------------------------------------
; escreve_terminal: argumentos <-- nª 2,(str,int)                               | 
                        ;(cadeia de carateres,posicao a ser escrita,base <-- h) | 
                        ;efeito <-- escreve a cadeia de caracteres              |
                        ; a partir da posicao fornecida                         |

escreve_terminal:
                DEC     R6
                STOR    M[R6],R7
                DEC     R6
                STOR    M[R6],R5
                DEC     R6
                STOR    M[R6],R4
                MVI     R5,TERM_WRITE
                MVI     R4,TERM_CURSOR
                MVI     R2,pos
                STOR    M[R4],R2
.loop:          LOAD    R2,M[R1]
                CMP     R2,R3
                BR.Z    restore
                STOR    M[R5],R2
                INC     R1
                BR      .loop

restore:        LOAD    R4,M[R6]
                INC     R6
                LOAD    R5,M[R6]
                INC     R6
                LOAD    R7,M[R6]
                INC     R6
                BR      retorna

retorna:        JMP     R7

;---------------------------------------------------------
; clear_screen: argumento <-- nª 1 (int)                 |
                        ; (inteiro base <-- h)           |
                        ; efeito <-- limpa o terminal -  |
                        
clear_screen:   
                DEC     R6
                STOR    M[R6],R7
                DEC     R6
                STOR    M[R6],R5
                DEC     R6
                STOR    M[R6],R4
                MVI     R4,FFFFh
                MVI     R5,TERM_CURSOR
                STOR    M[R5],R4
                BR      restore
                
main:           
                MVI     R6,STACKBASE
                MVI     R1,GameOver
                MVI     R3,FIM_TEXTO
                JAL     escreve_terminal
                NOP
                JAL     clear_screen
                
end:            BR      end
