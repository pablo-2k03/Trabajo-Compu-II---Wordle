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
   01F8 00                   14 booleano:	.byte 0
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
                             20 
   022D 43 41 47 41 53 54    21 mensaje_falloo:  .asciz  "CAGASTE WEY\n" 
        45 20 57 45 59 0A
        00
                             22 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                             23 ;Variables para guardar cada intento de la palabra
   023A 20 20 20 20 20 00    24 palabra1:  	.asciz "     "
   0240 20 7C 20 00          25 barra: 		.asciz " | "
   0244 20 20 20 20 7C 20    26 barra1: 	.asciz "    | "
        00
                             27 
   024B 00                   28 mensaje_vuelta: .asciz ""
                             29 ;;;;;;;;;;;;;;;;;;;;;;;;;    Variables Globales ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                             30 	.globl imprime_cadena
                             31 	.globl contador
                             32 	.globl palabras
ASxxxx Assembler V05.00  (Motorola 6809), page 2.
Hexidecimal [16-Bits]



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
   024C                      43 menujogo:
   024C 1B 5B 32 4A 1B 5B    44 	.ascii "\33[2J\33[H" ;Limpia la pantalla y pone el cursor arriba.
        48
   0253 0A 20 20 20 20 20    45 	.ascii "\n     | JUEGO |\n"
        7C 20 4A 55 45 47
        4F 20 7C 0A
   0263 2D 2D 2D 2D 2D 2D    46 	.ascii "--------------\n"
        2D 2D 2D 2D 2D 2D
        2D 2D 0A
   0272 20 20 20 20 20 7C    47 	.ascii "     | 12345 |\n"
        20 31 32 33 34 35
        20 7C 0A
   0281 2D 2D 2D 2D 2D 2D    48 	.asciz "--------------\n"
        2D 2D 2D 2D 2D 2D
        2D 2D 0A 00
                             49 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                             50 ;	Subrutina: Imprime cadena						  ;
                             51 ;	Funcionamiento: Imprime una cadena leida por teclado o ya establecida. ;  
                             52 ;	Registros Afectados: CC						  ;
                             53 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
   0291                      54 imprime_cadena:
   0291 36 12         [ 7]   55 	pshu a,x
                             56 	
   0293                      57 ic_sgte:
   0293 A6 80         [ 6]   58 	lda ,x+
   0295 27 05         [ 3]   59 	beq ret_imprime_cadena
   0297 B7 FF 00      [ 5]   60 	sta pantalla
   029A 20 F7         [ 3]   61 	bra ic_sgte
                             62 
   029C                      63 ret_imprime_cadena:
   029C 37 12         [ 7]   64 	pulu a,x
   029E 39            [ 5]   65 	rts
                             66 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                             67 ;	Subrutina: Contador de palabras					  ;
                             68 ;	Funcionamiento: Cuenta el numero de palabras en diccionario. 	  ;  
                             69 ;	Registros Afectados: B,CC						  ;
                             70 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		
   029F                      71 contador:
   029F 36 12         [ 7]   72 	pshu a,x
   02A1 5F            [ 2]   73 	clrb
   02A2 20 03         [ 3]   74 	bra incrementa_contador
   02A4                      75 incrementa_b:
   02A4 5C            [ 2]   76 	incb
   02A5 20 00         [ 3]   77 	bra incrementa_contador
   02A7                      78 incrementa_contador:
