ASxxxx Assembler V05.00  (Motorola 6809), page 1.
Hexidecimal [16-Bits]



                              1 		.module subrutinaswordle
                              2 		
                     FF01     3 fin		.equ 0xFF01
                     FF02     4 teclado	.equ 0xFF02
                     FF00     5 pantalla	.equ 0xFF00
                     E000     6 pu		.equ 0xE000
                     F000     7 ps		.equ 0xF000
   01CC 00                    8 intento_actual: .byte 0
                              9 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   01CD 20 20 20 20 20 00    10 palabra: 	.asciz '     '
                             11 
   01D3 00                   12 num_palabra: 	.byte 0
   01D4 20 20 20 20 20 00    13 palabra_s: 	.asciz "     "	
   01DA 0A 4C 61 20 70 61    14 palabra_mal:	.asciz "\nLa palabra NO esta en el diccionario.\n"
        6C 61 62 72 61 20
        4E 4F 20 65 73 74
        61 20 65 6E 20 65
        6C 20 64 69 63 63
        69 6F 6E 61 72 69
        6F 2E 0A 00
   0202 0A 4C 61 20 70 61    15 palabra_bien:   .asciz "\nLa palabra esta en el diccionario.\n"
        6C 61 62 72 61 20
        65 73 74 61 20 65
        6E 20 65 6C 20 64
        69 63 63 69 6F 6E
        61 72 69 6F 2E 0A
        00
   0227 00                   16 contador_bien:	.byte 0
   0228 00                   17 total_palabras: 	.byte 0
   0229 0A 50 75 6C 73 65    18 seleccionar: 	.asciz "\nPulse m para volver al menu y r para reiniciar.\n"
        20 6D 20 70 61 72
        61 20 76 6F 6C 76
        65 72 20 61 6C 20
        6D 65 6E 75 20 79
        20 72 20 70 61 72
        61 20 72 65 69 6E
        69 63 69 61 72 2E
        0A 00
                             19 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   025B 20                   20 espacio: 	.byte 32
   025C 3F                   21 interrog: 	.byte 63
   025D 0A 45 4E 48 4F 52    22 cad_acierto: 	.asciz "\nENHORABUENA! Acertaste la palabra.\n"
        41 42 55 45 4E 41
        21 20 41 63 65 72
        74 61 73 74 65 20
        6C 61 20 70 61 6C
        61 62 72 61 2E 0A
        00
   0282 0A 0A 53 65 20 74    23 mensaje_falloo:  .asciz  "\n\nSe te acabaron los intentos!\n" 
        65 20 61 63 61 62
        61 72 6F 6E 20 6C
        6F 73 20 69 6E 74
        65 6E 74 6F 73 21
        0A 00
                             24 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ASxxxx Assembler V05.00  (Motorola 6809), page 2.
