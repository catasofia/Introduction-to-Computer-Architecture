;*********************************************************************
; *
; * IST-UL
; *
; *     Projeto: Campo De Asteroides
; *     
; *     Curso: LEIC-T
; *     Grupo 19:
; *         N:93695 - Catarina Sofia Dos Santos Sousa
; *         N:93743 - Nelson Alexandre Geada Trindade
; *         N:93744 - Nuno Filipe Das Neves Viana Soares Carvalho
; *
; *********************************************************************

; *********************************************************************
; * Constantes
; **********************************************************************
DISPLAYS    EQU 0A000H 		; endere�o dos displays de 7 segmentos (perif�rico POUT-1)
TEC_LIN     EQU 0C000H 		; endere�o das linhas do teclado (perif�rico POUT-2)
TEC_COL     EQU 0E000H 		; endere�o das colunas do teclado (perif�rico PIN)
ECRA 		EQU 8000H 		; endereco do ecra (pixelscreen)  
LINHA       EQU 10H 		    ; teste de linha (comeca em 10000b)
numero_limite_aleatorio EQU 5H  ; 0-5 numeros possiveis aleatorios
linha_colisao_nave      EQU 27  ; linha onde ocorre a colisao com a nave
;*********************** Definições de Jogo *************************** 
tendencia_geracao_asteroides  EQU 3H   ; a cada X  iteracoes cria um novo asteroide  (quanto menos mais aparecem)
VALOR_SOMA  EQU 3H                     ; numero a somar quando ganha pontuação
VALOR_SUBTRACAO EQU 1H                 ; numero a subtrair quando perde pontuação 
numero_maximo_misseis EQU  1H          ; limite de misseis no campo
numero_maximo_asteroides EQU  10H       ; limite de asteroides no campo
tamanho_max_asteroides   EQU  5H       ; tamanho maximo dos asteroides (5 max)
somador_asteroides_frente EQU 1H       ; numero de linhas para a frente que cada asteroide a cada iteração
linha_limite_missil       EQU 15       ; alcance do missil (em linha)
;****************************** TECLAS ********************************

TECLA_VIRAR_ESQUERDA  EQU  0H       ; O 0 é a tecla de virar a esquerda
TECLA_VIRAR_DIREITA   EQU  3H       ; O 3 é a tecla de virar a direita
TECLA_MISSIL          EQU  2H       ; O 2 é a tecla de disparar missil
TECLA_PARAR_JOGO      EQU  0DH      ; O D é a tecla de parar o jogo
TECLA_CONTINUAR_JOGO  EQU  0CH      ; O C é a tecla de continuar o jogo
TECLA_TERMINAR_JOGO   EQU  0FH

; **********************************************************************
; * Codigo - Declaracao e inicializacao de variaveis
; *********************************************************************
PLACE       2000H
nave_string:  STRING 5,32
              STRING 0, 0, 0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0
              STRING 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0
              STRING 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0
              STRING 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0
              STRING 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1

menu_principal_string:  STRING 27, 32
                        STRING 0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                        STRING 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                        STRING 0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                        STRING 0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                        STRING 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                        STRING 0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0
                        STRING 0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0
                        STRING 0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0
                        STRING 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                        STRING 0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0
                        STRING 0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
                        STRING 0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
                        STRING 0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0
                        STRING 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                        STRING 0,0,1,1,1,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,1,0
                        STRING 0,1,1,1,1,1,0,0,0,0,0,0,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,1,0,1,0,0
                        STRING 0,1,1,1,1,1,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0
                        STRING 0,1,1,1,1,1,0,0,0,0,0,0,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,1,0,1,0,0
                        STRING 0,0,1,1,1,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,1,0
                        STRING 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                        STRING 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                        STRING 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                        STRING 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                        STRING 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                        STRING 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                        STRING 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                        STRING 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
game_over_string:
                        STRING 32, 32
                        STRING 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                        STRING 0,0,0,0,0,1,1,1,0,0,0,0,1,0,0,0,1,0,0,0,1,0,1,1,1,1,1,0,0,0,0,0
                        STRING 0,0,0,0,1,0,0,0,1,0,0,1,0,1,0,0,1,1,0,1,1,0,1,0,0,0,0,0,0,0,0,0
                        STRING 0,0,0,0,1,0,0,0,0,0,1,0,0,0,1,0,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0
                        STRING 0,0,0,0,1,0,0,0,0,0,1,0,0,0,1,0,1,0,0,0,1,0,1,1,1,0,0,0,0,0,0,0
                        STRING 0,0,0,0,1,0,1,1,1,0,1,1,1,1,1,0,1,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0
                        STRING 0,0,0,0,1,0,0,0,1,0,1,0,0,0,1,0,1,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0
                        STRING 0,0,0,0,1,0,0,0,1,0,1,0,0,0,1,0,1,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0
                        STRING 0,0,0,0,0,1,1,1,0,0,1,0,0,0,1,0,1,0,0,0,1,0,1,1,1,1,1,0,0,0,0,0
                        STRING 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                        STRING 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                        STRING 0,0,0,0,0,1,1,1,0,0,1,0,0,0,1,0,1,1,1,1,1,0,1,1,1,1,0,0,0,0,0,0
                        STRING 0,0,0,0,1,0,0,0,1,0,1,0,0,0,1,0,1,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0
                        STRING 0,0,0,0,1,0,0,0,1,0,1,0,0,0,1,0,1,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0
                        STRING 0,0,0,0,1,0,0,0,1,0,1,0,0,0,1,0,1,1,1,0,0,0,1,0,0,0,1,0,0,0,0,0
                        STRING 0,0,0,0,1,0,0,0,1,0,1,0,0,0,1,0,1,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0
                        STRING 0,0,0,0,1,0,0,0,1,0,1,0,0,0,1,0,1,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0
                        STRING 0,0,0,0,1,0,0,0,1,0,0,1,0,1,0,0,1,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0
                        STRING 0,0,0,0,0,1,1,1,0,0,0,0,1,0,0,0,1,1,1,1,1,0,1,0,0,0,1,0,0,0,0,0
                        STRING 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                        STRING 0,1,0,0,0,1,0,1,0,0,1,0,1,1,1,1,0,1,0,0,1,0,1,1,1,1,0,1,0,0,1,0
                        STRING 0,1,1,0,1,1,0,1,0,0,1,0,1,0,0,1,0,1,0,0,1,0,1,0,0,1,0,1,0,0,1,0
                        STRING 0,1,0,1,0,1,0,1,0,0,1,0,1,1,1,1,0,1,1,1,1,0,1,1,1,1,0,1,1,1,1,0
                        STRING 0,1,0,0,0,1,0,1,0,0,1,0,1,0,0,1,0,1,0,0,1,0,1,0,0,1,0,1,0,0,1,0
                        STRING 0,1,0,0,0,1,0,1,1,1,1,0,1,0,0,1,0,1,0,0,1,0,1,0,0,1,0,1,0,0,1,0
                        STRING 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                        STRING 0,0,0,0,0,0,1,1,1,1,0,1,0,0,1,0,1,1,1,1,0,1,0,0,1,0,0,0,0,0,0,0
                        STRING 0,0,0,0,0,0,1,0,0,1,0,1,0,0,1,0,1,0,0,1,0,1,0,0,1,0,0,0,0,0,0,0
                        STRING 0,0,0,0,0,0,1,1,1,1,0,1,1,1,1,0,1,1,1,1,0,1,1,1,1,0,0,0,0,0,0,0
                        STRING 0,0,0,0,0,0,1,0,0,1,0,1,0,0,1,0,1,0,0,1,0,1,0,0,1,0,0,0,0,0,0,0
                        STRING 0,0,0,0,0,0,1,0,0,1,0,1,0,0,1,0,1,0,0,1,0,1,0,0,1,0,0,0,0,0,0,0
                        STRING 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

menu_pausa_string:
                        STRING 32, 32
                        STRING 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                        STRING 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                        STRING 0,0,0,0,1,1,1,1,0,1,1,1,1,0,1,0,0,1,0,1,1,1,1,0,1,1,1,1,0,0,0,0
                        STRING 0,0,0,0,1,0,0,1,0,1,0,0,1,0,1,0,0,1,0,1,0,0,0,0,1,0,0,0,0,0,0,0
                        STRING 0,0,0,0,1,0,0,1,0,1,0,0,1,0,1,0,0,1,0,1,0,0,0,0,1,0,0,0,0,0,0,0
                        STRING 0,0,0,0,1,0,0,1,0,1,0,0,1,0,1,0,0,1,0,1,0,0,0,0,1,0,0,0,0,0,0,0
                        STRING 0,0,0,0,1,1,1,1,0,1,1,1,1,0,1,0,0,1,0,1,1,1,1,0,1,1,1,0,0,0,0,0
                        STRING 0,0,0,0,1,0,0,0,0,1,0,0,1,0,1,0,0,1,0,0,0,0,1,0,1,0,0,0,0,0,0,0
                        STRING 0,0,0,0,1,0,0,0,0,1,0,0,1,0,1,0,0,1,0,0,0,0,1,0,1,0,0,0,0,0,0,0
                        STRING 0,0,0,0,1,0,0,0,0,1,0,0,1,0,1,0,0,1,0,0,0,0,1,0,1,0,0,0,0,0,0,0
                        STRING 0,0,0,0,1,0,0,0,0,1,0,0,1,0,1,1,1,1,0,1,1,1,1,0,1,1,1,1,0,0,0,0
                        STRING 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                        STRING 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                        STRING 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                        STRING 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                        STRING 0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                        STRING 0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                        STRING 0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0
                        STRING 0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,1,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0
                        STRING 0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0
                        STRING 0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0
                        STRING 0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0
                        STRING 0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0
                        STRING 0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,1,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0
                        STRING 0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0
                        STRING 0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                        STRING 0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                        STRING 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                        STRING 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                        STRING 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                        STRING 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                        STRING 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

