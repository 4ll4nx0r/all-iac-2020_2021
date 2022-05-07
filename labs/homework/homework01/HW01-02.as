;Escreva um programa que modificando apenas R1 e R2
;calcula R1 = 4 x (R1 + 2) + 2 x (R2 - 1) + X, em que X é uma constantes
;Deve também escrever o código que define a constante X.

X               EQU     10
ORIG            0000h    

                MVI     R1,2
                MVI     R2,4 
                
                INC     R1
                INC     R1 ; R1 = R1 + 2
                DEC     R2 ; R2 = R2-1 
                
                ADD     R2,R2,R2 ;R2 = R2 +R2 = 2R2 = 2(R2-1)
                ADD     R2,R2,R1 ;R2 = 2(R2-1) + R1 =  2(R2-1) + (R1 + 2)
                ADD     R2,R2,R1 ;R2 = 2(R2-1) + R1 +R1 = 2(R2-1) + 2(R1 + 2)
                ADD     R2,R2,R1 ;R2 = 2(R2-1) + R1 +R1 +R1  = 2(R2-1) + 3(R1 + 2)
                ADD     R2,R2,R1 ;R2 = 2(R2-1) + R1+R1+R1+R1  = 2(R2-1) + 4(R1 + 2)
                
                MVI     R1,X
                ADD     R1,R2,R1 ; R1 = 2(R2-1) + 4(R1 + 2) + X
                
                