ASxxxx Assembler V05.00  (Motorola 6809), page 3.
Hexidecimal [16-Bits]



   02A7 A6 80         [ 6]   79 	lda ,x+
   02A9 81 00         [ 2]   80 	cmpa #'\0
   02AB 27 06         [ 3]   81 	beq retorno_contador
   02AD 81 0A         [ 2]   82 	cmpa #'\n
   02AF 27 F3         [ 3]   83 	beq incrementa_b
   02B1 20 F4         [ 3]   84 	bra incrementa_contador
   02B3                      85 retorno_contador:
   02B3 37 12         [ 7]   86 	pulu a,x
   02B5 39            [ 5]   87 	rts
                             88 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                             89 ;	Subrutina: convertir (contador palabras diccionario)			  ;
                             90 ;	Funcionamiento: Vamos restando el registro B y a su vez incrementando a;
                             91 ;	Registros Afectados: A,B,CC.						  ;
                             92 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   02B6                      93 convertir:
   02B6 C1 0A         [ 2]   94 	cmpb #10
   02B8 2C 02         [ 3]   95 	bge incrementa_a 
   02BA 20 05         [ 3]   96 	bra salir_bucle
   02BC                      97 incrementa_a:
   02BC 4C            [ 2]   98 	inca
   02BD C0 0A         [ 2]   99 	subb #10
   02BF 20 F5         [ 3]  100 	bra convertir
   02C1                     101 salir_bucle:
   02C1 8B 30         [ 2]  102 	adda #48
   02C3 CB 30         [ 2]  103 	addb #48
   02C5 39            [ 5]  104 	rts
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
   02C6 00                  118 lcn_max: .byte 0
                            119 
   02C7                     120 lee_cadena_n:
   02C7 34 04         [ 6]  121 	pshs b
   02C9 8E 01 9F      [ 3]  122 	ldx #palabra
   02CC 4D            [ 2]  123 	tsta
   02CD 27 69         [ 3]  124 	beq lcn_retorno
   02CF 4A            [ 2]  125 	deca
   02D0 B7 02 C6      [ 5]  126 	sta lcn_max
   02D3 4F            [ 2]  127 	clra
   02D4                     128 lcn_lectura:
   02D4 B1 02 C6      [ 5]  129 	cmpa lcn_max
   02D7 24 5D         [ 3]  130 	bhs  lcn_finlecturan
   02D9 F6 FF 02      [ 5]  131 	ldb teclado
   02DC C1 76         [ 2]  132 	cmpb #'v
   02DE 27 1A         [ 3]  133 	beq salta
ASxxxx Assembler V05.00  (Motorola 6809), page 4.
Hexidecimal [16-Bits]



   02E0 C1 72         [ 2]  134 	cmpb #'r
   02E2 27 1A         [ 3]  135 	beq reinicia
   02E4 C1 20         [ 2]  136 	cmpb #32
   02E6 27 28         [ 3]  137 	beq quita_anterior
   02E8 C1 41         [ 2]  138 	cmpb #65 		;Comparamos con el codigo ascii 65
   02EA 25 3F         [ 3]  139 	blo lcn_limpia		; Si es menor, limpia, porque el codigo ascii 65 es la A
   02EC C1 5A         [ 2]  140 	cmpb #90		;Comparamos con el ascii 90	
   02EE 23 17         [ 3]  141 	bls sig		; Si es menor, son mayusculas, asi q sigue
   02F0 C1 61         [ 2]  142 	cmpb #97		;Del 90 al 97 hay caracteres q no nos interesan, asi q limpia
   02F2 25 37         [ 3]  143 	blo lcn_limpia
   02F4 C1 7B         [ 2]  144 	cmpb #123		;Si es superior que 123 limpia, y sino convierte
   02F6 24 33         [ 3]  145 	bhs lcn_limpia
   02F8 25 21         [ 3]  146 	blo lcn_convierte
   02FA                     147 salta:
   02FA BD 01 44      [ 8]  148     jsr wordle
   02FD 39            [ 5]  149     rts
   02FE                     150 reinicia:
   02FE C6 00         [ 2]  151     ldb #0
   0300 F7 01 9E      [ 5]  152     stb intento_actual
   0303 BD 01 7E      [ 8]  153     jsr juego
   0306 39            [ 5]  154     rts
   0307                     155 sig:
   0307 E7 80         [ 6]  156 	stb, x+
   0309 C1 0A         [ 2]  157 	cmpb #'\n
   030B 27 25         [ 3]  158 	beq lcn_finlectura
   030D 4C            [ 2]  159 	inca
   030E 20 C4         [ 3]  160 	bra lcn_lectura
   0310                     161 quita_anterior:
   0310 C6 08         [ 2]  162 	ldb #8
   0312 F7 FF 00      [ 5]  163 	stb pantalla
   0315 F7 FF 00      [ 5]  164 	stb pantalla
   0318 4A            [ 2]  165 	deca				; Decrementamos el contador para que nos deje re-escribir la palabra
   0319 20 B9         [ 3]  166 	bra lcn_lectura
   031B                     167 lcn_convierte:
                            168 
   031B 36 04         [ 6]  169 	pshu b				;Lo metemos en la pila para no perder el valor.
   031D C6 08         [ 2]  170 	ldb #8				;El cursor apunta al anterior.
   031F F7 FF 00      [ 5]  171 	stb pantalla
   0322 37 04         [ 6]  172 	pulu b				;Lo sacamos de la pila
   0324 C0 20         [ 2]  173 	subb #32			;Le resta 32 al ascii cargado en b
   0326 F7 FF 00      [ 5]  174 	stb pantalla			;Saca por pantalla y sigue
   0329 20 DC         [ 3]  175 	bra sig
                            176 	
   032B                     177 lcn_limpia:
   032B C6 08         [ 2]  178 	ldb #8
   032D F7 FF 00      [ 5]  179 	stb pantalla
   0330 20 A2         [ 3]  180 	bra lcn_lectura
   0332                     181 lcn_finlectura:
   0332 6F 82         [ 8]  182 	clr ,-x			;Borra la posicion siguiente 
   0334 20 02         [ 3]  183 	bra lcn_retorno
                            184 
   0336                     185 lcn_finlecturan:
   0336 6F 84         [ 6]  186 	clr ,x
                            187 
   0338                     188 lcn_retorno:
ASxxxx Assembler V05.00  (Motorola 6809), page 5.
Hexidecimal [16-Bits]



   0338 35 04         [ 6]  189 	puls b
   033A 39            [ 5]  190 	rts
                            191 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                            192 ;      Generador Palabra		   ;
                            193 ; Cargamos la pila y cargamos d con palabras
                            194 ; metes d dentro de la pila para q el primer caracter
                            195 ;entre en la pila, añades 1 para q vaya metiendo;
                            196 ;					    
                            197 					   
                            198 					    ;
                            199 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                            200 
   033B                     201 generar:
   033B 10 FE F0 00   [ 7]  202 	lds ps
   033F CC 04 1A      [ 3]  203 	ldd #palabras
   0342 34 06         [ 7]  204 	pshs d
   0344 C3 00 01      [ 4]  205 	addd #1
   0347 10 83 00 0A   [ 5]  206 	cmpd #'\n
   034B 27 02         [ 3]  207 	beq g_acabar
   034D 20 EC         [ 3]  208 	bra generar
   034F                     209 g_acabar: 
   034F 39            [ 5]  210 	rts
                            211 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                            212 ;				Comprueba palabra				;
                            213 ;										;
                            214 ;   Subrutina: Comprueba palabra diccionario					;
                            215 ;   										;
                            216 ;   Funcionamiento: Comprueba si la palabra introducida por el usuario	;
                            217 ;   se encuentra en el diccionario o no					;
                            218 ;										;  
                            219 ;   Registros Afectados: X,Y y CC						;
                            220 ;  										;
                            221 ;   										;
                            222 ;										;
                            223 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                            224 
                            225 
   0350                     226 comprueba:
   0350 8E 04 1A      [ 3]  227 	ldx #palabras ;Cargamos en X la direccion donde estan las palabras
   0353 10 8E 01 9F   [ 4]  228 	ldy #palabra
   0357                     229 sig_palabra:
   0357 A6 80         [ 6]  230 	lda ,x+ ; Cargamos en a el siguiente caracter de x
   0359 A1 A0         [ 6]  231 	cmpa ,y+ ;Comparamos a con el siguiente caracter de y
   035B 27 FA         [ 3]  232 	beq sig_palabra; Si es igual, que vuelva a hacer lo mismo.
   035D 81 0A         [ 2]  233 	cmpa #'\n 
   035F 27 10         [ 3]  234 	beq comprueba_final_b ; Llamamos a comprueba_final_b e indicamos q la palabra esta en el diccionario.
   0361                     235 avanza_palabra:
   0361 A6 80         [ 6]  236 	lda ,x+ ;Avanzamos a hasta q lleguemos al \n
   0363 10 8E 01 9F   [ 4]  237 	ldy #palabra ;Reiniciamos y
   0367 81 0A         [ 2]  238 	cmpa #'\n ;SI es igual, volvemos al bucle de comprobar los caracteres
   0369 27 EC         [ 3]  239 	beq sig_palabra
   036B 81 00         [ 2]  240 	cmpa #'\0
   036D 27 03         [ 3]  241 	beq comprueba_final_m
   036F 20 F0         [ 3]  242 	bra avanza_palabra
   0371                     243 comprueba_final_b:
ASxxxx Assembler V05.00  (Motorola 6809), page 6.
Hexidecimal [16-Bits]



                            244 	;ldx #palabra_bien
                            245 	;jsr imprime_cadena
   0371 39            [ 5]  246 	rts
   0372                     247 comprueba_final_m:
   0372 8E 01 AB      [ 3]  248 	ldx #palabra_mal
   0375 BD 02 91      [ 8]  249 	jsr imprime_cadena
   0378 BD 01 87      [ 8]  250 	jsr pedir_palabra
   037B 39            [ 5]  251 	rts
                            252 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                            253 ;										;
                            254 ;										;
                            255 ;			Lógica del Juego					;
                            256 ;										;
                            257 ;	Tenemos un tablero, que en la primera iteracion va a estar vacio	;
                            258 ; 	y vamos a ir guardando cada palabra en una variable, le aplicamos	;
                            259 ;	la logica para los colores, y luego mediante un bucle, vamos sacando	;
                            260 ;	cada fila (cada palabra) ya con los colores				;
                            261 ;										;
                            262 ;										;
                            263 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                            264 
                            265 ;Palabra 1
   037C                     266 inicio:
   037C C6 0A         [ 2]  267    ldb #'\n
   037E F7 FF 00      [ 5]  268    stb pantalla
   0381 F6 01 9E      [ 5]  269    ldb intento_actual
   0384 CB 31         [ 2]  270    addb #49
   0386 C1 36         [ 2]  271    cmpb #'6
   0388 27 56         [ 3]  272    beq mensaje_fallo
   038A F7 FF 00      [ 5]  273    stb pantalla
   038D 8E 02 44      [ 3]  274    ldx #barra1
   0390 BD 02 91      [ 8]  275    jsr imprime_cadena
   0393 8E 01 9F      [ 3]  276    ldx #palabra  ;Cadena leida
   0396 10 8E 02 3A   [ 4]  277    ldy #palabra1 ;String Vacia
   039A                     278 copiar: ;Esta wea copia
   039A A6 80         [ 6]  279    lda ,x+  ;Carga en a el elemento de x
   039C A7 A0         [ 6]  280    sta ,y+  ;Almacena en y lo que halla en A
   039E 81 00         [ 2]  281    cmpa #'\0  ; Lo comparas con el final
   03A0 27 02         [ 3]  282    beq reiniciar_ptr ;Si es igual, es q la copia ha finalizado y los ptrs se reinician.
   03A2 20 F6         [ 3]  283    bra copiar ;Sino, q siga copiando
   03A4                     284 reiniciar_ptr:
   03A4 8E 01 A5      [ 3]  285 	ldx #palabra_s
   03A7 10 8E 02 3A   [ 4]  286 	ldy #palabra1
   03AB                     287 comparaciones:
   03AB A6 80         [ 6]  288 	lda ,x+ ;Compara                     
   03AD 81 00         [ 2]  289 	cmpa #'\0
   03AF 27 25         [ 3]  290 	beq final_w1
   03B1 A1 A0         [ 6]  291 	cmpa ,y+
   03B3 27 02         [ 3]  292 	beq pos_correcta
   03B5 26 05         [ 3]  293 	bne otra_pos
   03B7                     294 pos_correcta:
   03B7 B7 FF 00      [ 5]  295 	sta pantalla
   03BA 20 EF         [ 3]  296 	bra comparaciones
   03BC                     297 otra_pos:
   03BC A1 A0         [ 6]  298 	cmpa ,y+