jogo_acabado_string:
                    STRING 32, 32
                    STRING 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                    STRING 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                    STRING 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                    STRING 0,0,0,0,0,0,1,0,0,0,1,0,1,1,1,1,0,1,0,0,1,0,1,1,1,0,0,0,0,0,0,0
                    STRING 0,0,0,0,0,0,0,1,0,1,0,0,1,0,0,1,0,1,0,0,1,0,1,0,0,1,0,0,0,0,0,0
                    STRING 0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,1,0,1,0,0,1,0,1,0,0,1,0,0,0,0,0,0
                    STRING 0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,1,0,1,0,0,1,0,1,1,1,0,0,0,0,0,0,0
                    STRING 0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,1,0,1,0,0,1,0,1,0,0,1,0,0,0,0,0,0
                    STRING 0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,1,0,1,0,0,1,0,1,0,0,1,0,0,0,0,0,0
                    STRING 0,0,0,0,0,0,0,0,1,0,0,0,1,1,1,1,0,1,1,1,1,0,1,0,0,1,0,0,0,0,0,0
                    STRING 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                    STRING 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                    STRING 0,0,1,1,1,1,0,1,1,1,1,0,1,0,0,0,1,0,1,1,1,1,0,0,0,1,0,1,1,1,1,0
                    STRING 0,1,0,0,0,0,0,1,0,0,1,0,1,1,0,1,1,0,1,0,0,0,0,0,0,1,0,1,0,0,0,0
                    STRING 0,1,0,0,0,0,0,1,0,0,1,0,1,0,1,0,1,0,1,0,0,0,0,0,0,1,0,1,0,0,0,0
                    STRING 0,1,0,1,1,1,0,1,1,1,1,0,1,0,0,0,1,0,1,1,1,0,0,0,0,1,0,1,1,1,1,0
                    STRING 0,1,0,0,0,1,0,1,0,0,1,0,1,0,0,0,1,0,1,0,0,0,0,0,0,1,0,0,0,0,1,0
                    STRING 0,1,0,0,0,1,0,1,0,0,1,0,1,0,0,0,1,0,1,0,0,0,0,0,0,1,0,0,0,0,1,0
                    STRING 0,0,1,1,1,0,0,1,0,0,1,0,1,0,0,0,1,0,1,1,1,1,0,0,0,1,0,1,1,1,1,0
                    STRING 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                    STRING 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                    STRING 0,0,1,1,1,0,1,0,1,0,0,1,0,1,0,1,1,1,0,1,0,1,0,1,1,1,0,1,1,0,0,0
                    STRING 0,0,1,0,0,0,1,0,1,1,0,1,0,1,0,1,0,0,0,1,0,1,0,1,0,0,0,1,0,1,0,0
                    STRING 0,0,1,0,0,0,1,0,1,0,1,1,0,1,0,1,0,0,0,1,0,1,0,1,0,0,0,1,0,1,0,0
                    STRING 0,0,1,1,0,0,1,0,1,0,0,1,0,1,0,1,1,1,0,1,1,1,0,1,1,0,0,1,0,1,0,0
                    STRING 0,0,1,0,0,0,1,0,1,0,0,1,0,1,0,0,0,1,0,1,0,1,0,1,0,0,0,1,0,1,0,0
                    STRING 0,0,1,0,0,0,1,0,1,0,0,1,0,1,0,0,0,1,0,1,0,1,0,1,0,0,0,1,0,1,0,0
                    STRING 0,0,1,0,0,0,1,0,1,0,0,1,0,1,0,1,1,1,0,1,0,1,0,1,1,1,0,1,1,0,0,0
                    STRING 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                    STRING 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                    STRING 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                    STRING 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                        
nave_pixeis_esquerda:   STRING 3, 4
                        STRING 0, 0, 0, 1
                        STRING 0, 1, 1, 0
                        STRING 1, 0, 0, 0

nave_pixeis_direita:    STRING 3, 4
                        STRING 1, 0, 0, 0
                        STRING 0, 1, 1, 0
                        STRING 0, 0, 0, 1

nave_pixeis_reset:      STRING 3, 4
                        STRING 0, 0, 0, 0
                        STRING 1, 1, 1, 1
                        STRING 0, 0, 0, 0

asteroide_destruido_string:  STRING 5, 5
                             STRING 0, 1, 0, 1, 0 
                             STRING 1, 0, 1, 0, 1 
                             STRING 0, 1, 0, 1, 0 
                             STRING 1, 0, 1, 0, 1 
                             STRING 0, 1, 0, 1, 0 

asteroide_destruido_string_reset:  STRING 5, 5
                             STRING 0, 0, 0, 0, 0 
                             STRING 0, 0, 0, 0, 0 
                             STRING 0, 0, 0, 0, 0 
                             STRING 0, 0, 0, 0, 0 
                             STRING 0, 0, 0, 0, 0       

tabela_possiveis_asteroides:
                            WORD 4160H
                            WORD 8140H
                            WORD 6160H
                            WORD 01E0H
                            WORD 21E0H
                            WORD 01E0H
              
numero_aleatorio: WORD 0                        ; guarda o numero aleatorio
tabela_misseis:  TABLE numero_maximo_misseis    ; tabela que armazena os misseis
tabela_ateroides:  TABLE numero_maximo_asteroides    ; tabela que armazena os asteroides
asteroide_destruido: WORD 0                          ; variavel temporaria que guarda a posicao do ultimo asteroide destruido
estado_virar_nave: WORD 0
mover_asteroides_estado:  WORD 0        ; variavel que gere o moviemento dos asteroides, fica a 1 sempre que e para mover o asteroide e a 0 quando nao e
movimento_asteroides_estado: WORD 0     ; estado que controla para que lado estao os asteroides a virar e com que rapidez (0 meio, 1 direita, 2 direita x2, -1 esquerda, -2 2x esquerda)
mover_missil_estado:      WORD 0        ; variavel que gere o moviemento do missil, fica a 1 sempre que e para mover o missil e a 0 quando nao e   
numero_misseis: WORD 0                  ; numero de misseis existentes no momento
estado_clique_missil: WORD 0            ; evitar que se gerem mais misseis enquanto o utilizador clica ne tecla de disparar
estado_jogo: WORD 0                     ; 0- menu principal, 1- a jogar, 2- pausa, 3-fim de jogo
flag_mover_asteroides: WORD 0           ; flag multiplicador de posicoes
flag_reset_asteroides: WORD 0           ; flag para saber se pode dar reset ao movimento dos asteroides
flag_pontuacao: WORD 0                  ; -1 inimigo 1 amigo
tecla_premida_flag: WORD 0
numero_asteroides: WORD 0
novo_asteroide_flag: WORD 0              ; a cada x iteracoes, cria um novo asteroide


mascara:    STRING 80H           ; tabela das mascaras
            STRING 40H
            STRING 20H
            STRING 10H
            STRING 8H
            STRING 4H
            STRING 2H
            STRING 1H

soma:       WORD 0d           ; valor da pontuacao
tecla_premida: WORD -1        ; tecla a ser premida neste momento

tab:                          ; tabela de interrupcoes
            WORD rot_int_0_missil
            WORD rot_int_1_asteroides
pilha:      TABLE 100H        ; espa�o reservado para a pilha 
                              ; (200H bytes, pois s�o 100H words)
SP_inicial:                   ; este � o endere�o (1200H) com que o SP deve ser 
                              ; inicializado. O 1.� end. de retorno ser� 
                              ; armazenado em 11FEH (1200H-2)

; *********************************************************************************
; * Codigo Inicial
; *********************************************************************************
PLACE   0 						; o codigo tem de comecar em 0000H
inicio:
    MOV  BTE, tab               ;Tabela de excecoes, interrupcoes, relogios c/ rotinas dos asteroides e misseis dentro
    MOV  SP, SP_inicial 	    ; Serve para iniciar a pilha         
    EI0
    EI1
    EI
    CALL reset_jogo           
; *********************************************************************************
; * Codigo Principal
; *********************************************************************************
ciclo:
    CALL testa_teclado
    CALL processar_estado_jogo
    CALL criar_novo_asteroide
    CALL virar_nave
    CALL mover_asteroides
    CALL mover_missil
    CALL gerador_numero_aleatorio
    JMP ciclo