Hexidecimal [16-Bits]



                             25 ;Variables para guardar cada intento de la palabra
   02A2 20 20 20 20 20 00    26 palabra1:  	.asciz "     "
   02A8 20 7C 20 00          27 barra: 		.asciz " | "
   02AC 20 20 20 20 7C 20    28 barra1: 	.asciz "    | "
        00
                             29 
   02B3 00                   30 mensaje_vuelta: .asciz ""
                             31 ;;;;;;;;;;;;;;;;;;;;;;;;;    Variables Globales ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                             32 	.globl imprime_cadena
                             33 	.globl contador
                             34 	.globl palabras
                             35 	.globl lee_cadena_n
                             36 	.globl convertir
                             37 	.globl incrementa_a
                             38 	.globl salir_bucle
                             39 	.globl comprueba
                             40 	.globl pedir_palabra
                             41 	.globl inicio
                             42 	.globl wordle
                             43 	.globl juego
                             44 	.globl acabar
                             45 	.globl mensaje_fallo
                             46 	.globl inicio2
                             47 	.globl inicio_genera
   02B4                      48 menujogo:
   02B4 1B 5B 32 4A 1B 5B    49 	.ascii "\33[2J\33[H" ;Limpia la pantalla y pone el cursor arriba.
        48
   02BB 0A 20 20 20 20 20    50 	.ascii "\n     | BIEN | ESTAN |\n"
        7C 20 42 49 45 4E
        20 7C 20 45 53 54
        41 4E 20 7C 0A
   02D2 2D 2D 2D 2D 2D 2D    51 	.ascii "--------------\n"
        2D 2D 2D 2D 2D 2D
        2D 2D 0A
   02E1 20 20 20 20 20 7C    52 	.ascii "     | 12345 |\n"
        20 31 32 33 34 35
        20 7C 0A
   02F0 2D 2D 2D 2D 2D 2D    53 	.asciz "--------------\n"
        2D 2D 2D 2D 2D 2D
        2D 2D 0A 00
                             54 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                             55 ;	Subrutina: Imprime cadena						  ;
                             56 ;	Funcionamiento: Imprime una cadena leida por teclado o ya establecida. ;  
                             57 ;	Registros Afectados: CC						  ;
                             58 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
   0300                      59 imprime_cadena:
   0300 36 12         [ 7]   60 	pshu a,x
                             61 	
   0302                      62 ic_sgte:
   0302 A6 80         [ 6]   63 	lda ,x+
   0304 27 05         [ 3]   64 	beq ret_imprime_cadena
   0306 B7 FF 00      [ 5]   65 	sta pantalla
   0309 20 F7         [ 3]   66 	bra ic_sgte
                             67 
   030B                      68 ret_imprime_cadena:
ASxxxx Assembler V05.00  (Motorola 6809), page 3.
Hexidecimal [16-Bits]



   030B 37 12         [ 7]   69 	pulu a,x
   030D 39            [ 5]   70 	rts
                             71 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                             72 ;	Subrutina: Contador de palabras					  ;
                             73 ;	Funcionamiento: Cuenta el numero de palabras en diccionario. 	  ;  
                             74 ;	Registros Afectados: B,CC						  ;
                             75 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		
   030E                      76 contador:
   030E 36 12         [ 7]   77 	pshu a,x
   0310 5F            [ 2]   78 	clrb
   0311 20 03         [ 3]   79 	bra incrementa_contador
   0313                      80 incrementa_b:
   0313 5C            [ 2]   81 	incb
   0314 20 00         [ 3]   82 	bra incrementa_contador
   0316                      83 incrementa_contador:
   0316 A6 80         [ 6]   84 	lda ,x+
   0318 81 00         [ 2]   85 	cmpa #'\0
   031A 27 06         [ 3]   86 	beq retorno_contador
   031C 81 0A         [ 2]   87 	cmpa #'\n
   031E 27 F3         [ 3]   88 	beq incrementa_b
   0320 20 F4         [ 3]   89 	bra incrementa_contador
   0322                      90 retorno_contador:
   0322 F7 02 28      [ 5]   91 	stb total_palabras
   0325 37 12         [ 7]   92 	pulu a,x
   0327 39            [ 5]   93 	rts
                             94 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                             95 ;	Subrutina: convertir (contador palabras diccionario)			  ;
                             96 ;	Funcionamiento: Vamos restando el registro B y a su vez incrementando a;
                             97 ;	Registros Afectados: A,B,CC.						  ;
                             98 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   0328                      99 convertir:
   0328 C1 0A         [ 2]  100 	cmpb #10
   032A 2C 02         [ 3]  101 	bge incrementa_a 
   032C 20 05         [ 3]  102 	bra salir_bucle
   032E                     103 incrementa_a:
   032E 4C            [ 2]  104 	inca
   032F C0 0A         [ 2]  105 	subb #10
   0331 20 F5         [ 3]  106 	bra convertir
   0333                     107 salir_bucle:
   0333 8B 30         [ 2]  108 	adda #48
   0335 CB 30         [ 2]  109 	addb #48
   0337 39            [ 5]  110 	rts
                            111 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                            112 ;				LCN MAX 					;
                            113 ;										;
                            114 ;   Le pasamos el numero a leer antes de llamar a la funcion.		;
                            115 ;   Cargamos la pila con b, testeamos a, si es igual a 0 se devuelve		;
                            116 ;   sino, guarda lcn_max en a y limpia a					;
                            117 ;										;
                            118 ;   Lemos la cadena y comparamos con el \n, si es 0 se acaba y sino vuelve   ;  
                            119 ;   a leer.									;
                            120 ;  										;
                            121 ;   Registros Afectados: A y CC						;
                            122 ;										;
                            123 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ASxxxx Assembler V05.00  (Motorola 6809), page 4.
