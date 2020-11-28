
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



ORIG            8000h   


POS_DINO        WORD    2002H


                ORIG    0000h
                
                
                MVI     R6,STACKBASE
                MVI     R1,POS_DINO
                
                JAL     desenha_dino
                
FIM:            BR      FIM

desenha_dino:   

                ; save context 
                DEC     R6
                STOR    M[R6],R7
                DEC     R6
                STOR    M[R6],R4
                DEC     R6
                STOR    M[R6],R5
                LOAD    R1,M[R1]             ;coloca em R1 a posicao para desenhar a perna do dino
                MVI     R4,TERM_WRITE
                MVI     R5,TERM_CURSOR
                MVI     R3,'('
                STOR    M[R5],R1
                STOR    M[R4],R3
                MVI     R1,POS_DINO
                MVI     R2,0100h
                LOAD    R3,M[R1]
                SUB     R2,R3,R2                 ; posicao dino , ; sobe uma linha
                STOR    M[R1],R2                 ;atualiza a posicao do dino                                    
                STOR    M[R5],R2
                MVI     R3,'$'
                STOR    M[R4],R3
                LOAD    R1,M[R1]
                MVI     R2,0100h
                MOV     R3,R1
                SUB     R2,R3,R2
                STOR    M[R1],R2                ;posicao dino 
                STOR    M[R5],R2
                MVI     R2,'^'
                STOR    M[R4],R2
                                
                JMP     R7
                
                