; *********************************************************************************
; * ROTINAS
; *********************************************************************************

reset_jogo:
    PUSH R1
    PUSH R2
    PUSH R3
    ; volta para o menu incial
    MOV R1, estado_jogo     ; coloca na variavel R1, o endereco, p ex. 2000H
    MOV R2, 0               ; Coloca em R2 o 0 - menu principal
    MOV [R1], R2            ; coloca no endereco do R1 (estado jogo) e coloca 0, menu principal
    CALL apagar_ecra        ; reset de todos os bits do pixelscreen
    CALL escreve_nave       ; desenhar a nave
    CALL reset_nave        

    ; reset variavel da pontuaçao
    MOV R1, 0               
    MOV R3, soma            ; coloca no R3 o endereco da soma
    MOV [R3], R1            ; coloca no endereco do R3 (soma) o valor 0 (reset da soma)
    ; reset displays 
    MOV R3, DISPLAYS        ; coloca no R3 o endereco dos displays
    MOVB [R3], R1 	        ; coloca no endereco do R3 o valor 0 (reset dos displays)

    ; reset tabela misseis e asteroides
    MOV R1, numero_maximo_asteroides  ; coloca no R1 o endereco do numero_maximo_asteroides 
    MOV R2, tabela_ateroides		  ; coloca no R2 o endereco da tabela_ateroides
    CALL reset_tabela               
    MOV R1, numero_maximo_misseis     
    MOV R2, tabela_misseis			
    CALL reset_tabela

    ; reset numero de asteroides e misseis
    MOV R1, numero_asteroides        ; coloca no R1 o endereco do numero_asteroides
    MOV R2, 0                        ; coloca no R2 o valor 0
    MOV [R1], R2                     ; coloca no endereco do numero_asteroides o valor 0 (reset)
    MOV R1, numero_misseis           ; coloca no endereco o endereco do numero_misseis
    MOV R2, 0                        ; coloca no R2 o valor 0
    MOV [R1], R2                     ; coloca no endereco do numero_misseis o valor 0 (reset)
    POP R3
    POP R2
    POP R1
    RET
; tabela de 8 enderecos ocupam 16 enderecos 
reset_tabela:       ; recebe input uma tabela e da lhe reset
    PUSH R1         ; numero de elementos da tabela
    PUSH R2         ; endereco da tabela
    PUSH R3 
    MOV R3, 2       ; coloca no R3 o numero 2 
    MUL R1, R3      ; cada endereco ocupa 2, pq sao words, ocupam 2 bytes, multiplica para saber quantos enderecos ocupa
    SUB R1, 2       ; dava erro
    ADD R1, R2      ; ultimo endereço (elemento) da tabela
    MOV R3, 0       ; 
rt_prox_elemento:
    MOV [R2], R3    ; coloca a 0 
    ADD R2, 2       ; adiciona 2 para passar R2 para 1 elemento
    CMP R2, R1      ; compara R1 e o ultimo endereco da tabela
    JLE rt_prox_elemento  ; se for igual ou inferior repete o processo ate atingir o ultimo elemento
    POP R3
    POP R2
    POP R1
    RET

 ; input R4 - endereço da string a escrever
escreve_menu:   
    PUSH R1
    PUSH R2
    PUSH R4 
    MOV R1, 0            ; coloca a linha a 0
    MOV R2, 0            ; coloca a coluna a 0
    CALL ler_imagem
    POP R4
    POP R2
    POP R1
    RET

escreve_menu_principal:
    PUSH R4
    MOV R4, menu_principal_string ; coloca no R4 o endereco do menu_principal_string
    CALL escreve_menu
    POP R4
    RET

escreve_menu_pausa:
    PUSH R4
    MOV R4, menu_pausa_string     ; coloca no R4 o endereco do menu_pausa_string
    CALL escreve_menu
    POP R4
    RET

escreve_menu_game_over:
    PUSH R4
    MOV R4, game_over_string      ; coloca no R4 o endereco do menu game_over_string
    CALL escreve_menu
    POP R4
    RET

escreve_menu_jogo_acabado:
    PUSH R4
    MOV R4, jogo_acabado_string   ; coloca no R4 o endereco do jogo_acabado_string
    CALL escreve_menu
    POP R4
    RET
    

; rotina que retorna 1 apenas a primeira vez q a tecla é premida (R0) se nao retorna 0
tecla_repetida:
    PUSH R1
    PUSH R2
    MOV R1, tecla_premida              ; Coloca no R1 o endereco da tecla premida
    MOV R1, [R1]                       ; Coloca no R1 o valor que esta no endereco
    MOV R2, tecla_premida_flag         ; Coloca no R2 o endereco da tecla_premida_flag
    MOV R2, [R2]                       ; Coloca no R2 o valor que esta no endereco
    CMP R1, R2                         ; Compara as 2 teclas
    JEQ tr_repetida                    ; se forem iguais salta para tr_repetida
    MOV R0, 1                          ; retorna 1 apenas para a primeira vez que a tecla e premida    
    MOV R2, tecla_premida_flag         ; Coloca no R2 o endereco da tecla_premida_flag
    MOV [R2], R1                       ; atualiza a flag para a tecla premida
    JMP tr_fim 
tr_repetida:
    MOV R0, 0                          ; retorna 0 pq a tecla ja foi premida 1 vez
tr_fim:
    POP R2
    POP R1
    RET

; processa a flag que a colisao dos asteroides com a nave gera
processar_pontuacao:
    PUSH R1
    PUSH R2
    PUSH R3
    MOV R2, flag_pontuacao             ;Coloca no R2 o endereco da flag_pontuacao (-1- inimigo, 1- amigo)
    MOV R3, [R2]                       ; Coloca no R3 o valor do endereco da flag_pontuacao
    CMP R3, 1                          ; Compara o valor com 1 para saber se e amigo ou nao
    JNE testa_menos_um
    MOV R1, 1
    CALL somar_pontuacao
    MOV R1, 0
    MOV [R2], R1  ; reset da flag
testa_menos_um:
    CMP R3, -1                         ; Compara o valor com -1 para saber se e amigo ou inimigo
    JNE pp_nao_faz_nada                ; Se nao for igual, sai
    MOV R1, 0                          ; Como o asteroide e inimigo, reset da flag da pontuacao
    MOV [R2], R1                       ; Coloca no endereco de R2 
    MOV R2, estado_jogo                ; Coloca no R2 o endereco do estado de jogo
    MOV R3, 3                          ; Atualiza o estado de jogo para 3 (fim de jogo)
    MOV [R2], R3                       ; estado de jogo de game over
    MOV R2, flag_pontuacao             ; Coloca no R2 o endereco do flag_pontuacao
    CALL apagar_ecra                   
    CALL escreve_menu_game_over    
pp_nao_faz_nada:
    POP R3
    POP R2
    POP R1
    RET

; rotina que baseado no estado atual o jogo, realiza as determinadas ações
processar_estado_jogo:
    PUSH R1
    CALL processar_tecla_estado_jogo
    CALL processar_pontuacao
    MOV R1, estado_jogo                 ; Coloca no R1 o endereco do estado de jogo
    MOV R1, [R1]                        ; Coloca no R1 o valor que esta no endereco
    CMP R1, 0                           ; Compara com 0 para saber qual o estado
    JNE pj_pausa                        ; loop que representa o menu principal
    CALL reset_jogo                     
    CALL escreve_menu_principal
pj_menu:                                ; fica a iterar no menu principal a espera da tecla para sair
    CALL testa_teclado
    CALL processar_tecla_estado_jogo
    MOV R1, estado_jogo
    MOV R1, [R1]
    CMP R1, 0
    JEQ pj_menu
    CALL apagar_ecra
    CALL escreve_nave
pj_pausa:
    CMP R1, 2                           ; Compara o estado de jogo com 2
    JNE pj_game_over
    CALL apagar_ecra                    ; apaga o ecra que esta
    CALL escreve_menu_pausa              
pj_pausa_iterar:   ; fica a iterar no menu pausa ate que tecla para continuar seja premida
    CALL testa_teclado
    CALL processar_tecla_estado_jogo
    MOV R1, estado_jogo
    MOV R1, [R1]
    CMP R1, 2
    JEQ pj_pausa_iterar
    CALL apagar_ecra
    CALL escreve_nave
pj_game_over:
    CMP R1, 3
    JNE pj_fim
pj_game_over_iterar:   ; fica a iterar no menu pausa ate que tecla para continuar seja premida
    CALL testa_teclado
    CALL processar_tecla_estado_jogo
    MOV R1, estado_jogo     ; fica a iterar ate a tecla de recomecar o jogo seja premida
    MOV R1, [R1]
    CMP R1, 1
    JNE pj_game_over_iterar
    CALL reset_jogo
pj_fim:
    POP R1
    RET

; 0- menu principal, 1- a jogar, 2- pausa, 3-fim de jogo

