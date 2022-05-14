			.module wordle
;+----------------------------------------------+
;                      WORDLE  	  	  ;
; 	¬Pablo Agüera Hernández  		  ;
; 	¬Eduardo Juanes Ramos    		  ;
;+----------------------------------------------+
fin		.equ 0xFF01
teclado 	.equ 0xFF02
pantalla	.equ 0xFF00		
pu		.equ 0xF000
ps		.equ 0xB000


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
menu: 	
	.ascii "\33[2J\33[H" ;Limpia la pantalla y pone el cursor arriba.
	.ascii	"\n+-----------------------------+\n"
	.ascii	"|           WORDLE            |\n"
	.ascii	"+-----------------------------+\n"
	.ascii  "1) VER DICCIONARIO\n"
	.ascii  "2) JUGAR\n"
	.ascii  "3) SALIR\n"
	.asciz "\nIntroduzca una opcion: "
menujogo:
	.ascii "\33[2J\33[H" ;Limpia la pantalla y pone el cursor arriba.
	.ascii "\n     | JUEGO |\n"
	.ascii "--------------\n"
	.ascii "     | 12345 |\n"
	.asciz "--------------\n"
int_palabra:
	.asciz "\nIntroduzca la palabra: "

err:
	.asciz "\nError, valor introducido no valido, introduzca un nuevo valor."

			.globl wordle
			.globl imprime_cadena
			.globl palabras
			.globl numero_palabras
			.globl return_c
			.globl lee_cadena_n
			.globl presentar_diccionario
			.globl comprueba
			.globl pedir_palabra
			.globl imprime_filas
			.globl lp_carga
			.globl lp_carga2
			.globl lp_carga3
			.globl lp_carga4
			.globl lp_carga5
			.globl lp_carga6
wordle:
	lds #ps
	ldu #pu
	ldx #menu
	jsr imprime_cadena		

opcion:
	lda teclado
	cmpa #'1
	beq diccionario
	cmpa #'2
	beq juego
	cmpa #'3
	beq acabar
	bra error
	
diccionario:
	ldx #presentar_diccionario
	jsr imprime_cadena
	ldx #palabras
	jsr imprime_cadena
	jsr return_c
	lda teclado	;Como system("pause") de C, hasta q no meta nada por teclado no avanza.
	bra wordle
error:
	ldx #err
	jsr imprime_cadena
	bra opcion

juego:
	ldx #menujogo
	jsr imprime_cadena
	jsr pedir_palabra
pedir_palabra:
	ldx #int_palabra
	jsr imprime_cadena
	lda #6	;Numero maximo de caracteres q pueden introducir(n-1)
	jsr lee_cadena_n
	jsr comprueba
	jsr lp_carga
	jsr lee_cadena_n
	jsr comprueba
	jsr lp_carga2
	jsr lee_cadena_n
	jsr comprueba
	jsr lp_carga3
	jsr lee_cadena_n
	jsr comprueba
	jsr lp_carga4
	jsr lee_cadena_n
	jsr comprueba
	jsr lp_carga5
	jsr lee_cadena_n
	jsr comprueba
	jsr lp_carga6
acabar:
	clra
	sta fin
		
		.area FIJA(ABS)
		
		.org 0xFFFE
		.word wordle