Hexidecimal [16-Bits]



   0338 00                  124 lcn_max: .byte 0
                            125 
   0339                     126 lee_cadena_n:
   0339 34 04         [ 6]  127 	pshs b
   033B 8E 01 CD      [ 3]  128 	ldx #palabra
   033E 4D            [ 2]  129 	tsta
   033F 27 73         [ 3]  130 	beq lcn_retorno
   0341 4A            [ 2]  131 	deca
   0342 B7 03 38      [ 5]  132 	sta lcn_max
   0345 4F            [ 2]  133 	clra
   0346                     134 lcn_lectura:
   0346 B1 03 38      [ 5]  135 	cmpa lcn_max
   0349 24 67         [ 3]  136 	bhs  lcn_finlecturan
   034B F6 FF 02      [ 5]  137 	ldb teclado
   034E C1 76         [ 2]  138 	cmpb #'v
   0350 27 1A         [ 3]  139 	beq salta
   0352 C1 72         [ 2]  140 	cmpb #'r
   0354 27 1F         [ 3]  141 	beq reinicia
   0356 C1 20         [ 2]  142 	cmpb #32
   0358 27 30         [ 3]  143 	beq quita_anterior
   035A C1 41         [ 2]  144 	cmpb #65 		;Comparamos con el codigo ascii 65
   035C 25 49         [ 3]  145 	blo lcn_limpia		; Si es menor, limpia, porque el codigo ascii 65 es la A
   035E C1 5A         [ 2]  146 	cmpb #90		;Comparamos con el ascii 90	
   0360 23 1F         [ 3]  147 	bls sig		; Si es menor, son mayusculas, asi q sigue
   0362 C1 61         [ 2]  148 	cmpb #97		;Del 90 al 97 hay caracteres q no nos interesan, asi q limpia
   0364 25 41         [ 3]  149 	blo lcn_limpia
   0366 C1 7B         [ 2]  150 	cmpb #123		;Si es superior que 123 limpia, y sino convierte
   0368 24 3D         [ 3]  151 	bhs lcn_limpia
   036A 25 2B         [ 3]  152 	blo lcn_convierte
   036C                     153 salta:
   036C C6 00         [ 2]  154     ldb #0			;Reiniciamos el contador de los intentos
   036E F7 01 CC      [ 5]  155     stb intento_actual		;Y lo guardamos en la var q hemos creado
   0371 BD 01 65      [ 8]  156     jsr wordle			;Volvemos al menu
   0374 39            [ 5]  157     rts
   0375                     158 reinicia:
   0375 C6 00         [ 2]  159     ldb #0			;Reiniciamos el contador de los intentos
   0377 F7 01 CC      [ 5]  160     stb intento_actual	
   037A BD 03 B7      [ 8]  161     jsr inicio_genera	;Lo guardamos en los intentos
   037D BD 01 A2      [ 8]  162     jsr juego			;Reiniciamos juego
   0380 39            [ 5]  163     rts
   0381                     164 sig:
   0381 E7 80         [ 6]  165 	stb, x+
   0383 C1 0A         [ 2]  166 	cmpb #'\n
   0385 27 27         [ 3]  167 	beq lcn_finlectura
   0387 4C            [ 2]  168 	inca
   0388 20 BC         [ 3]  169 	bra lcn_lectura
   038A                     170 quita_anterior:
   038A C6 08         [ 2]  171 	ldb #8
   038C F7 FF 00      [ 5]  172 	stb pantalla
   038F F7 FF 00      [ 5]  173 	stb pantalla
   0392 30 1F         [ 5]  174 	leax -1,x			; Decrementamos el puntero para ponernos en el caracter de atrás
   0394 4A            [ 2]  175 	deca				; Decrementamos el contador para que nos deje re-escribir la palabra
   0395 20 AF         [ 3]  176 	bra lcn_lectura
   0397                     177 lcn_convierte:
                            178 
