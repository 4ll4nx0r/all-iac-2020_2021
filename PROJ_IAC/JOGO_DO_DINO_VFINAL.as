;------------------------------------------------------------------------------;
;                       PROJETO IAC - JOGO DINO                                ;
;------------------------------------------------------------------------------;

;                       Elaborado por: Allan Fernandes   n 97281
;                                      João Vieira       n 99250
;                                      grupo 3                          
        
;------------------------------------------------------------------------------;
;                       definicao de constantes                                                               
;                                                        
;                                |diretiva: EQU                                                                              
;------------------------------------------------------------------------------;

;- -------------------------------TERMINAL-------------------------------------;
TERM_READ       EQU     FFFFh                             
TERM_WRITE      EQU     FFFEh            ;porto de escrita no terminal    
TERM_STATE      EQU     FFFDh            ;porto que verifica se houve tecla premida    
TERM_CURSOR     EQU     FFFCh            ;porto relativo ao posicionamento do cursor 
TERM_COLOR      EQU     FFFBh            ;porto relativo a definicao de cores    
;------------------------------------------------------------------------------;

;-------------------------------INTERRUPCOES-----------------------------------;
INT_MASK        EQU     FFFAh            ;porto da mascara de interrupcoes
INT_MASK_VALUE  EQU     1000000000001001b; ;8009h ,mascara principal
;------------------------------------------------------------------------------;

;-------------------------------TEMPORIZADOR-----------------------------------;
TIMER_CONTROL   EQU     FFF7h            ;iniciar/parar ou ler estado
TIMER_VALUE     EQU     FFF6h            ;valor de contagem 
;------------------------------------------------------------------------------;

;-------------------------------7 SEGMENTOS------------------------------------;
DISP_0          EQU     FFF0h            ;display mais a direita    
DISP_1          EQU     FFF1h            ;display 1    
DISP_2          EQU     FFF2h            ;display 2
DISP_3          EQU     FFF3h            ;display 3
DISP_4          EQU     FFEEh            ;display 4    
DISP_5          EQU     FFEFh            ;display mais a esquerda    
;------------------------------------------------------------------------------;

;------------------------------FUNCAO GERACACTO--------------------------------;
ALTURA_MAX      EQU     4                ;altura maxima dos cactos 
;------------------------------------------------------------------------------;

;-----------------------------------PILHA--------------------------------------;
STACKBASE       EQU     8000h            ;stackpointer    
;------------------------------------------------------------------------------;

;-----------------------------FUNCAO ATUALIZAJOGO------------------------------;
DIMENSAO        EQU     80
;------------------------------------------------------------------------------;

;-----------------------------FUNCAO ESC_TERR----------------------------------;
POSICAO_TERR    EQU     1700h            ;posicao de escrita do terreno no terminal(display)    
;------------------------------------------------------------------------------;


;------------------------------------------------------------------------------;
;                       declaracao de variaveis                                                       
;                                                                 
;                              |diretiva/s: STR,TAB,WORD                                                                        
;------------------------------------------------------------------------------;

                ORIG    0000h
                
;-----------------------------FUNCAO ATUALIZAJOGO------------------------------;
TERRENO         TAB     DIMENSAO
;------------------------------------------------------------------------------;

;------------------------------FUNCAO GERACACTO--------------------------------;
VAL_INICIAL     WORD    3                 ;valor que determina a sequencia pseudo-aleatoria 
RES_GERACACTO   WORD    0                 ;resultado da funcao geracacto
;------------------------------------------------------------------------------;

;----------------------------------SALTO---------------------------------------;
SALTO           WORD    0                 ;flag ...       
HOLD_VAR        WORD    0                 ;altura maxima dos cactos +1  
HOLD_VAR_2      WORD    0                 ;flag ...
;------------------------------------------------------------------------------;

;------------------------------FUNCAO ESCREVEDINO------------------------------;
POS_DINO        WORD    1605H
;------------------------------------------------------------------------------;

;------------------------------FUNCAO SetScore---------------------------------;
CONTADOR        STR     0, 0, 0, 0, 0, 0
DIS7_ADD        STR     DISP_0, DISP_1, DISP_2, DISP_3, DISP_4, DISP_5
;------------------------------------------------------------------------------;

