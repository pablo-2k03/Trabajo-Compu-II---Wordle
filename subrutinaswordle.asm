		.module subrutinaswordle
		
fin		.equ 0xFF01
teclado	.equ 0xFF02
pantalla	.equ 0xFF00
pu		.equ 0xE000
ps		.equ 0xF000
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
palabra: 	.asciz '     '
palabra_s: 	.asciz "MOSCA"	
palabra_mal:	.asciz "\nLa palabra NO esta en el diccionario.\n"
booleano:	.byte 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
espacio: 	.asciz " "
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Variables para guardar cada intento de la palabra
palabra1:  	.asciz "     "
palabra2:  	.asciz "     "
palabra3:  	.asciz "     "
palabra4:  	.asciz "     "
palabra5:  	.asciz "     "
palabra6: 	.asciz "     "
barra: 	.asciz " | "
;;;;;;;;;;;;;;;;;;;;;;;;;    Variables Globales ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.globl imprime_cadena
	.globl contador
	.globl palabras
	.globl lee_cadena_n
	.globl convertir
	.globl incrementa_a
	.globl salir_bucle
	.globl comprueba
	.globl pedir_palabra
	.globl imprime_filas
	.globl lp_carga
	.globl lp_carga2
	.globl lp_carga3
	.globl lp_carga4
	.globl lp_carga5
	.globl lp_carga6
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	Subrutina: Imprime cadena						  ;
;	Funcionamiento: Imprime una cadena leida por teclado o ya establecida. ;  
;	Registros Afectados: CC						  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
imprime_cadena:
	pshu a,x
	
ic_sgte:
	lda ,x+
	beq ret_imprime_cadena
	sta pantalla
	bra ic_sgte

ret_imprime_cadena:
	pulu a,x
	rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	Subrutina: Contador de palabras					  ;
;	Funcionamiento: Cuenta el numero de palabras en diccionario. 	  ;  
;	Registros Afectados: B,CC						  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		
contador:
	pshu a,x
	clrb
	bra incrementa_contador
incrementa_b:
	incb
	bra incrementa_contador
incrementa_contador:
	lda ,x+
	cmpa #'\0
	beq retorno_contador
	cmpa #'\n
	beq incrementa_b
	bra incrementa_contador
retorno_contador:
	pulu a,x
	rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	Subrutina: convertir (contador palabras diccionario)			  ;
;	Funcionamiento: Vamos restando el registro B y a su vez incrementando a;
;	Registros Afectados: A,B,CC.						  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
convertir:
	cmpb #10
	bge incrementa_a 
	bra salir_bucle
incrementa_a:
	inca
	subb #10
	bra convertir
salir_bucle:
	adda #48
	addb #48
	rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				LCN MAX 					;
;										;
;   Le pasamos el numero a leer antes de llamar a la funcion.		;
;   Cargamos la pila con b, testeamos a, si es igual a 0 se devuelve		;
;   sino, guarda lcn_max en a y limpia a					;
;										;
;   Lemos la cadena y comparamos con el \n, si es 0 se acaba y sino vuelve   ;  
;   a leer.									;
;  										;
;   Registros Afectados: A y CC						;
;										;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
lcn_max: .byte 0

lee_cadena_n:
	pshs b
	ldx #palabra
	tsta
	beq lcn_retorno
	deca
	sta lcn_max
	clra
lcn_lectura:
	cmpa lcn_max
	bhs  lcn_finlecturan
	ldb teclado
	cmpb #32
	beq quita_anterior
	cmpb #65 		;Comparamos con el codigo ascii 65
	blo lcn_limpia		; Si es menor, limpia, porque el codigo ascii 65 es la A
	cmpb #90		;Comparamos con el ascii 90	
	bls sig		; Si es menor, son mayusculas, asi q sigue
	cmpb #97		;Del 90 al 97 hay caracteres q no nos interesan, asi q limpia
	blo lcn_limpia
	cmpb #123		;Si es superior que 123 limpia, y sino convierte
	bhs lcn_limpia
	blo lcn_convierte
sig:
	stb, x+
	cmpb #'\n
	beq lcn_finlectura
	inca
	bra lcn_lectura
