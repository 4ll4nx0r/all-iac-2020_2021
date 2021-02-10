
;--------------------------------------------------------------------------------
; Definicao de Constantes

dimensao        EQU     10
STACKBASE       EQU     8000h
last            EQU     4009h        ;endereco da ultima posicao da tabela

;--------------------------------------------------------------------------------
  
;--------------------------------------------------------------------------------
; Definicao de Variaveis 

                ORIG    4000h ;a partir do endereco 4000h
terreno         STR     '1234567890'

;--------------------------------------------------------------------------------

                ORIG    0000h 
                
                MVI     R1,terreno                ;copia-se para R1,o primeiro
                ;endereco do terreno
                
                MVI     R2,dimensao               ;copia-se para R2,a dimensao
                ;do terreno
                
                MOV     R4,R1        ;contem o endereco da primeira 
                ;posicao em memoria
                MOV     R5,R2        ; contem o total das posicoes 
                ;no terreno
                MVI     R6,STACKBASE ; inicializacao da pilha 
                DEC     R6
                STOR    M[R6],R4  ;salvaguarda o primeiro endereco do terreno
                DEC     R6
                STOR    M[R6],R5  ;salvaguarda o numero de posicoes do terreno
                JAL     atualizajogo
                MOV     R1,R4
end:            BR      end


atualizajogo:   
                DEC     R6
                STOR    M[R6],R7 ; salvaguarda o endereco de retorno
.loop:          CMP     R5,R0    ; R2 == 0 ? verifica se já se percorreu todas 
                ;as      posicoes
                BR.Z    .retorna
                INC     R4       ;passa-se para o endereço seguinte
                LOAD    R4,M[R4]
                STOR    M[R1],R4
                INC     R1
                MOV     R4,R1
                DEC     R5
                BR      .loop
                
                
                
                
                
.retorna:       MVI     R2,last
                MVI     R3,'3'
                STOR    M[R2],R3
                JMP     R7

                
; pequeno exemplo para uma tabela de 10 posicoes 
; os valores na posicao imediatamente acima passa para a posicao imediatamente
; inferior 

; tenho de melhor comentar o codigo 
; chamar a funcao para a ultima posicao
; TEST

;------------------------------------------------------------------------------
