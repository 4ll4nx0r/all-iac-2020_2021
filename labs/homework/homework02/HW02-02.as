: Allan Cravid Fernandes
; date - 29-10-2020

STACKBASE       EQU     8000h
NUM             EQU     3

                ORIG    4000h 

STRING_1        STR     'IAC',0

                ORIG    2000h
STRING_2        TAB     3

                ORIG    0000h
                
                MVI     R1,STRING_1 ;Endereço do 1ª caracter
                MVI     R2,STRING_2 ;Endereço da 1ª posicao da tabela,a zero
                MVI     R6,STACKBASE
                MVI     R5,NUM
                JAL     INVERTE
                
fim:            BR      fim
                             
INVERTE:        
                DEC     R6
                LOAD    R4,M[R1] ; guarda-se o conteudo associado ao endereço
                ;fornecido por R1,no registo R4
                STOR    M[R6],R4 ;guarda-se o 'I'
                INC     R1       ;endereço seguinte i++
                LOAD    R4,M[R1]
                DEC     R6
                STOR    M[R6],R4 ;guarda-se o 'A'
                INC     R1       ;endereço seguinte  i++
                LOAD    R4,M[R1]
                DEC     R6
                STOR    M[R6],R4 ;guarda-se o 'C'
                ; Pretende-se copiar os dados da pilha para uma outra posicao 
                ; de memória 
                BR      TRANSFERE          
                JMP     R7
                
TRANSFERE:      CMP     R5,R0
                BR.Z    SUCESSO
                LOAD    R4,M[R6]  ; R4 = 'C' 
                INC     R6
               ; INC     R2
                STOR    M[R2],R4
                INC     R2
                DEC     R5
                BR      TRANSFERE

SUCESSO:        NOP