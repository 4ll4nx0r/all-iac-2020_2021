; Allan Cravid Fernandes
; date - 24-11-2020 




;  definicao de constantes
 
; cronometro 
TIMER_CONTROL   EQU     FFF7h
TIMER_COUNTER   EQU     FFF6h

tempo_cont      EQU     5               ; valor modificado do tempo de contagem, intervalos de 0.5s
tempo_inic      EQU     10              ; valor inicial e padrao do tempo de contagem, intervalos de 1s
tempo_min       EQU     1               ; a contagem inicia-se em 0 
tempo_max       EQU     20              ; limite superior do cronometro 
tempo_comeco    EQU     1               ; valor que se coloca no TIMER_CONTROL,para por o cronometro a contar
tempo_paragem   EQU     0

; stack pointer 
sp_inic         EQU     7000h

; constantes associadas a mudanca do sentido de contagem 

cresce          EQU     1
decresce        EQU     0

; endereco de rotinas de servico associadas as keys

press_key0   EQU     7F00h
press_key1   EQU     7F10h

; interruptores 
switches        EQU     FFF9h

; display de 7 segmenntos 
DISP7_D0        EQU     FFF0h
DISP7_D1        EQU     FFF1h
DISP7_D2        EQU     FFF2h
DISP7_D3        EQU     FFF3h

; interrupcoes 

INT_MASK        EQU     FFFAh
INT_MASK_VAL    EQU     8003h ;1000 0000 000 0011 b
                ; interrupcoes do temporizador,do botao 0 e 1 

                ORIG    0000h 

; variaveis globais 

tempo           WORD    0               ;tempo decorrido 
tempo_val       WORD    tempo_inic      ;indica o periodo atual de contagem
timer_tick      WORD    0               ;indica o nª de eventos nao tratados pelo temporizador 

estado_keys     WORD    0               ;corresponde a flag que controla se a contagem e crescente ou decrescente

;---------------------------------------------------------------------             
                ORIG    0000h
                JMP     main
;---------------------------------------------------------------------

; main 
;               programa principal 
                
main:           MVI     R6,sp_inic      ;inicializacao da pilha 

                MVI     R1,INT_MASK     ;definicao da mascara 
                MVI     R2,INT_MASK_VAL
                STOR    M[R1],R2
                
                ENI                     ;ativacao generica das interrupcoes
                
                                       
                                        ;comeco do cronometro 
                                       
                MVI     R2,tempo_inic
                MVI     R1,TIMER_COUNTER
                STOR    M[R1],R2        ;a contagem faz-se em periodos de 1s,inicialmente 
                MVI     R1,timer_tick
                STOR    M[R1],R0        ;coloca o timer_tick a 0,isto e, inicialmente nao ha interrupcoes por atender
                MVI     R1,TIMER_CONTROL 
                MVI     R2,tempo_comeco
                STOR    M[R1],R2        ; a contagem e inicializada a partir de 0s 
                
                
                                        ; alinea a) e c) 
                                        ; dois tipos de eventos distintos,eventos do temporizador e eventos dos botoes 0 e 1                 
          
                MVI     R5,timer_tick
.loop:          LOAD    R1,M[R5]
                CMP     R1,R0
                JAL.NZ  .eventos_temp   
                BR      .loop
  
                                        ;tratamento de eventos do timer e a atualizacao do display de 7 segmentos feita no programa principal 
.eventos_temp:  
                MVI     R2,timer_tick
                DSI                     ;desliga-se as interrupcoes,de forma a nao alterar os valores nos registo
                LOAD    R1,M[R2]
                DEC     R1
                STOR    M[R2],R1
                ENI
                
                                      
                MVI     R2,switches
                LOAD    R1,M[R2]
                MVI     R2,1
                TEST    R1,R2
                BR.Z    contagem        ;inativo contagem normal   
                MVI     R2,tempo_cont   ;atualiza se o periodo de contagem
                MVI     R1,TIMER_COUNTER
                STOR    M[R1],R2
                BR      contagem
                        
                
                       
                                        ;atualizacao do tempo decorrido