;----------------------------------RESTART-------------------------------------;
RESTART         WORD    0
;------------------------------------------------------------------------------;


;------------------------------------------------------------------------------;
;                                                                              ;
;                              CODIGO PRINCIPAL                                ;
;                                                                              ;
;------------------------------------------------------------------------------;


;-----------------------------INTERRUPT HANDLERS-------------------------------;

;               INTERRUPT HANDLER - KEY 0 (TECLA 0)
                ORIG    7F00h
                DEC     R6
                STOR    M[R6], R1
                DEC     R6
                STOR    M[R6], R2
                MVI     R1, RESTART ;
                MVI     R2, 1       ;
                STOR    M[R1], R2
                LOAD    R2, M[R6]
                INC     R6
                LOAD    R1, M[R6]
                INC     R6
                RTI
                
;               INTERRUPT HANDLER - KEY UP (SETA PARA CIMA)
                ORIG    7F30h
                DEC     R6
                STOR    M[R6], R1
                DEC     R6
                STOR    M[R6], R2
                JAL     SET_SALTO
                LOAD    R2, M[R6]
                INC     R6
                LOAD    R1, M[R6]
                INC     R6
                RTI
                
;               INTERRUPT HANDLER - TEMPORIZADOR
                ORIG    7FF0h
                DEC     R6
                STOR    M[R6], R1
                DEC     R6
                STOR    M[R6], R2
                JAL     FUNCAOTIMER 
                LOAD    R2, M[R6]
                INC     R6
                LOAD    R1, M[R6]
                INC     R6
                RTI
                
;------------------------------------------------------------------------------;

;-----------------------------INICIO DO CODIGO---------------------------------;

                ORIG    0000h
                
;-----------------------INICIALIZACAO DAS INTERRUPCOES-------------------------;

                MVI     R1, INT_MASK
                MVI     R2, 0000000000000001b
                STOR    M[R1], R2
                ENI
                
;------------------------------------------------------------------------------;

;----------------------------INICIALIZACAO DA PILHA----------------------------;
                
                MVI     R6, STACKBASE
                
;------------------------------------------------------------------------------;

;-----------------------INICIALIZACAO DO TEMPORIZADOR--------------------------;

                MVI     R1, TIMER_VALUE
                MVI     R2, 1
                STOR    M[R1], R2
                MVI     R1, TIMER_CONTROL
                MVI     R2, 1
                STOR    M[R1], R2

;------------------------------------------------------------------------------;

;------------------------------------------------------------------------------;
;--------------------------------INICIO JOGO-----------------------------------;
;------------------------------------------------------------------------------;

INICIO:         DEC     R6
                STOR    M[R6], R7   
                JAL     INICIOJOGO          ;chamada a funcao INICIOJOGO 
                JAL     ESC_TERR            ;chamada a funcao ESC_TERR,desenha o terreno do jogo
                LOAD    R7, M[R6]   
                INC     R6
                
                MVI     R1, RESTART 
                LOAD    R2, M[R1]   
                CMP     R2, R0              ;salta para o fim se o valor do RESTART 
                JMP.Z   FIM                 ;for 0 senao comeca o codigo  
                MVI     R2, 0               ;coloca o valor de RESTART a zero
                STOR    M[R1], R2           ;

JOGO_DINO:      NOP
                DSI
                MVI     R1, INT_MASK
                MVI     R2, INT_MASK_VALUE
                STOR    M[R1], R2
                ENI
loop:           BR      loop                ;aguarda pelas diferentes funcoes do 
                                            ;jogo                            
;------------------------------FUNCAO INICIOJOGO-------------------------------;
                                            ;limpa o ecran    
INICIOJOGO:     DEC     R6
                STOR    M[R6], R4
                DEC     R6
                STOR    M[R6], R5
                
                MOV     R3, R0
                
                MVI     R1, TERRENO
.cleartab:      MVI     R2, 0050h
                CMP     R1, R2
                BR.Z    .clearcounter
                MVI     R5, 0001h
                STOR    M[R1], R0
                ADD     R1, R1, R5
                BR      .cleartab