; rotina que compara a tecla premida com uma tecla alteradora do estado de jogo
processar_tecla_estado_jogo:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R3
    CALL tecla_repetida
    CMP R0, 0                      ; Compara r0 com 0 para ver se foi premida ou nao
    JZ pj_tecla_fim                
    MOV R1, tecla_premida          ; Coloca no R1 o endereco da tecla_premida
    MOV R1, [R1]                   ; Coloca no R1 o valor da tecla premida
    MOV R2, estado_jogo            ; Coloca no R2 o endereco do estado_jogo
    MOV R3, TECLA_PARAR_JOGO       ; Coloca no R3 o valor da tecla para parar o jogo
    CMP R1, R3                     ; Compara a tecla premida com a tecla para parar jogo
    JNE pj_testar_um               ; tecla de pausar o jogo
    MOV R0, [R2]                   ; Coloca no R0 o valor de estado de jogo
    CMP R0, 2                      ; Compara o valor do estado de jogo com 2 (numero de pausa)
    JNE pjte_dois                  
    MOV R1, 1
    MOV [R2], R1
    JMP pj_tecla_fim
pjte_dois:
    MOV R1, 2                      ; Colcoa no R1 o numero 2
    MOV [R2], R1                   ; Atualiza o estado de jogo para 2 (pausa)
    JMP pj_tecla_fim
pj_testar_um:                       ; testar a tecla de continuar o jogo
    MOV R3, TECLA_CONTINUAR_JOGO 
    CMP R1, R3
    JNE pj_testar_dois
    MOV R1, 1
    MOV [R2], R1
pj_testar_dois:             ; testar a tecla de acabar o jogo
    MOV R3, TECLA_TERMINAR_JOGO
    CMP R1, R3                      ; terminar o jogo e manter pontuaçoes e ecra
    JNE pj_tecla_fim
    MOV R1, 3
    MOV [R2], R1
    CALL escreve_menu_jogo_acabado
pj_tecla_fim:
    POP R3
    POP R2
    POP R1
    POP R0
    RET

; ************ Rotina que testa se alguma tecla foi premida ***********************
testa_teclado:
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R6
    PUSH R7
    MOV  R1, LINHA              ; R1 vai testar a linha
    MOV  R2, TEC_LIN            ; endereco da linha
    MOV  R3, TEC_COL            ; endereco da coluna
tt_espera_tecla:                
    SHR  R1, 1                  ; avanca 1 bit para a direita para testar a linha a seguir
    JZ   tt_fim_testar_tecla    ; quando R1 chega a 0 jump para tt_fim_testar_tecla
    MOVB [R2], R1               ; coloca no endereco do R2 a linha premida 
    MOVB R0, [R3]               ; Coloca no R0 o endereco da coluna premida
    CMP  R0, 0                  ; verifica se alguma coluna foi pressionada, se for 0, repete o processo, h� tecla premida?
    JZ   tt_espera_tecla
tt_fim_testar_tecla:
    CMP  R0, 0                  ; se nenhuma tecla foi premida
    JZ   tt_fim_nenhuma_tecla   ; 
    MOV  R6, R1                 ; R6 - input do counter (linha)
    CALL counter                ; numero entre 0 e 3 da linha
    MOV  R2, R7                 
    MOV  R6, R0                 ; R6 - input do counter (coluna)
    CALL counter                
    MOV  R3, 4
    MUL  R2, R3                 ; linha * 4
    ADD  R2, R7                 ; somar linha com coluna
    MOV  R1, R2                 ; tecla pressionada 
    JMP  tt_fim
tt_fim_nenhuma_tecla:
    MOV R1, -1                  ; nenhuma tecla premida, retorna -1
tt_fim:
    MOV R2, tecla_premida       ; guarda a tecla premida na memoria
    MOV [R2], R1                ; guarda no endereco de R2, 
    POP R7
    POP R6
    POP R3
    POP R2
    POP R1
    RET

; ********************************************************************************************
; teste: STRING x,y - tamanho da imagem (x - nº linhas, y - nº colunas)
ler_imagem: ; R1 - linha, R2 - coluna , R4 - endereco da string
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R7
    MOVB R5, [R4]      ; contador de linhas
    ADD R4, 1          ; strings gastam 1 byte, a string esta vai para o byte a seguir
    MOVB R6, [R4]      ; contador de colunas
    MOV R7, R6         ; backup do R6
li_proximo_elemento:
    ADD R4, 1          ; vai para o proximo byte
    MOVB R3, [R4]      ; recebe o endereco, 0 ou 1, para saber se pinta ou nao
    CALL altera_bit 
    ADD R2, 1          ; soma 1 para verificar a coluna toda
    SUB R6, 1          ; para chegar a coluna 0 
    CMP R6, 0          ; compara a coluna com 0 para verificar se ja chegou ao fim
    JZ li_nova_linha   ; quando chegar a ultima coluna, passa para a nova linha, senao repete para verificar a proxima coluna
    JMP li_proximo_elemento
li_nova_linha:
    MOV R6, R7        ; volta ao numero de colunas inicial
    SUB R2, R6        ; voltar a primeira coluna
    SUB R5, 1         ; -1 no contador de linhas
    CMP R5, 0         ; Compara a linha com 0
    JZ  li_fim        ; se for igual a 0, sai da rotina, senao passa para a proxima linha
    ADD R1, 1         
    JMP li_proximo_elemento
li_fim:
    POP R7
    POP R6
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    RET


    

; ************ Rotina que calcula o numero de 0 a 3 da linha/coluna primida ******************
counter:  
;input R6 - linha/coluna
;output R7 - 0-3
    PUSH R9
    MOV R9, R6
    MOV R7, 0 
contar:    
    ADD R7, 1
    SHR R9, 1
    JNZ contar
    SUB R7, 1
    POP R9
    RET

; rotina que vai adicionando 1 ao numero aleatorio
gerador_numero_aleatorio:
    PUSH R1
    PUSH R2
    MOV R1, numero_aleatorio
    MOV R2, [R1]
    ADD R2, 1
    MOV [R1], R2
    POP R2
    POP R1
    RET

; *********************Rotina que altera o valor da pontuaçao******************************************
somar_pontuacao:     
; input R1     0- subtrai   1- adiciona
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    MOV R3, soma
    MOV R2, [R3]                ; valor da variavel soma
    CMP R1, 0
    JZ  ap_subtrair             ; se r1 é 0 entao vai subtrair
    MOV R3, VALOR_SOMA          ; valor a somar
    ADD R2, R3          
    MOV R3, R2                  ; backup do R2
    MOV R4, 15                  ; verificar ultimo nibble
    AND R3, R4                  ; verificar se o numero tem alguma letra
    MOV R4, 10                  ; se for mais que A entao ajusta o numero
    CMP R3, R4                 
    JLT  ap_fim                 ; se nao tiver entao ignora o ajuste
    ADD R2, 6
    JMP ap_fim
ap_subtrair:
    MOV R3, VALOR_SUBTRACAO     ; valor a subtrair
    SUB R2, R3
    MOV R3, R2                  ; backup do R2
    MOV R4, 15                  ; verificar ultimo nibble
    AND R3, R4                  ; verificar se o numero tem alguma letra
    MOV R4, 10                  ; se for mais que A entao ajusta o numero
    CMP R3, R4                 
    JLT  ap_fim                 ; se nao tiver entao ignora o ajuste
    SUB R2, 6
ap_fim:
    MOV R3, 99H
    CMP R2, R3                  ; se for maior que 99 decimal entao nao altera a variavel
    JGT ap_nao_altera_memoria
    CMP R2, 0
    JLT ap_nao_altera_memoria   ; se for menor que 0 decimal entao nao altera a variavel
    MOV R3, soma                ; endereço da variavel soma
    MOV [R3], R2                ; atualiza valor da variavel soma
    MOV R3, DISPLAYS            ; endereço do display
    MOVB [R3], R2               ; atualiza o valor dos displays
ap_nao_altera_memoria:
    POP R4
    POP R3
    POP R2
    POP R1
    RET

; ********************* Rotina que altera os bits do ecra ******************************************
altera_bit:
    ;R1 linha - input
    ;R2 coluna - input
    ;R3 ativo/desativo - input 0 -APAGAR 1-ESCREVER
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R7
    MOV R7, R2                ; coloca no R7 o valor R2

    MOV R4, 8                 ; numero de bits por byte
    MOV R5, R2                ; necessario para depois fazer o resto da divisao da coluna
    MOD R5, R4                ; bit maior peso da coluna
    DIV R2, R4                ; calcula a coluna em que se encontra
    MOV R6, 4
    MUL R1, R6                ; calcula a linha
    
    MOV R6, R7                ; guarda a coluna em R6
    MOV R4, 8                 ; fazer divisao inteira por 8 da coluna
    MOD R6, R4                ; endereço da mnascara a usar

    ADD R1, R2                ; calcula o endereço do byte a somar
    MOV R4, ECRA              ; endereço do 1 byte do ecra
    ADD R4, R1                ; endereço final do byte a alterar

    MOV R1, mascara
    ADD R1, R6
    MOVB R6, [R1]               ; guarda em R6 a mascara a usar
    CMP R3, 0
    JZ  apagar_bit            ; se R3 for 0 entao vai apagar o bit em questao
    MOVB R3, [R4]             ; ler byte do ecra
    OR R3, R6                  ; calcular novo byte
    MOVB [R4], R3              ; colocar o novo byte alterado
    JMP fim_ecreve_byte