contagem:       MVI     R1,tempo
                LOAD    R2,M[R1]
                INC     R2              ;incrementa-se o tempo decorrido 
                STOR    M[R1],R2
                                        ;tempo em hexadecimal 
                                        ;isolar cada um dos simbolos hexadecimais a partir do menos significativo(4 simbolos)
                MVI     R3,fh
                AND     R3,R2,R3
                MVI     R1,DISP7_D0
                STOR    M[R1],R3
                ;DISP7_D1
                SHR     R2
                SHR     R2
                SHR     R2
                SHR     R2
                MVI     R3,fh
                AND     R3,R2,R3
                MVI     R1,DISP7_D1
                STOR    M[R1],R3
                ;DISP7_D2
                SHR     R2
                SHR     R2
                SHR     R2
                SHR     R2
                MVI     R3,fh
                AND     R3,R2,R3
                MVI     R1,DISP7_D2
                STOR    M[R1],R3
                ;DISP7_D3
                SHR     R2
                SHR     R2
                SHR     R2
                SHR     R2
                MVI     R3,fh
                AND     R3,R2,R3
                MVI     R1,DISP7_D3
                STOR    M[R1],R3
                
                JMP     R7             
                
                
;---------------------------------------------------------------------

;rotinas de tratamento de interrupcoes 

AUX_TIMER_ISR:  
                DEC     R6              ;salvaguarda os registos 
                STOR    M[R6],R1
                DEC     R6
                STOR    M[R6],R2
                ; RESTART TIMER
                MVI     R1,tempo_val
                LOAD    R2,M[R1]
                MVI     R1,TIMER_COUNTER
                STOR    M[R1],R2          
                MVI     R1,TIMER_CONTROL
                MVI     R2,tempo_comeco 
                STOR    M[R1],R2        ;start timer
                ; INC TIMER FLAG
                MVI     R2,timer_tick
                LOAD    R1,M[R2]
                INC     R1
                STOR    M[R2],R1
                ; pops
                LOAD    R2,M[R6]
                INC     R6
                LOAD    R1,M[R6]
                INC     R6
                JMP     R7

                ORIG    7FF0h
TIMER_ISR:                              ;rotina de tratamento principal
                DEC     R6
                STOR    M[R6],R7
                JAL     AUX_TIMER_ISR
                LOAD    R7,M[R6]
                INC     R6
                RTI
                
                

;                ORIG    7F10h
;KEYONE:                                ;salvaguarda os registos
                                        ;o valor da flag timer_tick e ativado  
 ;               DEC     R6
 ;               STOR    M[R6],R1
 ;               DEC     R6
 ;               STOR    M[R6],R2
 ;               MVI     R2,timer_tick
 ;               MVI     R1,tempo
 ;               LOAD    R2,M[R1]
 ;               INC     R2             ;incrementa-se o tempo decorrido 
 ;               STOR    M[R1],R2
                ;pops
 ;               LOAD    R2,M[R6]
 ;               INC     R6
 ;               LOAD    R1,M[R6]
 ;               INC     R6
 ;               RTI


;                ORIG    7F00h
                                        ;salvaguarda os registos                             
                                        ; o valor da flag timer_tick e ativado  
;KEY:            DEC     R6             
;                STOR    M[R6],R1
;                DEC     R6
;                STOR    M[R6],R2
;                MVI     R2,timer_tick
;                MVI     R1,tempo
;                LOAD    R2,M[R1]
;                DEC     R2             ;incrementa-se o tempo decorrido 
;                STOR    M[R1],R2
                                        ; pops
;                LOAD    R2,M[R6]
;                INC     R6
;                LOAD    R1,M[R6]
;                INC     R6
                            
                        
                



         
                
                
                
                
                
                
                

                
                