ASxxxx Assembler V05.00  (Motorola 6809), page 5.
Hexidecimal [16-Bits]



   0397 36 04         [ 6]  179 	pshu b				;Lo metemos en la pila para no perder el valor.
   0399 C6 08         [ 2]  180 	ldb #8				;El cursor apunta al anterior.
   039B F7 FF 00      [ 5]  181 	stb pantalla
   039E 37 04         [ 6]  182 	pulu b				;Lo sacamos de la pila
   03A0 C0 20         [ 2]  183 	subb #32			;Le resta 32 al ascii cargado en b
   03A2 F7 FF 00      [ 5]  184 	stb pantalla			;Saca por pantalla y sigue
   03A5 20 DA         [ 3]  185 	bra sig
                            186 	
   03A7                     187 lcn_limpia:
   03A7 C6 08         [ 2]  188 	ldb #8
   03A9 F7 FF 00      [ 5]  189 	stb pantalla
   03AC 20 98         [ 3]  190 	bra lcn_lectura
   03AE                     191 lcn_finlectura:
   03AE 6F 82         [ 8]  192 	clr ,-x			;Borra la posicion siguiente 
   03B0 20 02         [ 3]  193 	bra lcn_retorno
                            194 
   03B2                     195 lcn_finlecturan:
   03B2 6F 84         [ 6]  196 	clr ,x
                            197 
   03B4                     198 lcn_retorno:
   03B4 35 04         [ 6]  199 	puls b
   03B6 39            [ 5]  200 	rts
                            201 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                            202 ;      Generador Palabra		   		;
                            203 ; Cargamos la pila y cargamos d con palabras		;
                            204 ; metes d dentro de la pila para q el primer caracter   ;
                            205 ;entre en la pila, añades 1 para q vaya metiendo        ;
                            206 ;					    		;			   
                            207 ;					    	        ;
                            208 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   03B7                     209 inicio_genera:
   03B7 10 8E 04 EC   [ 4]  210 	ldy #palabras
   03BB 5F            [ 2]  211 	clrb
   03BC                     212 generar_palabra:
   03BC F1 01 D3      [ 5]  213 	cmpb num_palabra
   03BF 27 05         [ 3]  214 	beq incrementa
   03C1 5C            [ 2]  215 	incb
   03C2 31 26         [ 5]  216 	leay 6,y
   03C4 20 F6         [ 3]  217 	bra generar_palabra
   03C6                     218 incrementa:
   03C6 7C 01 D3      [ 7]  219 	inc num_palabra
   03C9 B6 01 D3      [ 5]  220 	lda num_palabra
   03CC B1 02 28      [ 5]  221 	cmpa total_palabras
   03CF 27 02         [ 3]  222 	beq reinicia_numpalabra
   03D1 20 03         [ 3]  223 	bra reinicia_x
   03D3                     224 reinicia_numpalabra:
   03D3 7F 01 D3      [ 7]  225 	clr num_palabra
   03D6                     226 reinicia_x:
   03D6 8E 01 D4      [ 3]  227 	ldx #palabra_s
   03D9                     228 bucle:
   03D9 A6 A0         [ 6]  229 	lda ,y+
   03DB 81 0A         [ 2]  230 	cmpa #'\n
   03DD 27 04         [ 3]  231 	beq fingenera
   03DF A7 80         [ 6]  232 	sta ,x+
   03E1 20 F6         [ 3]  233 	bra bucle