quita_anterior:
	ldb #8
	stb pantalla
	stb pantalla
	deca				; Decrementamos el contador para que nos deje re-escribir la palabra
	bra lcn_lectura
lcn_convierte:

	pshu b				;Lo metemos en la pila para no perder el valor.
	ldb #8				;El cursor apunta al anterior.
	stb pantalla
	pulu b				;Lo sacamos de la pila
	subb #32			;Le resta 32 al ascii cargado en b
	stb pantalla			;Saca por pantalla y sigue
	bra sig
	
lcn_limpia:
	ldb #8
	stb pantalla
	bra lcn_lectura
lcn_finlectura:
	clr ,-x			;Borra la posicion siguiente 
	bra lcn_retorno

lcn_finlecturan:
	clr ,x

lcn_retorno:
	puls b
	rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;      Generador Palabra		   ;
; Cargamos la pila y cargamos d con palabras
; metes d dentro de la pila para q el primer caracter
;entre en la pila, añades 1 para q vaya metiendo;
;					    
					   
					    ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

generar:
	lds ps
	ldd #palabras
	pshs d
	addd #1
	cmpd #'\n
	beq g_acabar
	bra generar
g_acabar: 
	rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				Comprueba palabra				;
;										;
;   Subrutina: Comprueba palabra diccionario					;
;   										;
;   Funcionamiento: Comprueba si la palabra introducida por el usuario	;
;   se encuentra en el diccionario o no					;
;										;  
;   Registros Afectados: X,Y y CC						;
;  										;
;   										;
;										;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


comprueba:
	ldx #palabras ;Cargamos en X la direccion donde estan las palabras
	ldy #palabra
sig_palabra:
	lda ,x+ ; Cargamos en a el siguiente caracter de x
	cmpa ,y+ ;Comparamos a con el siguiente caracter de y
	beq sig_palabra; Si es igual, que vuelva a hacer lo mismo.
	cmpa #'\n 
	beq comprueba_final_b ; Llamamos a comprueba_final_b e indicamos q la palabra esta en el diccionario.
avanza_palabra:
	lda ,x+ ;Avanzamos a hasta q lleguemos al \n
	ldy #palabra ;Reiniciamos y
	cmpa #'\n ;SI es igual, volvemos al bucle de comprobar los caracteres
	beq sig_palabra
	cmpa #'\0
	beq comprueba_final_m
	bra avanza_palabra
comprueba_final_b:
	;jsr juego
	rts
comprueba_final_m:
	ldx #palabra_mal
	jsr imprime_cadena
	jsr pedir_palabra
	rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;										;
;										;
;			Lógica del Juego					;
;										;
;	Tenemos un tablero, que en la primera iteracion va a estar vacio	;
; 	y vamos a ir guardando cada palabra en una variable, le aplicamos	;
;	la logica para los colores, y luego mediante un bucle, vamos sacando	;
;	cada fila (cada palabra) ya con los colores				;
;										;
;										;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;		0-Verde 1-Amarillo 2-Rojo 3-Blanco				;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Palabra 1
lpi:
	bra imprime_inicio
lp_carga:
	ldy #palabra_s
	ldx #palabra1
logica_principal:
	lda ,x+
	cmpa #'\0
	beq lp_fin
	cmpa ,y+	
	beq lp_bien
	bne lp_comp
lp_bien:
	jsr imprime_cadena
	sta pantalla
lp_comp:
	cmpa ,y+
	beq lp_estan
	cmpy #'\0
	beq lp_mal
	bra lp_comp
lp_estan:
	ldx #'?
	jsr imprime_cadena
	bra lp_carga
lp_mal:
	lda #espacio
	sta pantalla
	bra lp_carga 
lp_fin:
	rts
imprime_inicio:
	lda #1
	sta pantalla
	ldx #barra
	jsr imprime_cadena
	bra lp_carga
;Palabra 2
lpi2:
	bra imprime_inicio
lp_carga2:
	ldy #palabra_s
	ldx #palabra2
logica_principal2:
	lda ,x+
	cmpa #'\0
	beq lp_fin2
	cmpa ,y+	
	beq lp_bien2
	bne lp_comp2