.clearcounter:  MVI     R1, CONTADOR
                STOR    M[R1], R0
                INC     R1
                STOR    M[R1], R0
                INC     R1
                STOR    M[R1], R0
                INC     R1
                STOR    M[R1], R0
                INC     R1
                STOR    M[R1], R0
                INC     R1
                STOR    M[R1], R0
                
                
                                             ;percorre todas as linhas do terminal 
.loop1:         MVI     R1, TERM_CURSOR    
                MVI     R2, 0100h          
                                           
                STOR    M[R1], R3          
                                           
                MVIL    R3, 00h            
                                           
                MVI     R5, 1700h            
                CMP     R3, R5
                BR.Z    .fim

                                            ;percorre todas as colunas do terminal
.loop2:         MVI     R1, TERM_CURSOR
                MVI     R2, 0001h
                
                STOR    M[R1], R3
                ADD     R3, R3, R2
                
                MVI     R1, TERM_WRITE  
                MVI     R2, ' '             ;escreve o carater espaco ' ' em cada coluna de cada
                STOR    M[R1], R2           ;linha
                
                MOV     R5, R3
                MVIL    R5, 4Fh
                CMP     R3, R5
                BR.NP   .loop2
                
                MVI     R2, 0100h
                ADD     R3, R3, R2
                BR      .loop1
                
.fim:           LOAD    R5, M[R6]
                INC     R6
                LOAD    R4, M[R6]
                INC     R6
                
                JMP     R7
                
;------------------------------------------------------------------------------;

;------------------------------FUNCAO ESC_TERR---------------------------------;

ESC_TERR:       DEC     R6
                STOR    M[R6], R4
                DEC     R6
                STOR    M[R6], R5
                
                MOV     R3, R0
                MVI     R3, POSICAO_TERR    ;coloca em R3 a posicao do terreno  


.loop:          MVI     R1, TERM_CURSOR     ;
                MVI     R2, 0001h           ;
                                            ; 
                STOR    M[R1], R3           ; 
                ADD     R3, R3, R2          ; 
                                            ;
                MVI     R1, TERM_WRITE      ; percorre todas as posicoes  
                MVI     R2, 196             ; da linha 23 e escreve o carater  
                STOR    M[R1], R2           ; 196 em cada uma delas 
                                            ; carater 196 ,'─' 
                MVI     R5, 174Fh           ;
                CMP     R3, R5              ;
                BR.P    .fim                ;
                BR      .loop               ;
                
.fim:           LOAD    R5, M[R6]
                INC     R6
                LOAD    R4, M[R6]
                INC     R6
                
                JMP     R7       
                
;------------------------------------------------------------------------------;

;------------------------------FUNCAO GERACACTO--------------------------------;

geracacto:      DEC     R6                 ;
                STOR    M[R6], R4          ; Segundo a convecao do P4 e necessario
                DEC     R6                 ; manter os valores de R4 e R5 depois do
                STOR    M[R6], R5          ; fim da funcao

                MVI     R2, VAL_INICIAL
                LOAD    R2, M[R2]
                
                CMP     R2, R0             ; Devido a necessidade de um valor inicial 
                BR.Z    .nozero            ; para comecar a gerar valores aleatorios
                                           ; aleatorios usou-se o R2 para tal e 
                                           ; garantiu-se que este nao era nulo
                                   
.inicio:        MVI     R4, 1              ; Seguindo o pseudo codigo em Python
                TEST    R2, R4             ; comecou-se por fazer a conjuncao logica
                BR.NZ   .gotoxor           ; do valor inicial com 1                
                SHR     R2
                
.gotocheck:     MVI     R5, 62258          ; Avalia se o numero e superior a 62258
                CMP     R2, R5             ; visto ser superior a 95/100 dos numeros
                BR.NC   .End               ; inteiros positivos disponiveis com 16 bits        
                
                MVI     R3, 0              ; Se nao for entao o valor de retorno e 0
                BR      .End2              ; R3 = 0
                
.gotoxor:       SHR     R2                 ; Se a conjuncao logica de R2 com 1 for 1
                MVI     R5, B400h          ; entao executamos, seguindo o pseudo codigo
                XOR     R2, R2, R5         ; XOR(R2, 0xB400)
                BR      .gotocheck 
                