ASxxxx Assembler V05.00  (Motorola 6809), page 6.
Hexidecimal [16-Bits]



   03E3                     234 fingenera:
   03E3 39            [ 5]  235 	rts
                            236 
                            237 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                            238 ;				Comprueba palabra				;
                            239 ;										;
                            240 ;   Subrutina: Comprueba palabra diccionario					;
                            241 ;   										;
                            242 ;   Funcionamiento: Comprueba si la palabra introducida por el usuario	;
                            243 ;   se encuentra en el diccionario o no					;
                            244 ;										;  
                            245 ;   Registros Afectados: X,Y y CC						;
                            246 ;  										;
                            247 ;   										;
                            248 ;										;
                            249 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                            250 
                            251 
   03E4                     252 comprueba:
   03E4 8E 04 EC      [ 3]  253 	ldx #palabras ;Cargamos en X la direccion donde estan las palabras
   03E7 10 8E 01 CD   [ 4]  254 	ldy #palabra
   03EB                     255 sig_palabra:
   03EB A6 80         [ 6]  256 	lda ,x+ ; Cargamos en a el siguiente caracter de x
   03ED A1 A0         [ 6]  257 	cmpa ,y+ ;Comparamos a con el siguiente caracter de y
   03EF 27 FA         [ 3]  258 	beq sig_palabra; Si es igual, que vuelva a hacer lo mismo.
   03F1 81 0A         [ 2]  259 	cmpa #'\n 
   03F3 27 10         [ 3]  260 	beq comprueba_final_b ; Llamamos a comprueba_final_b e indicamos q la palabra esta en el diccionario.
   03F5                     261 avanza_palabra:
   03F5 A6 80         [ 6]  262 	lda ,x+ ;Avanzamos a hasta q lleguemos al \n
   03F7 10 8E 01 CD   [ 4]  263 	ldy #palabra ;Reiniciamos y
   03FB 81 0A         [ 2]  264 	cmpa #'\n ;SI es igual, volvemos al bucle de comprobar los caracteres
   03FD 27 EC         [ 3]  265 	beq sig_palabra
   03FF 81 00         [ 2]  266 	cmpa #'\0
   0401 27 03         [ 3]  267 	beq comprueba_final_m
   0403 20 F0         [ 3]  268 	bra avanza_palabra
   0405                     269 comprueba_final_b:
   0405 39            [ 5]  270 	rts
   0406                     271 comprueba_final_m:
   0406 8E 01 DA      [ 3]  272 	ldx #palabra_mal
   0409 BD 03 00      [ 8]  273 	jsr imprime_cadena
   040C BD 01 AB      [ 8]  274 	jsr pedir_palabra
   040F 39            [ 5]  275 	rts
                            276 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                            277 ;										;
                            278 ;										;
                            279 ;			Lógica del Juego					;
                            280 ;										;
                            281 ;	Tenemos un tablero, que en la primera iteracion va a estar vacio	;
                            282 ; 	y vamos a ir guardando cada palabra en una variable, le aplicamos	;
                            283 ;	la logica para los colores, y luego mediante un bucle, vamos sacando	;
                            284 ;	cada fila (cada palabra) ya con los colores				;
                            285 ;										;
                            286 ;										;
                            287 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                            288 