apagar_bit:
    NOT R6                      ; negar a mascara
    MOVB R3, [R4]               ; ler byte do ecra
    AND R3, R6                  ; and da mascara com o byte
    MOVB [R4], R3               ; atualizar valor no pixelscreen
fim_ecreve_byte:
    POP R7
    POP R6
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    RET

; ****************ROTINA QUE ESCREVE A NAVE*************************************
escreve_nave:
    PUSH R1                     ; linha
    PUSH R2                     ; coluna
    PUSH R4                     ; backup
    MOV R1, 27                  ; comeca a pintar na linha 27
    MOV R2, 0                   ; comeca a pintar na coluna 0
    MOV R4, nave_string         ; coloca no R4 o endereco da da nave string, p.ex 2000H
    CALL ler_imagem    
    CALL reset_nave             ; escreve o volante
    POP R4
    POP R2
    POP R1
    RET

;*****************************************************************************************************************************************
reset_nave:                     ; apaga os pixeis das "viragens"  
    PUSH R1
    PUSH R2
    PUSH R4
    MOV R1, 29                  ; linha = 29
    MOV R2, 14                  ; coluna = 14
    MOV R4, nave_pixeis_reset   ; coloca no R4 o endereco da nave_pixeis_reset
    CALL ler_imagem
    POP R4
    POP R2
    POP R1
    RET

; ****************************************** Rotina que vira a nave  ******************************************
virar_nave: 
    PUSH R1                         
    PUSH R2                         
    MOV R2, tecla_premida           ; Coloca no R2 o endereco da tecla premida
    MOV R1, [R2]                    ; valor da ultima tecla premida
    MOV R2, TECLA_VIRAR_DIREITA     ; Coloca no R2 a tecla de virar a direita
    CMP R1, R2                      ; Compara as 2 teclas
    JNE vn_esquerda                 ; se nao for a de virar para a direita vai testar a esquerda
    CALL pixeis_virar_direita
    MOV R2, estado_virar_nave       ; o estado é 1 porque acabou de virar a nave
    MOV R1, 1
    MOV [R2], R1
    JMP fim_virar_nave
vn_esquerda:
    MOV R2, TECLA_VIRAR_ESQUERDA    ; Coloca no R2 a tecla para virar para a esquerda
    CMP R1, R2                      ; Compara as 2 teclas
    JNE vn_reset_nave               ; se tambem nao for a da esquerda vai tentar dar reset a nave (caso ja nao tenha dado antes)
    CALL pixeis_virar_esquerda
    MOV R2, estado_virar_nave       ; o estado é 1 porque acabou de virar a nave
    MOV R1, 1
    MOV [R2], R1
    JMP fim_virar_nave
vn_reset_nave:
    MOV R2, estado_virar_nave       ; verifica o estado da nave
    MOV R1, [R2]
    CMP R1, 0
    JEQ fim_virar_nave
    CALL reset_nave
    MOV R1, 0
    MOV [R2], R1                     ; o estado volta a ser 0 porque a nave ja esta na posição inicial
fim_virar_nave:
    POP R2 
    POP R1 
    RET

; ********************* Auxiliares para virar nave***************************************************************
pixeis_virar_direita: 
;input R3 0-apgar 1-escrever
    PUSH R1
    PUSH R2
    PUSH R4
    MOV R1, 29
    MOV R2, 14
    MOV R4, nave_pixeis_direita
    CALL ler_imagem
    POP R4
    POP R2
    POP R1
    RET

pixeis_virar_esquerda: ;input R3 0-apgar 1-escrever
    PUSH R1
    PUSH R2
    PUSH R4
    MOV R1, 29
    MOV R2, 14
    MOV R4, nave_pixeis_esquerda
    CALL ler_imagem
    POP R4
    POP R2
    POP R1
    RET
;*********************************************************************************************************
escrever_asteroide:     
; R1 - LINHA
; R2 - COLUNA
; R3 - TAMANHO
; R4 - TIPO (1- AMIGO 0- INIMIGO)
; R9 - APAGAR/ESCREVER 1-0
    CMP R4, 0
    JZ  ea_inimigo
    CALL asteroide_amigo
    JMP ea_fim
ea_inimigo:
    CALL asteroide_inimigo
ea_fim:
    RET

numero_aleatorio_output:        ; output R1, numero aleatorio
    PUSH R2
    MOV R1, numero_aleatorio    ; Coloca no R1 o numero aleatorio
    MOV R1, [R1]                ; Coloca no R1 o endereco do numero_aleatorio
    MOV R2, numero_limite_aleatorio ; Coloca no R2 o valor do numero_limite_aleatorio
    MOD R1, R2                      ; PERGUNTARRRRRRRRRRR
    POP R2
    RET

criar_novo_asteroide:
    PUSH R1
    PUSH R2
    PUSH R3
    ; verifica se pode criar um novo asteroide
    MOV R2, novo_asteroide_flag               ; Coloca no R2 o endereco do novo_asteroide_flag (velocidade a que queria novos asteroides)
    MOV R1, [R2]                              ;Coloca no R1 o valor que esta no endereco
    MOV R3, tendencia_geracao_asteroides      ; Coloca no R3 o valor 
    CMP R1, R3                                ; Compara a flag com o valor
    JLT ca_nao_cria                           ; Se for inferior nao cria novos asteroides 

    ; verifica se ja excedeu o limite de asteroides possiveis
    MOV R3, numero_asteroides                 ; Coloca no R3 o endereco do numero_asteroides
    MOV R1, [R3]                              ; Coloca no R1 o valor que esta no endereco
    MOV R2, numero_maximo_asteroides          ; Coloca no R2 o valro do numero_maximo_asteroides
    CMP R1, R2                                ; Compara para ver se cria novos asteroides ou nao
    JEQ ca_nao_cria                           ; So numero de asteroides for igual ao numero maximo nao cria 

    ; atualiza a variavel com o numero de asteroides no momento
    ADD R1, 1                                 ; Adiciona 1 ao numero de asteroides atuais ao criar um novo asteroide
    MOV [R3], R1                              ; Coloca no endereco de R3 o valor de R1

    ; reset da flag                        
    MOV R2, novo_asteroide_flag               ; Coloca no R2 o endereco do novo_asteroide_flag
    MOV R1, 0                                 
    MOV [R2], R1                              ; Coloca no endereco de R2 o valor 0 (reset da flag)

    CALL numero_aleatorio_output              ; R1 é um numero entre 0-5
    MOV R3, tabela_possiveis_asteroides       ; Colocar no R3 o valor da tabela
    MOV R2, 2                                 ; Coloca no R2 o valor 2
    MUL R1, R2                                ; Multiplica por 2 para saber qual o ultimo endereco 
    ADD R3, R1                                ; Adiciona R1 a R3 para avancar para o proximo elemento
    MOV R2, [R3]                              ; tipo de asteroide a ser criado
    MOV R1, tabela_ateroides                  ;  Coloca no R1 o numero maximo de asteroides possivel
    CALL verificar_espaco_tabela              
    MOV [R1], R2                        ; novo asteroide colocado na tabela
ca_nao_cria:
    POP R3
    POP R2
    POP R1
    RET

; ********************* Rotina que escreve um asteroide inimigo de tamanho R3 e posicao R1, R2 ***********
asteroide_inimigo:    
; R1 - linha  R2 - coluna  R3 - tamanho R9- apaga/ escreve 0-apaga 1- escreve na determinada posicao
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R8
    
    MOV R4, R1
    MOV R5, R2

    MOV R6, R3              ; usar R6 para comparar
    SUB R6, 1               ; ajustar R6
    MOV R7, 0               ; contador de linhas
    MOV R8, 0               ; contador de colunas
    MOV R3, R9              ; escrever/apagar bits no ecra 0 ou 1
    JMP ai_proxima_linha    ; para não adicionar +1 a coluna na primera vez
ai_nova_coluna:
    ADD R2, 1               ; proxima coluna
    ADD R8, 1
    MOV R1, R4              ; primera linha
    MOV R7, 0               ; reset ao contador de linhas
    CMP R8, R6              ; quando a coluna for maior que o tamanho, acaba o loop
    JGT ai_acertar_asteroide              
ai_proxima_linha:
    CALL altera_bit
    ADD R1, 1               ; proxima linha
    ADD R7, 1               ; incrementar contador de linhas
    CMP R7, R6              ; quando a linha for maior que o tamanho, entao vai para a proxima coluna
    JGT ai_nova_coluna
    JMP ai_proxima_linha
