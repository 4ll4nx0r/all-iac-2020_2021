; Allan Cravid Fernandes
; date - 04-11-2020

; def cipher(string,val):
; res = ''
; for i in range(len(string)):
;        res += val (xor) string[i]
; return res 

val             EQU     2
STACKBASE       EQU     8000h
ORIG            0000h

STRING          STR     'ABC',0
STRING2         STR    'C@A',0
res             TAB     4

                ORIG    0000h
                
                MVI     R1,STRING2      ;copia para R1 o endereço da 1 posicao 
                ; de string 
                MVI     R2,val
                MVI     R3,res          ;acumulador
                MVI     R6,STACKBASE    ;inicialização da pilha
                DEC     R6
                STOR    M[R6],R3
                JAL     cipher 
                MOV     R3,R4
                
end:            BR      end

cipher:         LOAD    R3,M[R6]        ;copia o conteudo em memoria para R3
                INC     R6
                DEC     R6
                STOR    M[R6],R4
                DEC     R6
                STOR    M[R6],R5
                MOV     R4,R3           ; = '', inicialmente
.loop:          LOAD    R5,M[R1]        ; = A,
                CMP     R5,R0           ; R5 == R0 ? 
                BR.Z    .retorna
                XOR     R5,R2,R5 
                STOR    M[R4],R5
                INC     R1
                INC     R4
                DEC     R6
                BR      .loop 
                
.retorna:       
                LOAD    R5,M[R6]
                INC     R6
                LOAD    R4,M[R6]
                INC     R6
                MOV     R4,R0
                JMP     R7
                