ASxxxx Assembler V05.00  (Motorola 6809), page 7.
Hexidecimal [16-Bits]



   03BE 27 06         [ 3]  299 	beq  escribe_otra_pos
   03C0 81 00         [ 2]  300 	cmpa #'\0
   03C2 27 0A         [ 3]  301 	beq  no_esta
   03C4 20 F6         [ 3]  302 	bra otra_pos
   03C6                     303 escribe_otra_pos:
   03C6 F6 02 2C      [ 5]  304 	ldb interrog
   03C9 F7 FF 00      [ 5]  305 	stb pantalla
   03CC 20 DD         [ 3]  306 	bra comparaciones
   03CE                     307 no_esta:
   03CE F6 02 2B      [ 5]  308 	ldb espacio
   03D1 F7 FF 00      [ 5]  309 	stb pantalla
   03D4 20 D5         [ 3]  310 	bra comparaciones
   03D6                     311 final_w1:
   03D6 8E 02 40      [ 3]  312 	ldx #barra
   03D9 BD 02 91      [ 8]  313 	jsr imprime_cadena
   03DC 7C 01 9E      [ 7]  314 	inc intento_actual
   03DF 39            [ 5]  315 	rts
   03E0                     316 mensaje_fallo:
   03E0 8E 02 2D      [ 3]  317 	ldx #mensaje_falloo
   03E3 BD 02 91      [ 8]  318 	jsr imprime_cadena
   03E6 20 00         [ 3]  319 	bra elegir
   03E8                     320 elegir:
   03E8 8E 03 E8      [ 3]  321 	ldx #elegir
   03EB BD 02 91      [ 8]  322 	jsr imprime_cadena
   03EE F6 FF 02      [ 5]  323 	ldb teclado
   03F1 C1 6D         [ 2]  324 	cmpb #'m
   03F3 7E 02 FA      [ 4]  325 	jmp salta
   03F6 C1 72         [ 2]  326 	cmpb #'r
   03F8 7E 02 FE      [ 4]  327 	jmp reinicia
   03FB 20 EB         [ 3]  328 	bra elegir
ASxxxx Assembler V05.00  (Motorola 6809), page 8.
Hexidecimal [16-Bits]

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
    acabar             **** GX  |   0 avanza_palabra     01C3 R
  0 barra              00A2 R   |   0 barra1             00A6 R
  0 booleano           005A R   |   0 comparaciones      020D R
  0 comprueba          01B2 GR  |   0 comprueba_fina     01D3 R
  0 comprueba_fina     01D4 R   |   0 contador           0101 GR
  0 convertir          0118 GR  |   0 copiar             01FC R
  0 elegir             024A R   |   0 escribe_otra_p     0228 R
  0 espacio            008D R   |     fin            =   FF01 
  0 final_w1           0238 R   |   0 g_acabar           01B1 R
  0 generar            019D R   |   0 ic_sgte            00F5 R
  0 imprime_cadena     00F3 GR  |   0 incrementa_a       011E GR
  0 incrementa_b       0106 R   |   0 incrementa_con     0109 R
  0 inicio             01DE GR  |   0 intento_actual     0000 R
  0 interrog           008E R   |     juego              **** GX
  0 lcn_convierte      017D R   |   0 lcn_finlectura     0194 R
  0 lcn_finlectura     0198 R   |   0 lcn_lectura        0136 R
  0 lcn_limpia         018D R   |   0 lcn_max            0128 R
  0 lcn_retorno        019A R   |   0 lee_cadena_n       0129 GR
  0 mensaje_fallo      0242 R   |   0 mensaje_falloo     008F R
  0 mensaje_vuelta     00AD R   |   0 menujogo           00AE R
  0 no_esta            0230 R   |   0 otra_pos           021E R
  0 palabra            0001 R   |   0 palabra1           009C R
  0 palabra_bien       0035 R   |   0 palabra_mal        000D R
  0 palabra_s          0007 R   |     palabras           **** GX
    pantalla       =   FF00     |     pedir_palabra      **** GX
  0 pos_correcta       0219 R   |     ps             =   F000 
    pu             =   E000     |   0 quita_anterior     0172 R
  0 reinicia           0160 R   |   0 reiniciar_ptr      0206 R
  0 ret_imprime_ca     00FE R   |   0 retorno_contad     0115 R
  0 salir_bucle        0123 GR  |   0 salta              015C R
  0 seleccionar        005B R   |   0 sig                0169 R
  0 sig_palabra        01B9 R   |     teclado        =   FF02 
    wordle             **** GX

ASxxxx Assembler V05.00  (Motorola 6809), page 9.
Hexidecimal [16-Bits]

Area Table

[_CSEG]
   0 _CODE            size  25F   flags C180
[_DSEG]
   1 _DATA            size    0   flags C0C0

