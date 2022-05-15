ASxxxx Assembler V05.00  (Motorola 6809), page 1.
Hexidecimal [16-Bits]



                              1 		.module subrutinaswordle
                              2 		
                     FF01     3 fin		.equ 0xFF01
                     FF02     4 teclado	.equ 0xFF02
                     FF00     5 pantalla	.equ 0xFF00
                     E000     6 pu		.equ 0xE000
                     F000     7 ps		.equ 0xF000
   019E 00                    8 intento_actual: .byte 0
                              9 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   019F 20 20 20 20 20 00    10 palabra: 	.asciz '     '
   01A5 4D 4F 53 43 41 00    11 palabra_s: 	.asciz "MOSCA"	
   01AB 0A 4C 61 20 70 61    12 palabra_mal:	.asciz "\nLa palabra NO esta en el diccionario.\n"
        6C 61 62 72 61 20
        4E 4F 20 65 73 74
        61 20 65 6E 20 65
        6C 20 64 69 63 63
        69 6F 6E 61 72 69
        6F 2E 0A 00
   01D3 0A 4C 61 20 70 61    13 palabra_bien:   .asciz "\nLa palabra esta en el diccionario.\n"
        6C 61 62 72 61 20
        65 73 74 61 20 65
        6E 20 65 6C 20 64
        69 63 63 69 6F 6E
        61 72 69 6F 2E 0A
        00
   01F8 00                   14 contador_bien:	.byte 0
                             15 
   01F9 0A 50 75 6C 73 65    16 seleccionar: 	.asciz "\nPulse m para volver al menu y r para reiniciar.\n"
        20 6D 20 70 61 72
        61 20 76 6F 6C 76
        65 72 20 61 6C 20
        6D 65 6E 75 20 79
        20 72 20 70 61 72
        61 20 72 65 69 6E
        69 63 69 61 72 2E
        0A 00
                             17 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   022B 20                   18 espacio: 	.byte 32
   022C 3F                   19 interrog: 	.byte 63
   022D 0A 45 4E 48 4F 52    20 cad_acierto: 	.asciz "\nENHORABUENA! Acertaste la palabra.\n"
        41 42 55 45 4E 41
        21 20 41 63 65 72
        74 61 73 74 65 20
        6C 61 20 70 61 6C
        61 62 72 61 2E 0A
        00
   0252 53 65 20 74 65 20    21 mensaje_falloo:  .asciz  "Se te acabaron los intentos!\n" 
        61 63 61 62 61 72
        6F 6E 20 6C 6F 73
        20 69 6E 74 65 6E
        74 6F 73 21 0A 00
                             22 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                             23 ;Variables para guardar cada intento de la palabra
   0270 20 20 20 20 20 00    24 palabra1:  	.asciz "     "
   0276 20 7C 20 00          25 barra: 		.asciz " | "
ASxxxx Assembler V05.00  (Motorola 6809), page 2.
Hexidecimal [16-Bits]



   027A 20 20 20 20 7C 20    26 barra1: 	.asciz "    | "
        00
                             27 
   0281 00                   28 mensaje_vuelta: .asciz ""
                             29 ;;;;;;;;;;;;;;;;;;;;;;;;;    Variables Globales ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                             30 	.globl imprime_cadena
                             31 	.globl contador
                             32 	.globl palabras
                             33 	.globl lee_cadena_n
                             34 	.globl convertir
                             35 	.globl incrementa_a
                             36 	.globl salir_bucle
                             37 	.globl comprueba
                             38 	.globl pedir_palabra
                             39 	.globl inicio
                             40 	.globl wordle
                             41 	.globl juego
                             42 	.globl acabar
   0282                      43 menujogo:
   0282 1B 5B 32 4A 1B 5B    44 	.ascii "\33[2J\33[H" ;Limpia la pantalla y pone el cursor arriba.
        48
   0289 0A 20 20 20 20 20    45 	.ascii "\n     | JUEGO |\n"
        7C 20 4A 55 45 47
        4F 20 7C 0A
   0299 2D 2D 2D 2D 2D 2D    46 	.ascii "--------------\n"
        2D 2D 2D 2D 2D 2D
        2D 2D 0A
   02A8 20 20 20 20 20 7C    47 	.ascii "     | 12345 |\n"
        20 31 32 33 34 35
        20 7C 0A
   02B7 2D 2D 2D 2D 2D 2D    48 	.asciz "--------------\n"
        2D 2D 2D 2D 2D 2D
        2D 2D 0A 00
                             49 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                             50 ;	Subrutina: Imprime cadena						  ;
                             51 ;	Funcionamiento: Imprime una cadena leida por teclado o ya establecida. ;  
                             52 ;	Registros Afectados: CC						  ;
                             53 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
   02C7                      54 imprime_cadena:
   02C7 36 12         [ 7]   55 	pshu a,x
                             56 	
   02C9                      57 ic_sgte:
   02C9 A6 80         [ 6]   58 	lda ,x+
   02CB 27 05         [ 3]   59 	beq ret_imprime_cadena
   02CD B7 FF 00      [ 5]   60 	sta pantalla
   02D0 20 F7         [ 3]   61 	bra ic_sgte
                             62 
   02D2                      63 ret_imprime_cadena:
   02D2 37 12         [ 7]   64 	pulu a,x
   02D4 39            [ 5]   65 	rts
                             66 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                             67 ;	Subrutina: Contador de palabras					  ;
                             68 ;	Funcionamiento: Cuenta el numero de palabras en diccionario. 	  ;  
                             69 ;	Registros Afectados: B,CC						  ;
                             70 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		