ASxxxx Assembler V05.00  (Motorola 6809), page 7.
Hexidecimal [16-Bits]



   0410                     289 inicio:
   0410 7F 02 27      [ 7]  290    clr contador_bien
   0413 C6 0A         [ 2]  291    ldb #'\n
   0415 F7 FF 00      [ 5]  292    stb pantalla
   0418 F6 01 CC      [ 5]  293    ldb intento_actual
   041B CB 31         [ 2]  294    addb #49
   041D F7 FF 00      [ 5]  295    stb pantalla
   0420 8E 02 AC      [ 3]  296    ldx #barra1
   0423 BD 03 00      [ 8]  297    jsr imprime_cadena
   0426 8E 01 CD      [ 3]  298    ldx #palabra  ;Cadena leida
   0429 10 8E 02 A2   [ 4]  299    ldy #palabra1 ;String Vacia
   042D                     300 copiar: 
   042D A6 80         [ 6]  301    lda ,x+  ;Carga en a el elemento de x
   042F A7 A0         [ 6]  302    sta ,y+  ;Almacena en y lo que halla en A
   0431 81 00         [ 2]  303    cmpa #'\0  ; Lo comparas con el final
   0433 27 02         [ 3]  304    beq reiniciar_ptr ;Si es igual, es q la copia ha finalizado y los ptrs se reinician.
   0435 20 F6         [ 3]  305    bra copiar ;Sino, q siga copiando
   0437                     306 reiniciar_ptr:
   0437 8E 01 D4      [ 3]  307 	ldx #palabra_s
   043A 10 8E 02 A2   [ 4]  308 	ldy #palabra1
   043E                     309 compara:
   043E B6 02 27      [ 5]  310    	lda contador_bien
   0441 81 05         [ 2]  311 	cmpa #5
   0443 27 3A         [ 3]  312 	beq acierto
   0445 A6 A0         [ 6]  313 	lda ,y+
   0447 81 00         [ 2]  314 	cmpa #'\0
   0449 27 4B         [ 3]  315 	beq final_w1
   044B A1 80         [ 6]  316 	cmpa ,x+
   044D 27 3E         [ 3]  317 	beq pos_correcta
   044F 20 20         [ 3]  318 	bra no_estan
   0451                     319 inicio2:
   0451 10 8E 02 A2   [ 4]  320 	ldy #palabra1
   0455 8E 01 D4      [ 3]  321 	ldx #palabra_s
   0458                     322 segunda_comp:
   0458 A6 80         [ 6]  323 	lda ,x+
   045A A1 A4         [ 4]  324 	cmpa ,y
   045C 27 1A         [ 3]  325 	beq escribe_dif_pos
   045E 81 00         [ 2]  326 	cmpa #'\0
   0460 27 08         [ 3]  327 	beq reinicia_ptr
   0462 E6 A4         [ 4]  328 	ldb ,y
   0464 C1 00         [ 2]  329 	cmpb #'\0
   0466 27 35         [ 3]  330 	beq final_w2
   0468 20 EE         [ 3]  331 	bra segunda_comp
   046A                     332 reinicia_ptr:
   046A 8E 01 D4      [ 3]  333 	ldx #palabra_s
   046D 31 21         [ 5]  334 	leay 1,y
   046F 20 E7         [ 3]  335 	bra segunda_comp
   0471                     336 no_estan:
   0471 C6 58         [ 2]  337 	ldb #'X
   0473 F7 FF 00      [ 5]  338 	stb pantalla
   0476 20 C6         [ 3]  339 	bra compara
   0478                     340 escribe_dif_pos:
   0478 A6 A4         [ 4]  341 	lda ,y
   047A B7 FF 00      [ 5]  342 	sta pantalla
   047D 20 D9         [ 3]  343 	bra segunda_comp
ASxxxx Assembler V05.00  (Motorola 6809), page 8.
Hexidecimal [16-Bits]



   047F                     344 acierto: 	
   047F 8E 02 A8      [ 3]  345 	ldx #barra		;Cuando se acierta la palabra, cargamos la barra externa
   0482 BD 03 00      [ 8]  346 	jsr imprime_cadena	;Imprime
   0485 8E 02 5D      [ 3]  347 	ldx #cad_acierto	;Carga cadena mensaje
   0488 BD 03 00      [ 8]  348 	jsr imprime_cadena
   048B 20 2B         [ 3]  349 	bra elegir		
   048D                     350 pos_correcta:
   048D B7 FF 00      [ 5]  351 	sta pantalla
   0490 7C 02 27      [ 7]  352 	inc contador_bien	;Incrementamos un contador para contar las letras bien posicionadas
   0493 16 FF A8      [ 5]  353 	lbra compara
                            354 
   0496                     355 final_w1:
   0496 8E 02 A8      [ 3]  356 	ldx #barra
   0499 BD 03 00      [ 8]  357 	jsr imprime_cadena
   049C 39            [ 5]  358 	rts
   049D                     359 final_w2:
   049D 7C 01 CC      [ 7]  360 	inc intento_actual
   04A0 8E 02 A8      [ 3]  361 	ldx #barra
   04A3 BD 03 00      [ 8]  362 	jsr imprime_cadena
   04A6 F6 01 CC      [ 5]  363 	ldb intento_actual
   04A9 C1 06         [ 2]  364    	cmpb #6
   04AB 10 27 00 01   [ 6]  365    	lbeq mensaje_fallo
   04AF 39            [ 5]  366 	rts
   04B0                     367 mensaje_fallo:
   04B0 8E 02 82      [ 3]  368 	ldx #mensaje_falloo	;Se acabaron los intentos
   04B3 BD 03 00      [ 8]  369 	jsr imprime_cadena
   04B6 20 00         [ 3]  370 	bra elegir
   04B8                     371 elegir:				;Elige entre volver al menu y reiniciar el juego
   04B8 8E 02 29      [ 3]  372 	ldx #seleccionar
   04BB BD 03 00      [ 8]  373 	jsr imprime_cadena
   04BE F6 FF 02      [ 5]  374 	ldb teclado
   04C1 C1 6D         [ 2]  375 	cmpb #'m
   04C3 10 27 FE A5   [ 6]  376 	lbeq salta
   04C7 C1 72         [ 2]  377 	cmpb #'r
   04C9 10 27 FE A8   [ 6]  378 	lbeq reinicia ; lbeq (Salto largo)
   04CD 20 E9         [ 3]  379 	bra elegir
