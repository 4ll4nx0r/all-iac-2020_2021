; Allan Cravid Fernandes
; date - 04-11-2020

;def fibonacci(n):
;if n <= 1:
; return n
;return fibonacci(n – 1) + fibonacci(n – 2)

STACKBASE       EQU     8000h
n               EQU     10

                ORIG    4000h
result          WORD    0               ;pretende-se guardar o resultado em memoria
                
                ORIG    0000h
                
                MVI     R1,n            ;R1 = n corresponde ao argumento da funcao
                MVI     R6,STACKBASE    ;inicialização da pilha 
                JAL     fibonacci
                MVI     R4,result
                STOR    M[R4],R3

end:            BR      end

fibonacci:      CMP     R1,R0           ; R1 == 0?
                BR.Z    .base
                MVI     R2,1
                CMP     R1,R2
                BR.Z    .base
                BR      .recursao
                
  
  
  
.base:          MOV     R3,R1
                JMP     R7
                
                
.recursao:      
                DEC     R6
                STOR    M[R6],R7        ;salvaguarda o endereco de retorno
                DEC     R1              ;= n-1
                MOV     R4,R1
                DEC     R6
                STOR    M[R6],R4
                JAL     fibonacci       ;calcula fib(n-1)
                LOAD    R4,M[R6]        ;= n-1 POP
                INC     R6
                LOAD    R7,M[R6]        ;POP endereço de retorno
                INC     R6
                DEC     R4              ; = n-2
                DEC     R6
                STOR    M[R6],R3        ;guarda fib(n-1)
                MOV     R1,R4
                DEC     R6
                STOR    M[R6],R7
                JAL     fibonacci       ;calcula fib(n-2)
                LOAD    R7,M[R6]
                INC     R6
                LOAD    R4,M[R6]        ;pop(fib(n-1)
                INC     R6
                ADD     R3,R3,R4
                JMP     R7
                