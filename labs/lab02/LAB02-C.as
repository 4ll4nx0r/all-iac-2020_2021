; Allan Cravid Fernandes
; date - 21-10-2020

;Escreva um programa em assembly P4 que calcule: x = 30 – m + (2n + 10). 
;Onde x, m e n são variáveis em memória. Comece por ler as variáveis em memória, 
;depois faça as contas em registos e no final guarde o resultado na
;memória. Simule o programa e chame o docente para mostrar o resultado. 

ORIG            4000h   

x               WORD    2
m               WORD    3
n               WORD    4
;-------------------------------------------------------------------------------
ORIG            0000h   

Inicio:         MVI     R2,10
                MVI     R1,n
                LOAD    R3,M[R1]
                
                ADD     R3,R3,R3
                ADD     R3,R3,R2 ; R3 = R3 + R2 = 2n + 10
;------------------------------------------------------------------------------

                MVI     R2,30
                ADD     R3,R3,R2
                MVI     R1,m
                LOAD    R2,M[R1]
                SUB     R2,R3,R2
                
                MVI     R1,x
                STOR    M[R1],R2
Fim:            BR      Fim 
;-------------------------------------------------------------------------------               
                



                
                
                
                