ASxxxx Assembler V05.00  (Motorola 6809), page 3.
Hexidecimal [16-Bits]



   02D5                      71 contador:
   02D5 36 12         [ 7]   72 	pshu a,x
   02D7 5F            [ 2]   73 	clrb
   02D8 20 03         [ 3]   74 	bra incrementa_contador
   02DA                      75 incrementa_b:
   02DA 5C            [ 2]   76 	incb
   02DB 20 00         [ 3]   77 	bra incrementa_contador
   02DD                      78 incrementa_contador:
   02DD A6 80         [ 6]   79 	lda ,x+
   02DF 81 00         [ 2]   80 	cmpa #'\0
   02E1 27 06         [ 3]   81 	beq retorno_contador
   02E3 81 0A         [ 2]   82 	cmpa #'\n
   02E5 27 F3         [ 3]   83 	beq incrementa_b
   02E7 20 F4         [ 3]   84 	bra incrementa_contador
   02E9                      85 retorno_contador:
   02E9 37 12         [ 7]   86 	pulu a,x
   02EB 39            [ 5]   87 	rts
                             88 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                             89 ;	Subrutina: convertir (contador palabras diccionario)			  ;
                             90 ;	Funcionamiento: Vamos restando el registro B y a su vez incrementando a;
                             91 ;	Registros Afectados: A,B,CC.						  ;
                             92 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   02EC                      93 convertir:
   02EC C1 0A         [ 2]   94 	cmpb #10
   02EE 2C 02         [ 3]   95 	bge incrementa_a 
   02F0 20 05         [ 3]   96 	bra salir_bucle
   02F2                      97 incrementa_a:
   02F2 4C            [ 2]   98 	inca
   02F3 C0 0A         [ 2]   99 	subb #10
   02F5 20 F5         [ 3]  100 	bra convertir
   02F7                     101 salir_bucle:
   02F7 8B 30         [ 2]  102 	adda #48
   02F9 CB 30         [ 2]  103 	addb #48
   02FB 39            [ 5]  104 	rts
                            105 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                            106 ;				LCN MAX 					;
                            107 ;										;
                            108 ;   Le pasamos el numero a leer antes de llamar a la funcion.		;
                            109 ;   Cargamos la pila con b, testeamos a, si es igual a 0 se devuelve		;
                            110 ;   sino, guarda lcn_max en a y limpia a					;
                            111 ;										;
                            112 ;   Lemos la cadena y comparamos con el \n, si es 0 se acaba y sino vuelve   ;  
                            113 ;   a leer.									;
                            114 ;  										;
                            115 ;   Registros Afectados: A y CC						;
                            116 ;										;
                            117 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   02FC 00                  118 lcn_max: .byte 0
                            119 
   02FD                     120 lee_cadena_n:
   02FD 34 04         [ 6]  121 	pshs b
   02FF 8E 01 9F      [ 3]  122 	ldx #palabra
   0302 4D            [ 2]  123 	tsta
   0303 27 70         [ 3]  124 	beq lcn_retorno
   0305 4A            [ 2]  125 	deca