ASxxxx Assembler V05.00  (Motorola 6809), page 9.
Hexidecimal [16-Bits]

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
    acabar             **** GX  |   0 acierto            02B3 R
  0 avanza_palabra     0229 R   |   0 barra              00DC R
  0 barra1             00E0 R   |   0 bucle              020D R
  0 cad_acierto        0091 R   |   0 compara            0272 R
  0 comprueba          0218 GR  |   0 comprueba_fina     0239 R
  0 comprueba_fina     023A R   |   0 contador           0142 GR
  0 contador_bien      005B R   |   0 convertir          015C GR
  0 copiar             0261 R   |   0 elegir             02EC R
  0 escribe_dif_po     02AC R   |   0 espacio            008F R
    fin            =   FF01     |   0 final_w1           02CA R
  0 final_w2           02D1 R   |   0 fingenera          0217 R
  0 generar_palabr     01F0 R   |   0 ic_sgte            0136 R
  0 imprime_cadena     0134 GR  |   0 incrementa         01FA R
  0 incrementa_a       0162 GR  |   0 incrementa_b       0147 R
  0 incrementa_con     014A R   |   0 inicio             0244 GR
  0 inicio2            0285 GR  |   0 inicio_genera      01EB GR
  0 intento_actual     0000 R   |   0 interrog           0090 R
    juego              **** GX  |   0 lcn_convierte      01CB R
  0 lcn_finlectura     01E2 R   |   0 lcn_finlectura     01E6 R
  0 lcn_lectura        017A R   |   0 lcn_limpia         01DB R
  0 lcn_max            016C R   |   0 lcn_retorno        01E8 R
  0 lee_cadena_n       016D GR  |   0 mensaje_fallo      02E4 GR
  0 mensaje_falloo     00B6 R   |   0 mensaje_vuelta     00E7 R
  0 menujogo           00E8 R   |   0 no_estan           02A5 R
  0 num_palabra        0007 R   |   0 palabra            0001 R
  0 palabra1           00D6 R   |   0 palabra_bien       0036 R
  0 palabra_mal        000E R   |   0 palabra_s          0008 R
    palabras           **** GX  |     pantalla       =   FF00 
    pedir_palabra      **** GX  |   0 pos_correcta       02C1 R
    ps             =   F000     |     pu             =   E000 
  0 quita_anterior     01BE R   |   0 reinicia           01A9 R
  0 reinicia_numpa     0207 R   |   0 reinicia_ptr       029E R
  0 reinicia_x         020A R   |   0 reiniciar_ptr      026B R
  0 ret_imprime_ca     013F R   |   0 retorno_contad     0156 R
  0 salir_bucle        0167 GR  |   0 salta              01A0 R
  0 segunda_comp       028C R   |   0 seleccionar        005D R
  0 sig                01B5 R   |   0 sig_palabra        021F R
    teclado        =   FF02     |   0 total_palabras     005C R
    wordle             **** GX

ASxxxx Assembler V05.00  (Motorola 6809), page 10.
Hexidecimal [16-Bits]

Area Table

[_CSEG]
   0 _CODE            size  303   flags C180
[_DSEG]
   1 _DATA            size    0   flags C0C0

