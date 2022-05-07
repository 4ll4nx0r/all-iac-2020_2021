; Allan Cravid Fernandes
; date - 29-10-2020


; Escreva o codigo Assembly que calcula R1 x 2^R2 (isto e calcula R1 x 2 x ... x 2), 
;atraves de um ciclo que usa a instrucao ADD, e nao usa SHL nem SHLA. 

                ORIG    0000h 
                
                MVI     R1,4
                MVI     R2,9   
;------------------------------------------------------------------

                MVI     R4,2    ; num = 2
                MVI     R5,2    ; acumulador = 2
                MOV     R3,R0
                BR      Loop
                
;------------------------------------------------------------------                      
                ;parte 1 <--- 2^R2 
                
Loop:           DEC     R2
.Loop:          CMP     R2,R0
                BR.Z    parte_2
                ADD     R5,R5,R4
                MOV     R4,R5
                DEC     R2
                JMP     .Loop
                
                ; parte 2<--- R1*2^R2 
                
parte_2:        CMP     R1,R0
                BR.Z    Fim
                ADD     R3,R3,R5
                DEC     R1
                BR      parte_2
                
                
Fim:            BR      Fim