ai_acertar_asteroide:       ; retirar os pixeis dos cantos caso o tamanho seja superior a 2
    MOV R1, R4              ; restablece os valores de R1 e R2
    MOV R2, R5
    CMP R6, 2
    JLE ai_fim
    MOV R3, 0               ; apagar bits do ecra
    CALL altera_bit         ; bit superior esquerdo
    ADD R1, R6
    CALL altera_bit         ; bit inferior direito
    ADD R2, R6       
    CALL altera_bit         ; bit superior 
    SUB R1, R6
    CALL altera_bit   
ai_fim:
    MOV R3, R6
    POP R8
    POP R7
    POP R6
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    RET

; ************** Rotina que escreve um asteroide amigo de tamanho R3 e na posicao R1, R2*************
asteroide_amigo:    
;input R1 - linha  R2 - coluna  R3 - tamanho R9 - escreve/apaga 0-apaga 1- escreve
    PUSH R1
    PUSH R3
    PUSH R5
    PUSH R6
    PUSH R7         ; contador
    MOV R5, R2      ; backup das variaveis
    MOV R6, R3
    MOV R7, 0
    SUB R6, 1  		; ajustar o tamanho para ignorar o primeiro pixel
    MOV R3, R9 		; escrever bit
aa_repete_ciclo:
    CALL altera_bit
    MOV R2, R5
    ADD R2, R6
    CALL altera_bit
    MOV R2, R5
    ADD R7, 1
    ADD R2, R7
    ADD R1, 1
    SUB R6, 1
    JN aa_fim
    JMP aa_repete_ciclo
aa_fim:
    MOV R2, R5
    MOV R3, R6
    POP R7
    POP R6
    POP R5
    POP R3
    POP R1
    RET
; *************************** Rotina que inicializa o ecra todo a 0 **************************
apagar_ecra: ; funciona endereço a endereço (para otimizar)
    PUSH R1
    PUSH R2
    PUSH R3         ; auxiliar
    MOV R1, ECRA    ; Coloca no R1 o endereço ecra (pixelscreen)
    MOV R2, 80C0H   ; Coloca no  R2 o endereço limite do pixelscreen
ae_repete:
    MOV R3, 0     ; 
    MOV [R1], R3  ; mete no endereco do ecra o valor 0, coloca todos os bits a 0
    MOV R3, 2     
    ADD R1, R3    ; soma 2, avanca para o proximo endereco
    CMP R1, R2    ; Compara o endereco com o enderco limite do ecra
    JLE ae_repete ; se o endereco for menor ou igual ao limite, repete ate ser igual
    POP R3 
    POP R2
    POP R1
    RET

mover_missil:
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R7      ; contem a tecla premida

    ; verifica se e altura de mover missil
    MOV R2, mover_missil_estado
    MOV R2, [R2] 
    CMP R2, 0
    JEQ mm_fim         ; senao for 0 entao nao vai fazer nada porque nao e hora de mexer missil

    ; como vai mover missil, da reset a flag de mover missil
    MOV R1, mover_missil_estado
    MOV R2, 0
    MOV [R1], R2        

    ; comparacoes com as teclas respetivas
    MOV R7, tecla_premida
    MOV R7, [R7]

    ; verifica se foi pressionada a tecla de mover missil
    MOV R2, TECLA_MISSIL
    CMP R7, R2
    JNE mm_reset_estado_missil ; se a tecla de criar missil nao for premida apenas vai mexer o/os misseis e vai dar reset ao estado do clique missil

    ; prevenir de criar varios misseis enquanto o utilizador mantem a tecla primida
    MOV R7, estado_clique_missil     ; 1- quando pode criar novo missil 0-nao pode
    MOV R7, [R7]
    CMP R7, 0
    JEQ mm_mover_missil   ; se ainda tiver a ser premida a tecla entao nao faz nada

    ; reset estado do clique
    MOV R7, estado_clique_missil
    MOV R1, 0
    MOV [R7], R1                    ; mete o estado a 0 de forma a nao ser possivel criar um novo missil enquanto prime o botao

    ; impedir de criar mais misseis que o limite estipulado
    MOV R1, numero_maximo_misseis  
    MOV R2, numero_misseis
    MOV R2, [R2]
    CMP R2, R1
    JEQ mm_mover_missil          ; compara o numero de misseis atuais com o numero maximo, se esse numero for igual entao nao vai criar um novo missil
    ; criar um novo missil no espaço da tabela disponivel
    MOV R1, tabela_misseis          ; input verificar_espaco_tabela_misseis
    CALL verificar_espaco_tabela   ; R1 e a agora o endereco do elemento livre da tabela de misseis
    CALL criar_novo_missil
    JMP mm_mover_missil ; nao da reset ao estado porque acabou de criar um novo missil
mm_reset_estado_missil:
    MOV R7, estado_clique_missil    ; pode criar um novo missil
    MOV R1, 1
    MOV [R7], R1 
mm_mover_missil:    ; vai mover os misseis para a frente
    CALL iterar_tabela_misseis_frente
mm_fim:
    POP R7
    POP R3
    POP R2
    POP R1
    RET

criar_novo_missil:
    PUSH R2
    PUSH R3
    MOV R2, 15                   ; primeiro 8 bits sao a coluna do missil
    SHL R2, 5                    ; deixar espaco para mais 6 bits que vao ser a posicao da linha do missil
    MOV R3, 26
    OR  R2, R3                   ; juntar os dois 8 bits
    MOV [R1], R2                 ; guardar na memoria a posicao do novo missil 
    MOV R3, 1
    CALL altera_bit_missil       ; mostrar o novo missil no ecra
    MOV R2, numero_misseis
    MOV R2, [R2]
    ADD R2, 1                    ; aumenta o numero de misseis em +1
    MOV R1, numero_misseis
    MOV [R1], R2                 ; atualiza o numero de misseis total
    POP R3
    POP R2
    RET

verificar_espaco_tabela:    ; verifica que espaco se encontra livre na tabela e retorna a posicao dele 
; output- R1- endereco (supoe-se que se sabe que existe pelo menos um livre)
    PUSH R2
prox_elemento:
    MOV R2, [R1]    ; valor daquele endereco da tabela
    ADD R1, 2       ; proximo endereco
    CMP R2, 0       
    JNE prox_elemento
    SUB R1, 2       ; porque este e o prox elemento
    POP R2
    RET

iterar_tabela_misseis_frente:
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    MOV R1, numero_maximo_misseis    
    MOV R2, 2
    MUL R1, R2                      ; duplica o numero porque a tabelo tem o dobro dos endrecos ja que cada entrada ocupa dois enderecos
    MOV R2, tabela_misseis
    ADD R1, R2                      ; R1 e o ultimo endereco da tabela
    SUB R1, 2
    MOV R4, tabela_misseis          ; R4 e o primeiro endereco da tabela
ttmf_prox_missil:
    MOV R2, [R4]                    ; valor do primeiro missil
    MOV R5, R4                      ; endereco do missil para input ao testar missil
    CALL testar_missil
    CMP R2, 0
    JZ prox_missil
    MOV R3, 0
    CALL altera_bit_missil          ; apaga missil na posicao anterior
    MOV R6, R1                      ; valor de R1 vai ser alterado
    CALL retorna_coordenada
    SUB R1, 1                       ; andar para a proxima linha
    MOV R3, movimento_asteroides_estado
    MOV R3, [R3]
    SUB R2, R3
    SHL R2, 5
    OR R2, R1
    MOV R3, 1                       ; escreve missil na proxima posicao
    CALL altera_bit_missil
    MOV R1, R6                      ; repoe o valor de R1
    MOV [R4], R2                    ; atualiza o valor na tabela com a nova coordenada do missil
prox_missil:
    ADD R4, 2
    CMP R4, R1
    JLE ttmf_prox_missil 
    POP R6
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    RET

retorna_coordenada:     ; rotina que recebe uma coordenada na forma hexadecimal AABB em que AA e a coluna e BB e a linha
; input R2, output - R1, R2
    PUSH R4
    MOV R1, R2
    MOV R4, 00011111b     ; mascara 0001 1111 para buscar a coluna
    AND R1, R4       ; R1 e a linha
    SHR R2, 5        
    AND R2, R4       ; R2 e a coluna
    POP R4
    RET

apagar_missil_tabela: ; r1, r2 posicao missil
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5                 ; endereco do missil na tabela 
    MOV R2, [R5]            ; R1, E R2 sao as coordenadas do missil
    CALL retorna_coordenada
    MOV R3, 0
    CALL altera_bit
    MOV R2, 0
    MOV [R5], R2           ; atualiza na tabela dos misseis o missel para 0
    MOV R4, numero_misseis ; atualiza o numero de misseis em -1
    MOV R5, [R4]
    SUB R5, 1
    MOV [R4], R5
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    RET


testar_missil:      ; rotina que apaga o missil se ele ja tiver excedido o ecra
    ;input R2 coordenadas missil, r5 posicao memoria do missil retorna R2 = 0 se o missil for apagado e R2 = R2 se nao for
    PUSH R1
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    CMP R2, 0       ; se o missil nao existir entao tambem nao o vai apagar
    JZ tm_fim
    MOV R6, R2       ; backup R2 porque R2 vai ser alterado na proxima rotina
    CALL retorna_coordenada  ; R1 e agora a linha e R2 a coluna
    MOV R4, 31      ; utltima linha/coluna
    CMP R1, R4
    JEQ apagar_missil
    MOV R4, linha_limite_missil       ; linha limite do missil
    CMP R1, R4
    JEQ apagar_missil
    JMP nao_apagar_missil