.End:           MOV     R4, R1             ; R4 = R1 (sendo R1 a altura maxima)
                DEC     R4                 ; R4 - 1 = R1 - 1
                AND     R3, R2, R4         ; R3 = R2 & (R1 - 1)
                INC     R3                 ; R3 = (R2 & (R1 - 1)) + 1 (Valor de retorno)
                
                
                
.End2:          MVI     R4, VAL_INICIAL
                STOR    M[R4], R2
                LOAD    R5, M[R6]          ;
                INC     R6                 ; Restora os valores de R4 e R5
                LOAD    R4, M[R6]          ;
                INC     R6                 ;
                
                JMP     R7                 ; Volta para o corpo inicial do programa

.nozero:        MVI     R3, VAL_INICIAL    ; Garante que o valor inicial R2 nao
                LOAD    R2, M[R3]
                BR      .inicio            ; seja nulo
                
;------------------------------------------------------------------------------;

;----------------------------FUNCAO ATUALIZAJOGO-------------------------------;

ATUALIZAJOGO:                           ; R1 = 1 POSICAO DO TERRENO E R2 = DIMENSAO DO TERRENO
                DEC     R6              ; 
                STOR    M[R6], R7       ;salvaguarda o endereco de retorno
                DEC     R6              ;
                STOR    M[R6], R4       ; Segundo a convecao do P4 e necessario
                DEC     R6              ; manter os valores de R4 e R5 depois do
                STOR    M[R6], R5       ; fim da funcao
                
                ; Escreve Dino porque se tem que atualizar uma vez cada ciclo
                ; de jogo
                
                DEC     R6
                STOR    M[R6], R1
                DEC     R6
                STOR    M[R6], R2
                DEC     R6
                STOR    M[R6], R7
                
                JAL     ESCREVE_DINO
                
                LOAD    R7, M[R6]
                INC     R6
                LOAD    R2, M[R6]
                INC     R6
                LOAD    R1, M[R6]
                INC     R6
                
                
                MOV     R4, R1; R4 = 0000h
                ADD     R5, R1, R2  ; R5 = 0050h
                
                
.loop:          CMP     R2, R0          ; R2 == 0 ? verifica se já se percorreu todas 
                BR.Z    .retorna        ; as posicoes
                
                INC     R4              ; R4 contem o endereço da 1 posicao 
                CMP     R4, R5          ; do terreno inicialmente
                BR.Z    .callgc         ; passa-se para o endereço seguinte
                LOAD    R4,M[R4]        ; copia-se para R4 o conteudo do endereco n+1
.cont:          STOR    M[R1],R4        ; guarda se o n conteudo de n+1

                DEC     R6
                STOR    M[R6], R1
                DEC     R6
                STOR    M[R6], R2
                DEC     R6
                STOR    M[R6], R7

                JAL     ESCREVE_CACTO
                
                LOAD    R7, M[R6]
                INC     R6
                LOAD    R2, M[R6]
                INC     R6
                LOAD    R1, M[R6]
                INC     R6

                INC     R1        ; endereco n+1
                MOV     R4, R1
                DEC     R2        ; se estivermos no ultimo endereco entao vai
                BR      .loop     ; se buscar o valor da funcao geracacto
                
.retorna:       LOAD    R5, M[R6]
                INC     R6
                LOAD    R4, M[R6]
                INC     R6
                LOAD    R7, M[R6]
                INC     R6
                
                JMP     R7

.callgc:        DEC     R6
                STOR    M[R6], R1
                DEC     R6
                STOR    M[R6], R2
                MVI     R1, ALTURA_MAX   ;
                JAL     geracacto        ; CHAMA A FUNCAO GERACACTO PARA GERAR
                LOAD    R2, M[R6]        ; UM NUMERO PSEUDO ALEATORIA
                INC     R6
                LOAD    R1, M[R6]
                INC     R6
                MOV     R4, R3
                BR      .cont


;------------------------------------------------------------------------------;

;-------------------------------ESCREVE CACTO----------------------------------;