ASxxxx Assembler V05.00  (Motorola 6809), page 4.
Hexidecimal [16-Bits]



   0306 B7 02 FC      [ 5]  126 	sta lcn_max
   0309 4F            [ 2]  127 	clra
   030A                     128 lcn_lectura:
   030A B1 02 FC      [ 5]  129 	cmpa lcn_max
   030D 24 64         [ 3]  130 	bhs  lcn_finlecturan
   030F F6 FF 02      [ 5]  131 	ldb teclado
   0312 C1 76         [ 2]  132 	cmpb #'v
   0314 27 1A         [ 3]  133 	beq salta
   0316 C1 72         [ 2]  134 	cmpb #'r
   0318 27 1F         [ 3]  135 	beq reinicia
   031A C1 20         [ 2]  136 	cmpb #32
   031C 27 2D         [ 3]  137 	beq quita_anterior
   031E C1 41         [ 2]  138 	cmpb #65 		;Comparamos con el codigo ascii 65
   0320 25 46         [ 3]  139 	blo lcn_limpia		; Si es menor, limpia, porque el codigo ascii 65 es la A
   0322 C1 5A         [ 2]  140 	cmpb #90		;Comparamos con el ascii 90	
   0324 23 1C         [ 3]  141 	bls sig		; Si es menor, son mayusculas, asi q sigue
   0326 C1 61         [ 2]  142 	cmpb #97		;Del 90 al 97 hay caracteres q no nos interesan, asi q limpia
   0328 25 3E         [ 3]  143 	blo lcn_limpia
   032A C1 7B         [ 2]  144 	cmpb #123		;Si es superior que 123 limpia, y sino convierte
   032C 24 3A         [ 3]  145 	bhs lcn_limpia
   032E 25 28         [ 3]  146 	blo lcn_convierte
   0330                     147 salta:
   0330 C6 00         [ 2]  148     ldb #0			;Reiniciamos el contador de los intentos
   0332 F7 01 9E      [ 5]  149     stb intento_actual		;Y lo guardamos en la var q hemos creado
   0335 BD 01 44      [ 8]  150     jsr wordle			;Volvemos al menu
   0338 39            [ 5]  151     rts
   0339                     152 reinicia:
   0339 C6 00         [ 2]  153     ldb #0			;Reiniciamos el contador de los intentos
   033B F7 01 9E      [ 5]  154     stb intento_actual		;Lo guardamos en los intentos
   033E BD 01 7E      [ 8]  155     jsr juego			;Reiniciamos juego
   0341 39            [ 5]  156     rts
   0342                     157 sig:
   0342 E7 80         [ 6]  158 	stb, x+
   0344 C1 0A         [ 2]  159 	cmpb #'\n
   0346 27 27         [ 3]  160 	beq lcn_finlectura
   0348 4C            [ 2]  161 	inca
   0349 20 BF         [ 3]  162 	bra lcn_lectura
   034B                     163 quita_anterior:
   034B C6 08         [ 2]  164 	ldb #8
   034D F7 FF 00      [ 5]  165 	stb pantalla
   0350 F7 FF 00      [ 5]  166 	stb pantalla
   0353 30 1F         [ 5]  167 	leax -1,x			; Decrementamos el puntero para ponernos en el caracter de atrás
   0355 4A            [ 2]  168 	deca				; Decrementamos el contador para que nos deje re-escribir la palabra
   0356 20 B2         [ 3]  169 	bra lcn_lectura
   0358                     170 lcn_convierte:
                            171 
   0358 36 04         [ 6]  172 	pshu b				;Lo metemos en la pila para no perder el valor.
   035A C6 08         [ 2]  173 	ldb #8				;El cursor apunta al anterior.
   035C F7 FF 00      [ 5]  174 	stb pantalla
   035F 37 04         [ 6]  175 	pulu b				;Lo sacamos de la pila
   0361 C0 20         [ 2]  176 	subb #32			;Le resta 32 al ascii cargado en b
   0363 F7 FF 00      [ 5]  177 	stb pantalla			;Saca por pantalla y sigue
   0366 20 DA         [ 3]  178 	bra sig
                            179 	
   0368                     180 lcn_limpia:
ASxxxx Assembler V05.00  (Motorola 6809), page 5.
Hexidecimal [16-Bits]



   0368 C6 08         [ 2]  181 	ldb #8
   036A F7 FF 00      [ 5]  182 	stb pantalla
   036D 20 9B         [ 3]  183 	bra lcn_lectura
   036F                     184 lcn_finlectura:
   036F 6F 82         [ 8]  185 	clr ,-x			;Borra la posicion siguiente 
   0371 20 02         [ 3]  186 	bra lcn_retorno
                            187 
   0373                     188 lcn_finlecturan:
   0373 6F 84         [ 6]  189 	clr ,x
                            190 
   0375                     191 lcn_retorno:
   0375 35 04         [ 6]  192 	puls b
   0377 39            [ 5]  193 	rts
                            194 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                            195 ;      Generador Palabra		   ;
                            196 ; Cargamos la pila y cargamos d con palabras
                            197 ; metes d dentro de la pila para q el primer caracter
                            198 ;entre en la pila, añades 1 para q vaya metiendo;
                            199 ;					    
                            200 					   
                            201 					    ;
                            202 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                            203 
   0378                     204 generar:
   0378 10 FE F0 00   [ 7]  205 	lds ps
   037C CC 04 73      [ 3]  206 	ldd #palabras
   037F 34 06         [ 7]  207 	pshs d
   0381 C3 00 01      [ 4]  208 	addd #1
   0384 10 83 00 0A   [ 5]  209 	cmpd #'\n
   0388 27 02         [ 3]  210 	beq g_acabar
   038A 20 EC         [ 3]  211 	bra generar
   038C                     212 g_acabar: 
   038C 39            [ 5]  213 	rts
                            214 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                            215 ;				Comprueba palabra				;
                            216 ;										;
                            217 ;   Subrutina: Comprueba palabra diccionario					;
                            218 ;   										;
                            219 ;   Funcionamiento: Comprueba si la palabra introducida por el usuario	;
                            220 ;   se encuentra en el diccionario o no					;
                            221 ;										;  
                            222 ;   Registros Afectados: X,Y y CC						;
                            223 ;  										;
                            224 ;   										;
                            225 ;										;
                            226 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                            227 
                            228 
   038D                     229 comprueba:
   038D 8E 04 73      [ 3]  230 	ldx #palabras ;Cargamos en X la direccion donde estan las palabras
   0390 10 8E 01 9F   [ 4]  231 	ldy #palabra
   0394                     232 sig_palabra:
   0394 A6 80         [ 6]  233 	lda ,x+ ; Cargamos en a el siguiente caracter de x
   0396 A1 A0         [ 6]  234 	cmpa ,y+ ;Comparamos a con el siguiente caracter de y
   0398 27 FA         [ 3]  235 	beq sig_palabra; Si es igual, que vuelva a hacer lo mismo.
