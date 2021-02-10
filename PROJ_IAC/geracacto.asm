STACKBASE       EQU     8000h
                ORIG    0000h
                
                MVI     R1, 16 ; Parametro 1 - Valor Maximo (potencia de 2)
                MVI     R6, STACKBASE ; Inicializacao da pilha
                JAL     geracacto ; Chama funcao geracacto
FIM:            BR      FIM       ; loop para terminar execucao

geracacto:      DEC     R6         ;
                STOR    M[R6], R4  ; Segundo a convecao do P4 e necessario
                DEC     R6         ; manter os valores de R4 e R5 depois do
                STOR    M[R6], R5  ; fim da funcao
                
                CMP     R2, R0     ; Devido a necessidade de um valor inicial para comecar a gerar valores
                BR.Z    nozero     ; aleatorios usou-se o R2 para tal e garantiu-se que este nao era nulo 
                
inicio:         MVI     R4, 1      ; Seguindo o pseudo codigo em Python
                AND     R5, R2, R4 ; comecou-se por fazer a conjuncao logica
                BR.NZ   gotoxor    ; do valor inicial com 1                
                SHR     R2
                
gotocheck:      CMP     R2, R0      ; Avalia se o numero e superior a 62258
                BR.NN   S           ; visto ser superior a 95/100 dos numeros
                MVI     R5, 62258   ; inteiros positivos disponiveis com 16 bits
                CMP     R2, R5      ; 
                BR.P    End         ; 
S:              MVI     R3, 0       ; Se nao for entao o valor de retorno e 0
                BR      End2        ; R3 = 0
                
gotoxor:        SHR     R2         ; Se a conjuncao logica de R2 com 1 for 1
                MVI     R5, B400h  ; entao executamos, seguindo o pseudo codigo
                XOR     R2, R2, R5 ; XOR(R2, B4ooh)
                BR      gotocheck  ;
                
End:            MOV     R4, R1     ; R4 = R1 (sendo R1 a altura maxima)
                DEC     R4         ; R4 - 1 = R1 - 1
                AND     R3, R2, R4 ; R3 = R2 & (R1 - 1)
                INC     R3         ; R3 = (R2 & (R1 - 1)) + 1
                
End2:           LOAD    R5, M[R6]  ;
                INC     R6         ; Restora os valores de R4 e R5
                LOAD    R4, M[R6]  ;
                INC     R6         ;
                
                JMP     R7         ; Volta para o corpo inicial do programa

nozero:         INC     R2     ; Garante que o valor inicial R2 nao 
                BR      inicio ; seja nulo
                
                
; Exemplo de teste: Fazer um loop da funcao e guardar em memoria os valores
; de retorno.