ESCREVE_CACTO:  DEC     R6
                STOR    M[R6], R4
                DEC     R6
                STOR    M[R6], R5
                DEC     R6
                STOR    M[R6], R7
                
                MOV     R2, R1
                MVIH    R2, 16h           ; POSICIONA O R2 NA PRIMEIRA LINHA
                LOAD    R1, M[R1]         ; DO TERRENO
                MVI     R4, TERM_CURSOR
                MVI     R5, TERM_WRITE
                
.loop:          CMP     R1, R0
                BR.Z    .fim
                
                ;CHECK COLISIONS
                MVI     R3, POS_DINO       ; VERIFICA SO SE HA COLISOES NA
                LOAD    R3, M[R3]
                CMP     R2, R3             ; POSICAO DO DINO
                BR.Z    .checkcolisions
                
.cont:          STOR    M[R4], R2          ; ESCREVE O CARACTER '|' NAS POSICOES
                MVI     R3, 179            ; DOS CACTOS
                STOR    M[R5], R3          ;
                
                MVI     R3, 0001h
                ADD     R2, R2, R3         ;
                STOR    M[R4], R2          ; ESCREVE O CARACTER ' ' NA POSICAO
                MVI     R3, ' '            ; IMEDIATAMENTE ATRAS DO CACTO 
                STOR    M[R5], R3          ; APAGANDO O QUE LA ESTAVA ANTES
                MVI     R3, 0001h
                SUB     R2, R2, R3
                
                MVI     R3, 0100h
                SUB     R2, R2, R3
                DEC     R1
                
                BR      .loop
                
                
.fim:           
                LOAD    R7, M[R6]
                INC     R6
                LOAD    R5, M[R6]
                INC     R6
                LOAD    R4, M[R6]
                INC     R6
                
                JMP     R7

.checkcolisions:DEC     R6
                STOR    M[R6], R1
                DEC     R6
                STOR    M[R6], R2
                
                MVI     R1, TERRENO     ; COLOCA R1 NA COLUNA ONDE O DINO ESTA
                INC     R1              ; DESENHADO
                INC     R1
                INC     R1
                INC     R1
                INC     R1
                LOAD    R1, M[R1]
                
.loop2:         CMP     R1, R0
                BR.Z    .end

                MVI     R3, POS_DINO  ; 
                LOAD    R3, M[R3]     ; VERIFICA SE A PARTE MAIS BAIXA DO DINO
                CMP     R3, R2        ; ESTA DE BAIXO DA LINHA MAIS ALTA DO
                JMP.NN   GAMEOVER     ; CACTO (COMO AS LINHAS MAIS ACIMA SAO 
                                      ; MENORES VERIFICA SE SE E NAO NEGATIVO)
                MVI     R3, 0100h
                SUB     R2, R2, R3
                DEC     R1
                
                BR      .loop2

.end:           LOAD    R2, M[R6]
                INC     R6
                LOAD    R1, M[R6]
                INC     R6
                BR      .cont
 
                
                
;------------------------------------------------------------------------------;

;-------------------------------ESCREVE DINO-----------------------------------;

ESCREVE_DINO:   DEC     R6
                STOR    M[R6],R7
                DEC     R6
                STOR    M[R6],R4
                DEC     R6
                STOR    M[R6],R5
                
                MVI     R1, SALTO       ; VERIFICA SE A VARIAVEL SALTO E 1
                LOAD    R1, M[R1]       ; SE FOR INICIA A ROTINA DE SALTO
                CMP     R1, R0          ;
                BR.NZ   .salto          ; 