apagar_missil:
    CALL apagar_missil_tabela
    MOV R2, 0
    JMP tm_fim
nao_apagar_missil:
    MOV R2, R6             ; reestablece o valor de R2
tm_fim:
    POP R6
    POP R5
    POP R4
    POP R3
    POP R1
    RET

altera_bit_missil:   ; input R2, posicao missil R3-0 para apagar 1- para escrever
    PUSH R1
    PUSH R2
    PUSH R4          ; decide se escreve ou apaga na posicao
    CALL retorna_coordenada ; R1 e agora a linha e R2 a coluna
    CALL altera_bit
    POP R4
    POP R2
    POP R1
    RET

; rotina que processa a tecla pressionada e atualiza o estado de moviemento dos asteroides
atualizar_estado_movimento_asteroides:
    PUSH R8
    PUSH R9
    MOV  R8, flag_mover_asteroides          ; Coloca no R8 o endereco da flag_mover_asteroides
    MOV  R8, [R8]                           ; Coloca no R8 o valor que esta no endereco
    CMP  R8, 0   ; se for 0 nao vai alterar o multiplicador, apenas pode dar reset se as teclas n forem primidas
    JZ aem_reset_estado 
    MOV  R8, tecla_premida
    MOV  R8, [R8]             ; tecla premida
    MOV  R9, TECLA_VIRAR_DIREITA
    CMP  R8, R9
    JNE  aem_tecla_esquerda   ; se nao for vai testar a tecla esquerda
    MOV  R8, flag_mover_asteroides      ; reset da flag
    MOV  R9, 0
    MOV  [R8], R9
    MOV  R8, movimento_asteroides_estado 
    MOV  R8, [R8]             ; verificar valor da variavel estado do movimento dos asteroides
    CMP  R8, 2                 
    JEQ  aem_fim              ; caso o estado ja esteja a 2 nao atualiza o estado
    ADD  R8, 1                ; aumenta o estado em 1
    MOV  R9, movimento_asteroides_estado
    MOV  [R9], R8             ; atualiza o estado
    JMP aem_fim
aem_tecla_esquerda:
    MOV  R9, TECLA_VIRAR_ESQUERDA
    CMP  R8, R9
    JNE  aem_reset_estado
    MOV  R8, flag_mover_asteroides      ; reset da flag
    MOV  R9, 0
    MOV  [R8], R9
    MOV R8, movimento_asteroides_estado
    MOV R8, [R8]
    CMP  R8, -2                 
    JEQ  aem_fim              ; caso o estado ja esteja a -2 nao atualiza o estado
    SUB  R8, 1                ; diminui o estado em -1
    MOV  R9, movimento_asteroides_estado
    MOV  [R9], R8             ; atualiza o estado
    JMP aem_fim
aem_reset_estado:
    MOV  R8, tecla_premida                ; coloca no R8 o endereco da tecla premida
    MOV  R8, [R8]                         ; coloca no R8 o valor da tecla premida
    MOV  R9, TECLA_VIRAR_ESQUERDA         ; Coloca no R9 o valor 
    CMP  R8, R9                           ; Compara as teclas
    JEQ  aem_fim
    MOV  R9, TECLA_VIRAR_DIREITA          ; Se forem diferentes, colcoa no R9 a tecla que vira a direita
    CMP  R8, R9                           ; Compara com a tecla premida
    JEQ  aem_fim 
    MOV  R8, flag_reset_asteroides        ; Se forem diferentes, coloca no R8 o endereco do flag_reset_asteroides
    MOV  R8, [R8]                         ; Coloca o valor do flag_reset_asteroides
    CMP  R8, 0                            ; Compara o valor da flag com 0 
    JZ aem_fim                            
    MOV  R8, flag_reset_asteroides        ; Coloca o endereco do flag_reset_asteroides no R8
    MOV  R9, 0                            ; Coloca no R9 o valor 0
    MOV  [R8], R9                         ; Coloca a flag_reset_asteroides a 0
    MOV  R8, movimento_asteroides_estado  ; Coloca o endereco do movimento_asteroides_estado no R8
    MOV  R9, 0                            
    MOV  [R8], R9                         ; reset estado do movimento dos asteroides
aem_fim:
    POP R9
    POP R8
    RET

reset_asteroide_destruido:
    PUSH R1
    PUSH R2
    PUSH R4

    ; atualiza o numero de asteroides no momento
    MOV R1, numero_asteroides
    MOV R2, [R1]
    SUB R2, 1
    
    MOV [R1], R2
    MOV R2, asteroide_destruido
    MOV R2, [R2]
    CMP R2, 0
    JZ  rd_nao_faz_nada
    CALL retorna_coordenada
    MOV R4, asteroide_destruido_string_reset
    CALL ler_imagem
    MOV R2, asteroide_destruido
    MOV R1, 0
    MOV [R2], R1   ; reset da variavel do asteroide destruido
rd_nao_faz_nada:
    POP R4
    POP R2
    POP R1
    RET

mover_asteroides:   
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R8
    CALL atualizar_estado_movimento_asteroides ; processar tecla e determinar se vai mover ou nao os asteroides
    MOV R6, mover_asteroides_estado            ; Coloca no R6 o endereco do mover_asteroides_estado
    MOV R1, [R6]                               ; Coloca no R1 o estado de mover os asteroides atualizado
    CMP R1, 0                                  ; se for 0 nao e hora de mover os asteroides
    JZ ma_fim      
    ; primeiro vai apagar, se existir o asteroide destruido
    CALL reset_asteroide_destruido
    MOV R1, 0
    MOV [R6], R1                        ; atualiza o estado do mover asteroides para 0
    MOV R3, 2
    MOV R4, numero_maximo_asteroides 
    MUL R4, R3                         ; cada asteroide ocupa dois enderecos
    MOV R3, tabela_ateroides           ; iterador da tabela
    ADD R4, R3                         ; ultimo elemento da tabela dos asteroides
    SUB R4, 2                          ; ajustar ultimo elemento
ma_prox_asteroide:
    MOV R1, [R3]                       ; valor do asteroide presente na tabela
    CMP R1, 0
    JZ ma_prox_elemento                 ; se for 0 o asteroide nao existe entao passa para o proximo
    MOV R8, R3                          ; input da posicao de memoria do asteroide para o processa asteroide
    CALL processa_asteroide             
    MOV [R3], R1                        ; atualiza a tabela com a nova posicao do asteroide
ma_prox_elemento:
    ADD R3, 2
    CMP R3, R4                          ; ver se ja iterou sobre todos os elementos da tabela
    JLT ma_prox_asteroide
    MOV R1, flag_reset_asteroides       ; o movemnto ja foi usado, ja e possivel dar reset ao estado
    MOV R2, 1
    MOV [R1], R2 
ma_fim:
    POP R8
    POP R6
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    RET

encriptar_asteroide:    ; R1- linha R2- coluna R3- tamanho R4- tipo, R7- fila do asteroide output R1- asteroide encriptado
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R7
    SHL R2, 5
    OR R1, R2          ; junta linha e coluna em r1
    SHL R3, 10         
    OR R1, R3          ; junta linha coluna e tamnaho
    SHL R4, 13
    OR R1, R4          ; junta linha coluna tamnaho e tipo de asteroide
    SHL R7, 14
    OR R1, R7          ; junta linha coluna tamnaho e tipo de asteroide e fila dele
    POP R7
    POP R4
    POP R3
    POP R2
    RET
; PO - posicao do asteroide, esquerda, medio, direita 
; T - tipo de asteroide  0 ou 1
; TAM - indice da tabela de posicoes e tamanho
; COLUN - coluna
; LINHA - linha
; PO T TAM COLUN LINHA 0000 0000 0000 0000
; 00 0 000 00000 00000  - 16 bits
processa_asteroide:  ; input R1, escreve o asteroide na proxima posicao e apaga o da ultima, e retorna o valor da nova posicao 
    PUSH R0
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R8
    PUSH R9
    MOV R3, R1      ; saber tamanho do asteroide
    MOV R5, 1C00H   ; mascara 0001 1100 0000 0000 para o tamanho do asteroide
    AND R3, R5      ; R3 - TAMANHO E INDICE DA TABELA DE POSICOES (TAM)
    SHR R3, 10      ; ajustar posicao
    MOV R4, R1      ; tipo de asteroide
    MOV R5, 2000H   ; mascara 0010 0000 0000 0000 para saber o tipo de asteroide
    AND R4, R5      ; R4 - TIPO DE ASTEROIDE (T)
    SHR R4, 13      ; ajustar posicao
    MOV R7, R1
    MOV R5, 0C000H  ; mascara 0010 0000 0000 0000 para saber a fila onde se encontra o asteroide
    AND R7, R5      ; R7 - POSICAO DO ASTEROIDE (PO)
    SHR R7, 14      ; ajustar posicao
    MOV R2, R1
    CALL retorna_coordenada   ; R1 - LINHA   R2 - COLUNA
    MOV R9, 0       ; apagar asteroide
    CALL escrever_asteroide   ; apagar asteroide anterior
    CALL processar_estado_movimento   ; saber se virou para esquerda / direita
    MOV R0, R4
    CALL testar_asteroide             ; verifica se o asteroide ja excedeu o ecra e se exceder vai apagalo, retorna um valor se o tiver apagado
    CMP R8, 0                         ; se for 0 entao apagou o asteroide
    JZ  pa_pagar_asteroide                        ; se é para apagar o asteroide ent vai dar retorna R1 = 0
    MOV R9, 1
    CALL escrever_asteroide   
    CALL encriptar_asteroide    ; R1 tem o valor do asteroide encriptado com a nova posicao
    JMP pa_fim