lp_bien2:
	jsr imprime_cadena
	sta pantalla
lp_comp2:
	cmpa ,y+
	beq lp_estan2
	cmpy #'\0
	beq lp_mal2
	bra lp_comp2
lp_estan2:
	ldx #'?
	jsr imprime_cadena
	bra lp_carga2
lp_mal2:
	lda #espacio
	sta pantalla
	bra lp_carga2 
lp_fin2:
	rts
imprime_inicio2:
	lda #2
	sta pantalla
	ldx #barra
	jsr imprime_cadena
	bra lp_carga2
;Palabra 3
lpi3:
	bra imprime_inicio3
lp_carga3:
	ldy #palabra_s
	ldx #palabra3
logica_principal3:
	lda ,x+
	cmpa #'\0
	beq lp_fin3
	cmpa ,y+	
	beq lp_bien3
	bne lp_comp3
lp_bien3:
	jsr imprime_cadena
	sta pantalla
lp_comp3:
	cmpa ,y+
	beq lp_estan3
	cmpy #'\0
	beq lp_mal3
	bra lp_comp3
lp_estan3:
	ldx #'?
	jsr imprime_cadena
	bra lp_carga3
lp_mal3:
	lda #espacio
	sta pantalla
	bra lp_carga3 
lp_fin3:
	rts
imprime_inicio3:
	lda #3
	sta pantalla
	ldx #barra
	jsr imprime_cadena
	bra lp_carga3
;Palabra 4
lpi4:
	bra imprime_inicio4
lp_carga4:
	ldy #palabra_s
	ldx #palabra4
logica_principal4:
	lda ,x+
	cmpa #'\0
	beq lp_fin4
	cmpa ,y+	
	beq lp_bien4
	bne lp_comp4
lp_bien4:
	jsr imprime_cadena
	sta pantalla
lp_comp4:
	cmpa ,y+
	beq lp_estan4
	cmpy #'\0
	beq lp_mal4
	bra lp_comp4
lp_estan4:
	ldx #'?
	jsr imprime_cadena
	bra lp_carga4
lp_mal4:
	lda #espacio
	sta pantalla
	bra lp_carga4
lp_fin4:
	rts
imprime_inicio4:
	lda #4
	sta pantalla
	ldx #barra
	jsr imprime_cadena
	bra lp_carga4
;Palabra 5
lpi5:
	bra imprime_inicio5
lp_carga5:
	ldy #palabra_s
	ldx #palabra5
logica_principal5:
	lda ,x+
	cmpa #'\0
	beq lp_fin5
	cmpa ,y+	
	beq lp_bien5
	bne lp_comp5
lp_bien5:
	jsr imprime_cadena
	sta pantalla
lp_comp5:
	cmpa ,y+
	beq lp_estan5
	cmpy #'\0
	beq lp_mal5
	bra lp_comp5
lp_estan5:
	ldx #'?
	jsr imprime_cadena
	bra lp_carga5
lp_mal5:
	lda #espacio
	sta pantalla
	bra lp_carga5 
lp_fin5:
	rts
imprime_inicio5:
	lda #5
	sta pantalla
	ldx #barra
	jsr imprime_cadena
	bra lp_carga5
;Palabra 6
lpi6:
	bra imprime_inicio
lp_carga6:
	ldy #palabra_s
	ldx #palabra6
logica_principal6:
	lda ,x+
	cmpa #'\0
	beq lp_fin6
	cmpa ,y+	
	beq lp_bien6
	bne lp_comp6
lp_bien6:
	jsr imprime_cadena
	sta pantalla
lp_comp6:
	cmpa ,y+
	beq lp_estan6
	cmpy #'\0
	beq lp_mal6
	bra lp_comp6
lp_estan6:
	ldx #'?
	jsr imprime_cadena
	bra lp_carga6
lp_mal6:
	lda #espacio
	sta pantalla
	bra lp_carga6 
lp_fin6:
	rts
imprime_inicio6:
	lda #6
	sta pantalla
	ldx #barra
	jsr imprime_cadena
	bra lp_carga6
