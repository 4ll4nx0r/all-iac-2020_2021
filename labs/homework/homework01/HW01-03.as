; Allan Cravid Fernandes 
; date - 14/10/2020


ORIG            4000h

A               WORD    1
B               WORD    5
C               WORD    7 

ORIG            0000h   

                MVI     R1,A 
                LOAD    R2,M[R1] 
                
                ADD     R2,R2,R2 ; R2 = R2 + R2 = 1+1 = 2 = 2A
                
                MVI     R1,B
                LOAD    R3,M[R1] ;R3 = 5
                
                ADD     R2,R2,R3 ; R2 = 2A + B
                ADD     R3,R3,R3 ; R3 = R3 +R3 = 2R3 
                ADD     R2,R2,R3 ; R2 = 2A +B+2B = 2A +3B 
                
                MVI     R1,C 
                STOR    M[R1],R2
                
FIM:            BR      FIM