pa_pagar_asteroide:
    MOV R1, 0
pa_fim: 
    POP R9
    POP R8
    POP R7
    POP R6
    POP R5
    POP R4
    POP R3
    POP R2
    POP R0
    RET

testar_asteroide:       ; rotina para verificar se um asteroide passou os limites do ecra ou colidiu
    ; R8 - posicao de memoria do asteroide em questao
    ; R1 - linha
    ; R2 - coluna
    ; R3 - tamanho
    ; R0 - tipo de asteroide
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R7
    MOV R5, R8
    CALL testar_colisao    ; retorna R8 = a posicao (na memoria) do missil intercetado, R8 = 0 se nao colidiu com missil
    CMP R8, 0    
    JEQ testar_saiu_ecra
    MOV R5, R8              ; input apagar_misil
    CALL apagar_missil_tabela  
    MOV R4, asteroide_destruido_string
    CALL ler_imagem             ; escreve no ecra e nas coordenadas especificas, o asteroide destruido
    MOV R8, asteroide_destruido
    CALL encriptar_asteroide    ; r1 tem agora as coordenadas em hexa do asteroide destruido
    MOV [R8], R1
    JMP ta_apagar_asteroide     ; vai dar flag de apagar o asteroide
testar_saiu_ecra:               ; se o asteroide nao colideiu com o missil entao vai verifica se colidiu com a nave ou com ja saiu do ecra
    MOV R8, 1                   ; ainda nao sabe se vai ou nao apgar o missil
    ADD R1, R3
    MOV R4, 0
    CMP R2, R4
    JLT ta_apagar_asteroide
    MOV R4, 31
    ADD R2, R3
    CMP R2, R4
    JGE ta_apagar_asteroide
    MOV R4, linha_colisao_nave
    CMP R1, R4
    JLT ta_nao_apagar_asteroide

    ; se chegar aqui colidiu com a nave
    MOV R1, flag_pontuacao
    CMP R0, 0
    JZ  ta_asteroide_inimigo
    MOV R3, 1
    MOV [R1], R3  
    JMP ta_apagar_asteroide
ta_asteroide_inimigo:
    MOV R3, -1
    MOV [R1], R3
ta_apagar_asteroide:
    MOV R8, 0                   ; "flag" de que o asteroide vai ser apagado
ta_nao_apagar_asteroide:
    POP R7
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    RET

; rotina que interpreta a linha do asteroide e verifica se é ou nao para aumentar o seu tamannho
calcular_aumento_tamanho:
    ; R1 linha
    ; R3 tamanho
    PUSH R1
    PUSH R2
    PUSH R4
    MOV R2, tamanho_max_asteroides
    CMP R3, R2 
    JEQ ct_nao_aumentar  ; se o tamanho do asteroide ja tiver o maximo nao aumenta
    MOV R2, 2   ; aumentar de tamanho de 3 em 3 linhas
    MOD R1, R2
    JNZ ct_nao_aumentar
    ADD R3, 1   ; se for 0 entao aumenta o tamanho dos asteroides em 1
ct_nao_aumentar:
    POP R4
    POP R2
    POP R1
    RET

processar_estado_movimento:         ; controla para onde vai virar o asteroide e retorna as novas informacoes dele
    ; R1 - linha
    ; R2 - coluna
    ; R3 - tamamho e posicao e index tabela de posicoes
    ; R7 - fila (meio direita esquerda)
    PUSH R8    
    PUSH R9
    MOV R8, movimento_asteroides_estado
    MOV R8, [R8]
    CMP R8, 0
    JEQ pme_frente  ; se for 0 vai so andar para a frente
    CMP R8, 0
    JGT pme_esquerda ; vai virar o asteroide para a direita (se for mair que 0)
    ; aqui vira para a direita (caso em q R8 menor que 0) 
    SUB R2, R8      ; o aseteroide vai se mover R3 pixeis para a direita  
    JMP pme_frente
pme_esquerda:
    SUB R2, R8      ; o aseteroide vai se mover R3 pixeis para a esquerda 
pme_frente:
    MOV R9, somador_asteroides_frente
    ADD R1, R9       ; x linhas para a frente
    CALL calcular_aumento_tamanho
nao_aumentar_tamanho:
    CMP R7, 0       ; ver em que fila esta a andar o asteroide (0- direita 1- meio 2- esquerda)
    JNE pme_testar_direita ; anda para a esquerda aqui
    ADD R2, 1       ; numero de colunas para a direita
pme_testar_direita:   ; anda para a direita aqui
    CMP R7, 2       ; 2 e a da direita
    JNE pme_fim
    SUB R2, 1        ; numero de colunas para a esquerda
pme_fim:
    POP R9
    POP R8
    RET

; rotina que testa se o asteroide colidiu com o missil, retorna R8
testar_intercecao:  ; R1, R2 posicao asteroide col, lin R3, tamanhos asteroide, R5 enderço missil
    PUSH R1   
    PUSH R2
    PUSH R3   ; tamanho do asteroide
    PUSH R4
    PUSH R5
    SUB R5, 2               ; R5 aqui e o proximo elemento e nao o presente
    SWAP R2, R4 ; e necessario que o valor hexa do missil esteja em r2 para usar a rotina retorna coordenda
    MOV R8, R1  ; a rotina retorna coordenada usa o registo r1 tambem
    ; R4- coluna asteroide
    ; R8- linha asteroide
    CALL retorna_coordenada
    ; R1 - linha missil
    ; R2 - coluna missil
    CMP R1, R8
    JLT ti_fim   ;  se a linha do missil for menor q a do asteroide n ha colisao
    CMP R2, R4
    JLT ti_fim   ;  se a coluna do missil for menor q a do asteroide n ha colisao
    ADD R4, R3
    CMP R2, R4
    JGT ti_fim   ;  se a linha do missil for maior q a do asteroide + o seu tamanho n ha colisao
    ADD R8, R3
    CMP R1, R8
    JGT ti_fim   ;  se a coluna do missil for maior q a do asteroide + o seu tamanho n ha colisao 
ti_processar_colisao:
    MOV R8, R5               ; flag de que o asteroide vai ser apagado
    JMP ti_nao_reset
ti_fim:
    MOV R8, 0               ; so vem para aqui se nao colidiu com missil
ti_nao_reset:
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    RET

; testa as colisoes do asteroide com o missil
testar_colisao:
    PUSH R1   ; input linha asteroide
    PUSH R2   ; input coluna asteroide
    PUSH R3   ; tamanho do asteroide
    PUSH R4
    PUSH R5
    PUSH R6
    MOV R8, 0 ; reset do output
    MOV R5, tabela_misseis
    MOV R6, numero_maximo_misseis
    MOV R4, 2
    MUL R6, R4
    ADD R6, R5
    SUB R6, 2   ; R6 e o ultimo elemento da tabela dos misseis
tc_prox:
    CMP R5, R6
    JGT tc_fim      ; quando R5 for mais que R6 entao acaba a iteracao
    MOV R4, [R5]    
    ADD R5, 2       ; prox elemento da tabela de misseis
    CMP R6, 0
    JZ tc_prox      ; quando o missil existe
    CALL testar_intercecao
tc_fim:
    POP R6
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    RET

; *********************************************************************************
; * Gestao de interrupcoes
; *********************************************************************************

rot_int_0_missil:
    PUSH R3
    PUSH R4
    MOV R4, 1
    MOV R3, mover_missil_estado
    MOV [R3], R4     ; esta na hora de mover o missil
    POP R4
    POP R3
    RFE

rot_int_1_asteroides:
    PUSH R3
    PUSH R4
    MOV R4, 1
    MOV R3, mover_asteroides_estado
    MOV [R3], R4     ; esta na hora de mover os asteroides
    MOV R3, flag_mover_asteroides
    MOV [R3], R4     ; flag para atualizar o multiplicador de posicoes
    MOV R3, novo_asteroide_flag
    MOV R4, [R3]
    ADD R4, 1
    MOV [R3], R4
    POP R4
    POP R3
    RFE



; *********************************************************************************
; * Fim de Codigo
; *********************************************************************************