.cont:          MVI     R1, POS_DINO    ; ESCREVE UM CARACTER DO DINO NUMA LINHA
                                        ; E DEPOIS ESCREVE NA LINHA A CIMA OUTRO
                LOAD    R1,M[R1]        ; ATE ESCREVER TODOS OS CARACTERES DO       
                MVI     R2, 0100h       ; DINO, COMECANDO NA POS_DINO
                MVI     R4,TERM_WRITE
                MVI     R5,TERM_CURSOR   
                MVI     R3,'('
                STOR    M[R5],R1
                STOR    M[R4],R3
                
                SUB     R1, R1, R2
                                    
                STOR    M[R5], R1
                MVI     R3,'$'
                STOR    M[R4],R3
                
                SUB     R1, R1, R2
                STOR    M[R5],R1
                MVI     R3,'»'
                STOR    M[R4],R3
                
                SUB     R1, R1, R2
                STOR    M[R5], R1
                MVI     R3, ' '
                STOR    M[R4], R3
                
                ; RECOVER CONTENXT
                LOAD    R5, M[R6]
                INC     R6
                LOAD    R4, M[R6]
                INC     R6
                LOAD    R7, M[R6]
                INC     R6
                
                JMP     R7

.salto:         MVI     R1, HOLD_VAR      ; USAMOS HOLD_VAR COMO COUNTER
                LOAD    R4, M[R1]         ; E REPETIMOS O LOOP UMA VEZES MAIS
                MVI     R5, ALTURA_MAX    ; DO QUE A ALTURA MAXIMA DOS CACTOS
                INC     R5                ; DE MODO A QUE A PARTE INFERIOR DO 
                CMP     R4, R5            ; DINO FIQUE UMA LINHA ACIMA DA LINHA
                BR.Z    .desce            ; MAIS ALTA DO CACTO, QUANDO ATINGE A
                                          ; ALTURA MAXIMA COMECA A DESCER
                                          
                MVI     R1, POS_DINO      ;
                MVI     R2, ' '           ; ESCREVE UMA ESPACO EM BRANCO NA 
                MVI     R4, TERM_CURSOR   ; LINHA MAIS BAIXA DO DINO DE MODO
                MVI     R5, TERM_WRITE    ; A APAGAR OS CARACTERES QUE LA 
                LOAD    R3, M[R1]         ; ESTAVAM ESCRITOS
                
                STOR    M[R4], R3
                STOR    M[R5], R2
                
                MVI     R2, 0100h         ;
                LOAD    R3, M[R1]         ; AUMENTA A POSICAO DINO EM UMA LINHA
                SUB     R3, R3, R2        ; E DEPOIS ESCREVE O DINO NORMALMENTE
                STOR    M[R1], R3         ;
                
                MVI     R1, HOLD_VAR
                MVI     R2, HOLD_VAR_2    ; USAMOS A VARIAVEL HOLD_VAR_2 COMO
                LOAD    R4, M[R1]         ; COUNTER DA ROTINA DESCE
                INC     R4
                STOR    M[R1], R4
                STOR    M[R2], R4
                BR      .cont

.desce:         MVI     R1, HOLD_VAR_2
                LOAD    R4, M[R1]
                CMP     R4, R0
                BR.Z    .cont1
                

                MVI     R1, POS_DINO         ;
                MVI     R2, 0100h            ; RETIRAMOS UMA LINHA A POS_DINO
                LOAD    R3, M[R1]            ; ESCREVEMOS O DINO NORMALMENTE
                ADD     R3, R3, R2           ;
                STOR    M[R1], R3
                
                MVI     R1, HOLD_VAR_2
                LOAD    R4, M[R1]
                DEC     R4
                STOR    M[R1], R4
                
                BR      .cont
                
.cont1:         MVI     R1, SALTO            ; depois de ter acabado o salto  
                STOR    M[R1], R0            ; coloca a VAR SALTO E VAR_HOLD a 0 
                MVI     R1, HOLD_VAR         ;
                STOR    M[R1], R0            ;
                BR      .cont                ; 

;------------------------------------------------------------------------------;

;---------------------------------SET_SALTO------------------------------------;

SET_SALTO:      MVI     R1, SALTO
                LOAD    R1, M[R1]
                MVI     R2, 1
                CMP     R1, R2              ; verifica se a variavel salto e 1 se for nao faz nada
                BR.Z    .fim                ; caso contrario coloca a 1
                
                MVI     R1, SALTO
                STOR    M[R1], R2
                
.fim:           JMP     R7

;------------------------------------------------------------------------------;

;----------------------------FUNCAO SET_SCORE----------------------------------;