ASxxxx Assembler V05.00  (Motorola 6809), page 6.
Hexidecimal [16-Bits]



   039A 81 0A         [ 2]  236 	cmpa #'\n 
   039C 27 10         [ 3]  237 	beq comprueba_final_b ; Llamamos a comprueba_final_b e indicamos q la palabra esta en el diccionario.
   039E                     238 avanza_palabra:
   039E A6 80         [ 6]  239 	lda ,x+ ;Avanzamos a hasta q lleguemos al \n
   03A0 10 8E 01 9F   [ 4]  240 	ldy #palabra ;Reiniciamos y
   03A4 81 0A         [ 2]  241 	cmpa #'\n ;SI es igual, volvemos al bucle de comprobar los caracteres
   03A6 27 EC         [ 3]  242 	beq sig_palabra
   03A8 81 00         [ 2]  243 	cmpa #'\0
   03AA 27 03         [ 3]  244 	beq comprueba_final_m
   03AC 20 F0         [ 3]  245 	bra avanza_palabra
   03AE                     246 comprueba_final_b:
                            247 	;ldx #palabra_bien
                            248 	;jsr imprime_cadena
   03AE 39            [ 5]  249 	rts
   03AF                     250 comprueba_final_m:
   03AF 8E 01 AB      [ 3]  251 	ldx #palabra_mal
   03B2 BD 02 C7      [ 8]  252 	jsr imprime_cadena
   03B5 BD 01 87      [ 8]  253 	jsr pedir_palabra
   03B8 39            [ 5]  254 	rts
                            255 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                            256 ;										;
                            257 ;										;
                            258 ;			Lógica del Juego					;
                            259 ;										;
                            260 ;	Tenemos un tablero, que en la primera iteracion va a estar vacio	;
                            261 ; 	y vamos a ir guardando cada palabra en una variable, le aplicamos	;
                            262 ;	la logica para los colores, y luego mediante un bucle, vamos sacando	;
                            263 ;	cada fila (cada palabra) ya con los colores				;
                            264 ;										;
                            265 ;										;
                            266 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                            267 
   03B9                     268 inicio:
   03B9 7F 01 F8      [ 7]  269    clr contador_bien
   03BC C6 0A         [ 2]  270    ldb #'\n
   03BE F7 FF 00      [ 5]  271    stb pantalla
   03C1 F6 01 9E      [ 5]  272    ldb intento_actual
   03C4 CB 31         [ 2]  273    addb #49
   03C6 C1 36         [ 2]  274    cmpb #'6
   03C8 27 6D         [ 3]  275    beq mensaje_fallo
   03CA F7 FF 00      [ 5]  276    stb pantalla
   03CD 8E 02 7A      [ 3]  277    ldx #barra1
   03D0 BD 02 C7      [ 8]  278    jsr imprime_cadena
   03D3 8E 01 9F      [ 3]  279    ldx #palabra  ;Cadena leida
   03D6 10 8E 02 70   [ 4]  280    ldy #palabra1 ;String Vacia
   03DA                     281 copiar: ;Esta wea copia
   03DA A6 80         [ 6]  282    lda ,x+  ;Carga en a el elemento de x
   03DC A7 A0         [ 6]  283    sta ,y+  ;Almacena en y lo que halla en A
   03DE 81 00         [ 2]  284    cmpa #'\0  ; Lo comparas con el final
   03E0 27 02         [ 3]  285    beq reiniciar_ptr ;Si es igual, es q la copia ha finalizado y los ptrs se reinician.
   03E2 20 F6         [ 3]  286    bra copiar ;Sino, q siga copiando
   03E4                     287 reiniciar_ptr:
   03E4 8E 01 A5      [ 3]  288 	ldx #palabra_s
   03E7 10 8E 02 70   [ 4]  289 	ldy #palabra1
   03EB                     290 comparaciones:
ASxxxx Assembler V05.00  (Motorola 6809), page 7.
Hexidecimal [16-Bits]



   03EB A6 80         [ 6]  291 	lda ,x+ ;Compara 
   03ED F6 01 F8      [ 5]  292 	ldb contador_bien
   03F0 C1 05         [ 2]  293 	cmpb #5			;Si el contador es 5, quiere decir q tiene 5 letras bien por lo que la palabra es correcta
   03F2 27 0A         [ 3]  294 	beq acierto                    
   03F4 81 00         [ 2]  295 	cmpa #'\0
   03F6 27 35         [ 3]  296 	beq final_w1
   03F8 A1 A0         [ 6]  297 	cmpa ,y+
   03FA 27 10         [ 3]  298 	beq pos_correcta
   03FC 26 16         [ 3]  299 	bne otra_pos
                            300 
   03FE                     301 acierto: 	
   03FE 8E 02 76      [ 3]  302 	ldx #barra		;Cuando se acierta la palabra, cargamos la barra externa
   0401 BD 02 C7      [ 8]  303 	jsr imprime_cadena	;Imprime
   0404 8E 02 2D      [ 3]  304 	ldx #cad_acierto	;Carga cadena mensaje
   0407 BD 02 C7      [ 8]  305 	jsr imprime_cadena
   040A 20 33         [ 3]  306 	bra elegir		;Elige
   040C                     307 pos_correcta:
   040C B7 FF 00      [ 5]  308 	sta pantalla
   040F 7C 01 F8      [ 7]  309 	inc contador_bien	;Incrementamos un contador para contar las letras bien posicionadas
   0412 20 D7         [ 3]  310 	bra comparaciones
   0414                     311 otra_pos:
   0414 A1 A0         [ 6]  312 	cmpa ,y+
   0416 27 06         [ 3]  313 	beq  escribe_otra_pos
   0418 81 00         [ 2]  314 	cmpa #'\0
   041A 27 0A         [ 3]  315 	beq  no_esta
   041C 20 F6         [ 3]  316 	bra otra_pos
   041E                     317 escribe_otra_pos:
   041E F6 02 2C      [ 5]  318 	ldb interrog		; El simbolo de la interrog es cuando la letra está en la palabra pero no en la posición correcta
   0421 F7 FF 00      [ 5]  319 	stb pantalla
   0424 20 C5         [ 3]  320 	bra comparaciones
   0426                     321 no_esta:
   0426 C6 2B         [ 2]  322 	ldb #espacio
   0428 F7 FF 00      [ 5]  323 	stb pantalla
   042B 20 BE         [ 3]  324 	bra comparaciones
   042D                     325 final_w1:
   042D 8E 02 76      [ 3]  326 	ldx #barra
   0430 BD 02 C7      [ 8]  327 	jsr imprime_cadena
   0433 7C 01 9E      [ 7]  328 	inc intento_actual
   0436 39            [ 5]  329 	rts
   0437                     330 mensaje_fallo:
   0437 8E 02 52      [ 3]  331 	ldx #mensaje_falloo	;Se acabaron los intentos
   043A BD 02 C7      [ 8]  332 	jsr imprime_cadena
   043D 20 00         [ 3]  333 	bra elegir
   043F                     334 elegir:				;Elige entre volver al menu y reiniciar el juego
   043F 8E 01 F9      [ 3]  335 	ldx #seleccionar
   0442 BD 02 C7      [ 8]  336 	jsr imprime_cadena
   0445 F6 FF 02      [ 5]  337 	ldb teclado
   0448 C1 6D         [ 2]  338 	cmpb #'m
   044A 10 27 FE E2   [ 6]  339 	lbeq salta
   044E C1 72         [ 2]  340 	cmpb #'r
   0450 10 27 FE E5   [ 6]  341 	lbeq reinicia ; lbeq (Salto largo)
   0454 20 E9         [ 3]  342 	bra elegir
