; Allan Cravid Fernandes 
; date - 21-10-2020

x               EQU     3

ORIG            4000h   

A               WORD    2
B               WORD    4
C               WORD    7 


ORIG            0000h   

                MVI     R2,5
                MVI     R3,x 
                SUB     R5,R2,R3 ; R5 = R2-R3 = 5-X
                
                MVI     R1,B 
                LOAD    R2,M[R1]
                
                ADD     R2,R2,R2 ; R2 = R2+R2 = 2R2 = 2B
                
                MVI     R1,A
                LOAD    R3,M[R1]; R3 = 2 
                
                ADD     R5,R5,R2 ; R5 = -x + 5 + 2B 
                
                SUB     R5,R5,R3  ;  R5 = -x + 5 + 2B -A
                
                ADD     R3,R3,R3  ; R3 = 2A
                
                SUB     R5,R5,R3 ; R5 = -x + 5 + 2B -A -2A 
                
                
                MVI     R1,C 
                STOR    M[R1],R5 
FIM:            BR      FIM

                
                
                