SET_SCORE:      DEC     R6
                STOR    M[R6], R4
                DEC     R6
                STOR    M[R6], R5
                
                MVI     R4, DIS7_ADD
                MVI     R5, CONTADOR
                
                LOAD    R3, M[R5]
                INC     R3
                STOR    M[R5], R3
                LOAD    R1, M[R4]
                STOR    M[R1], R3
                
                MVI     R2, 9
                CMP     R3, R2
                BR.P    .nextpos
                BR      .sair
                
.nextpos:       INC     R5
                LOAD    R3, M[R5]
                INC     R3
                STOR    M[R5], R3
                INC     R4
                LOAD    R1, M[R4]
                STOR    M[R1], R3
                
                DEC     R6
                STOR    M[R6], R7
                CMP     R3, R2
                JAL.P   .nextpos
                LOAD    R7, M[R6]
                INC     R6
                
                DEC     R5
                DEC     R4
                MOV     R3, R0
                STOR    M[R5], R3
                LOAD    R1, M[R4]
                STOR    M[R1], R3
                
                MVI     R3, 0056h
                CMP     R5, R3
                BR.Z    .sair
                JMP     R7
                
.sair:          LOAD    R5, M[R6]
                INC     R6
                LOAD    R4, M[R6]
                INC     R6

                
                JMP     R7

;------------------------------------------------------------------------------;

;-----------------------------FUNCAO TIMER-------------------------------------;

FUNCAOTIMER:    DEC     R6
                STOR    M[R6], R3
                DEC     R6
                STOR    M[R6], R4
                DEC     R6
                STOR    M[R6], R5
                DEC     R6
                STOR    M[R6], R7
                
                MVI     R1, TERRENO
                MVI     R2, DIMENSAO
                JAL     ATUALIZAJOGO
                
                JAL     SET_SCORE
                
                MVI     R1, TIMER_CONTROL
                MVI     R2, 1
                STOR    M[R1], R2    
                
                LOAD    R7, M[R6]
                INC     R6
                LOAD    R5, M[R6]
                INC     R6
                LOAD    R4, M[R6]
                INC     R6
                LOAD    R3, M[R6]
                INC     R6
                
                JMP     R7

;------------------------------------------------------------------------------;

;---------------------------------GAMEOVER-------------------------------------;

GAMEOVER:       DSI
                MVI     R4, TERM_CURSOR
                MVI     R5, TERM_WRITE
                MVI     R3, 0001h
                MVI     R2, 0823h
                MVI     R1, 'G'
                STOR    M[R4], R2
                STOR    M[R5], R1
                ADD     R2, R2, R3
                MVI     R1, 'A'
                STOR    M[R4], R2
                STOR    M[R5], R1
                ADD     R2, R2, R3
                MVI     R1, 'M'
                STOR    M[R4], R2
                STOR    M[R5], R1
                ADD     R2, R2, R3
                MVI     R1, 'E'
                STOR    M[R4], R2
                STOR    M[R5], R1
                ADD     R2, R2, R3
                MVI     R1, ' '
                STOR    M[R4], R2
                STOR    M[R5], R1
                ADD     R2, R2, R3
                MVI     R1, 'O'
                STOR    M[R4], R2
                STOR    M[R5], R1
                ADD     R2, R2, R3
                MVI     R1, 'V'
                STOR    M[R4], R2
                STOR    M[R5], R1
                ADD     R2, R2, R3
                MVI     R1, 'E'
                STOR    M[R4], R2
                STOR    M[R5], R1
                ADD     R2, R2, R3
                MVI     R1, 'R'
                STOR    M[R4], R2
                STOR    M[R5], R1
                BR      FIM

;------------------------------------------------------------------------------;

;----------------------------------RESTART-------------------------------------;

FIM:            NOP
                MVI     R1, INT_MASK
                MVI     R2, 0000000000000001b
                STOR    M[R1], R2
                ENI
.loop:          MVI     R1, RESTART ;
                LOAD    R2, M[R1]   ; SALTA PARA O INICIO DO CODIGO SE O VALOR
                CMP     R2, R0      ; DA VARIAVEL RESTART FOR DIFERENTE DE 0
                JMP.NZ  INICIO      ; 
                BR      .loop       ; 

;------------------------------------------------------------------------------