ASxxxx Assembler V05.00  (Motorola 6809), page 8.
Hexidecimal [16-Bits]

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
    acabar             **** GX  |   0 acierto            0260 R
  0 avanza_palabra     0200 R   |   0 barra              00D8 R
  0 barra1             00DC R   |   0 cad_acierto        008F R
  0 comparaciones      024D R   |   0 comprueba          01EF GR
  0 comprueba_fina     0210 R   |   0 comprueba_fina     0211 R
  0 contador           0137 GR  |   0 contador_bien      005A R
  0 convertir          014E GR  |   0 copiar             023C R
  0 elegir             02A1 R   |   0 escribe_otra_p     0280 R
  0 espacio            008D R   |     fin            =   FF01 
  0 final_w1           028F R   |   0 g_acabar           01EE R
  0 generar            01DA R   |   0 ic_sgte            012B R
  0 imprime_cadena     0129 GR  |   0 incrementa_a       0154 GR
  0 incrementa_b       013C R   |   0 incrementa_con     013F R
  0 inicio             021B GR  |   0 intento_actual     0000 R
  0 interrog           008E R   |     juego              **** GX
  0 lcn_convierte      01BA R   |   0 lcn_finlectura     01D1 R
  0 lcn_finlectura     01D5 R   |   0 lcn_lectura        016C R
  0 lcn_limpia         01CA R   |   0 lcn_max            015E R
  0 lcn_retorno        01D7 R   |   0 lee_cadena_n       015F GR
  0 mensaje_fallo      0299 R   |   0 mensaje_falloo     00B4 R
  0 mensaje_vuelta     00E3 R   |   0 menujogo           00E4 R
  0 no_esta            0288 R   |   0 otra_pos           0276 R
  0 palabra            0001 R   |   0 palabra1           00D2 R
  0 palabra_bien       0035 R   |   0 palabra_mal        000D R
  0 palabra_s          0007 R   |     palabras           **** GX
    pantalla       =   FF00     |     pedir_palabra      **** GX
  0 pos_correcta       026E R   |     ps             =   F000 
    pu             =   E000     |   0 quita_anterior     01AD R
  0 reinicia           019B R   |   0 reiniciar_ptr      0246 R
  0 ret_imprime_ca     0134 R   |   0 retorno_contad     014B R
  0 salir_bucle        0159 GR  |   0 salta              0192 R
  0 seleccionar        005B R   |   0 sig                01A4 R
  0 sig_palabra        01F6 R   |     teclado        =   FF02 
    wordle             **** GX

ASxxxx Assembler V05.00  (Motorola 6809), page 9.
Hexidecimal [16-Bits]

Area Table

[_CSEG]
   0 _CODE            size  2B8   flags C180
[_DSEG]
   1 _DATA            size    0   flags C0C0

