		.module subrutinaswordle
		
fin		.equ 0xFF01
teclado	.equ 0xFF02
pantalla	.equ 0xFF00
pu		.equ 0xE000
ps		.equ 0xF000
intento_actual: .byte 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
palabra: 	.asciz '     '
palabra_s: 	.asciz "MOSCA"	
palabra_mal:	.asciz "\nLa palabra NO esta en el diccionario.\n"
palabra_bien:   .asciz "\nLa palabra esta en el diccionario.\n"
booleano:	.byte 0

seleccionar: 	.asciz "\nPulse m para volver al menu y r para reiniciar.\n"
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
espacio: 	.byte 32
interrog: 	.byte 63

mensaje_falloo:  .asciz  "CAGASTE WEY\n" 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Variables para guardar cada intento de la palabra
palabra1:  	.asciz "     "
barra: 		.asciz " | "
barra1: 	.asciz "    | "

mensaje_vuelta: .asciz ""
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
	.globl inicio
	.globl wordle
	.globl juego
	.globl acabar
menujogo:
	.ascii "\33[2J\33[H" ;Limpia la pantalla y pone el cursor arriba.
	.ascii "\n     | JUEGO |\n"
	.ascii "--------------\n"
	.ascii "     | 12345 |\n"
	.asciz "--------------\n"
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
	cmpb #'v
	beq salta
	cmpb #'r
	beq reinicia
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
salta:
    jsr wordle
    rts
reinicia:
    ldb #0
    stb intento_actual
    jsr juego
    rts
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
	;ldx #palabra_bien
	;jsr imprime_cadena
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

;Palabra 1
inicio:
   ldb #'\n
   stb pantalla
   ldb intento_actual
   addb #49
   cmpb #'6
   beq mensaje_fallo
   stb pantalla
   ldx #barra1
   jsr imprime_cadena
   ldx #palabra  ;Cadena leida
   ldy #palabra1 ;String Vacia
copiar: ;Esta wea copia
   lda ,x+  ;Carga en a el elemento de x
   sta ,y+  ;Almacena en y lo que halla en A
   cmpa #'\0  ; Lo comparas con el final
   beq reiniciar_ptr ;Si es igual, es q la copia ha finalizado y los ptrs se reinician.
   bra copiar ;Sino, q siga copiando
reiniciar_ptr:
	ldx #palabra_s
	ldy #palabra1
comparaciones:
	lda ,x+ ;Compara                     
	cmpa #'\0
	beq final_w1
	cmpa ,y+
	beq pos_correcta
	bne otra_pos
pos_correcta:
	sta pantalla
	bra comparaciones
otra_pos:
	cmpa ,y+
	beq  escribe_otra_pos
	cmpa #'\0
	beq  no_esta
	bra otra_pos
escribe_otra_pos:
	ldb interrog
	stb pantalla
	bra comparaciones
no_esta:
	ldb espacio
	stb pantalla
	bra comparaciones
final_w1:
	ldx #barra
	jsr imprime_cadena
	inc intento_actual
	rts
mensaje_fallo:
	ldx #mensaje_falloo
	jsr imprime_cadena
	bra elegir
elegir:
	ldx #elegir
	jsr imprime_cadena
	ldb teclado
	cmpb #'m
	jmp salta
	cmpb #'r
	jmp reinicia
	bra elegir