; Allan Cravid Fernandes 
; date - 21-10-2020

;Escreva um programa em assembly P4 que dadas três variáveis X, Y e Z em memória, 
;correspondentes aos comprimentos dos lados de um triângulo,
;calcule o respetivo perímetro, colocando o resultado em R1. Simule o programa. 

ORIG            0000h


X               WORD    10
Y               WORD    10
Z               WORD    10 

                MVI     R2,X
                LOAD    R4,M[R2]
                
                MVI     R2,Y
                LOAD    R5,M[R2]
                
                MVI     R3,Z
                LOAD    R1,M[R3]
                
                ADD     R1,R1,R5 ; R1 = Z+Y
                ADD     R1,R1,R4; R1 = Z+Y+X

Fim:            BR      Fim
