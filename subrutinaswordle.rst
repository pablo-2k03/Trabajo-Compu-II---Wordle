ASxxxx Assembler V05.00  (Motorola 6809), page 1.
Hexidecimal [16-Bits]



                              1 		.module subrutinaswordle
                              2 		
                     FF01     3 fin		.equ 0xFF01
                     FF02     4 teclado	.equ 0xFF02
                     FF00     5 pantalla	.equ 0xFF00
                     E000     6 pu		.equ 0xE000
                     F000     7 ps		.equ 0xF000
                              8 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   01C9 20 20 20 20 20 00     9 palabra: 	.asciz '     '
   01CF 4D 4F 53 43 41 00    10 palabra_s: 	.asciz "MOSCA"	
   01D5 0A 4C 61 20 70 61    11 palabra_mal:	.asciz "\nLa palabra NO esta en el diccionario.\n"
        6C 61 62 72 61 20
        4E 4F 20 65 73 74
        61 20 65 6E 20 65
        6C 20 64 69 63 63
        69 6F 6E 61 72 69
        6F 2E 0A 00
   01FD 00                   12 booleano:	.byte 0
                             13 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   01FE 20 00                14 espacio: 	.asciz " "
                             15 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                             16 ;Variables para guardar cada intento de la palabra
   0200 20 20 20 20 20 00    17 palabra1:  	.asciz "     "
   0206 20 20 20 20 20 00    18 palabra2:  	.asciz "     "
   020C 20 20 20 20 20 00    19 palabra3:  	.asciz "     "
   0212 20 20 20 20 20 00    20 palabra4:  	.asciz "     "
   0218 20 20 20 20 20 00    21 palabra5:  	.asciz "     "
   021E 20 20 20 20 20 00    22 palabra6: 	.asciz "     "
   0224 20 7C 20 00          23 barra: 	.asciz " | "
                             24 ;;;;;;;;;;;;;;;;;;;;;;;;;    Variables Globales ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                             25 	.globl imprime_cadena
                             26 	.globl contador
                             27 	.globl palabras
                             28 	.globl lee_cadena_n
                             29 	.globl convertir
                             30 	.globl incrementa_a
                             31 	.globl salir_bucle
                             32 	.globl comprueba
                             33 	.globl pedir_palabra
                             34 	.globl lpi
                             35 	.globl lpi2
                             36 	.globl lpi3
                             37 	.globl lpi4
                             38 	.globl lpi5
                             39 	.globl lpi6
                             40 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                             41 ;	Subrutina: Imprime cadena						  ;
                             42 ;	Funcionamiento: Imprime una cadena leida por teclado o ya establecida. ;  
                             43 ;	Registros Afectados: CC						  ;
                             44 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
   0228                      45 imprime_cadena:
   0228 36 12         [ 7]   46 	pshu a,x
                             47 	
   022A                      48 ic_sgte:
   022A A6 80         [ 6]   49 	lda ,x+
ASxxxx Assembler V05.00  (Motorola 6809), page 2.
Hexidecimal [16-Bits]



   022C 27 05         [ 3]   50 	beq ret_imprime_cadena
   022E B7 FF 00      [ 5]   51 	sta pantalla
   0231 20 F7         [ 3]   52 	bra ic_sgte
                             53 
   0233                      54 ret_imprime_cadena:
   0233 37 12         [ 7]   55 	pulu a,x
   0235 39            [ 5]   56 	rts
                             57 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                             58 ;	Subrutina: Contador de palabras					  ;
                             59 ;	Funcionamiento: Cuenta el numero de palabras en diccionario. 	  ;  
                             60 ;	Registros Afectados: B,CC						  ;
                             61 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		
   0236                      62 contador:
   0236 36 12         [ 7]   63 	pshu a,x
   0238 5F            [ 2]   64 	clrb
   0239 20 03         [ 3]   65 	bra incrementa_contador
   023B                      66 incrementa_b:
   023B 5C            [ 2]   67 	incb
   023C 20 00         [ 3]   68 	bra incrementa_contador
   023E                      69 incrementa_contador:
   023E A6 80         [ 6]   70 	lda ,x+
   0240 81 00         [ 2]   71 	cmpa #'\0
   0242 27 06         [ 3]   72 	beq retorno_contador
   0244 81 0A         [ 2]   73 	cmpa #'\n
   0246 27 F3         [ 3]   74 	beq incrementa_b
   0248 20 F4         [ 3]   75 	bra incrementa_contador
   024A                      76 retorno_contador:
   024A 37 12         [ 7]   77 	pulu a,x
   024C 39            [ 5]   78 	rts
                             79 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                             80 ;	Subrutina: convertir (contador palabras diccionario)			  ;
                             81 ;	Funcionamiento: Vamos restando el registro B y a su vez incrementando a;
                             82 ;	Registros Afectados: A,B,CC.						  ;
                             83 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   024D                      84 convertir:
   024D C1 0A         [ 2]   85 	cmpb #10
   024F 2C 02         [ 3]   86 	bge incrementa_a 
   0251 20 05         [ 3]   87 	bra salir_bucle
   0253                      88 incrementa_a:
   0253 4C            [ 2]   89 	inca
   0254 C0 0A         [ 2]   90 	subb #10
   0256 20 F5         [ 3]   91 	bra convertir
   0258                      92 salir_bucle:
   0258 8B 30         [ 2]   93 	adda #48
   025A CB 30         [ 2]   94 	addb #48
   025C 39            [ 5]   95 	rts
                             96 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                             97 ;				LCN MAX 					;
                             98 ;										;
                             99 ;   Le pasamos el numero a leer antes de llamar a la funcion.		;
                            100 ;   Cargamos la pila con b, testeamos a, si es igual a 0 se devuelve		;
                            101 ;   sino, guarda lcn_max en a y limpia a					;
                            102 ;										;
                            103 ;   Lemos la cadena y comparamos con el \n, si es 0 se acaba y sino vuelve   ;  
                            104 ;   a leer.									;
ASxxxx Assembler V05.00  (Motorola 6809), page 3.
Hexidecimal [16-Bits]



                            105 ;  										;
                            106 ;   Registros Afectados: A y CC						;
                            107 ;										;
                            108 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   025D 00                  109 lcn_max: .byte 0
                            110 
   025E                     111 lee_cadena_n:
   025E 34 04         [ 6]  112 	pshs b
   0260 8E 01 C9      [ 3]  113 	ldx #palabra
   0263 4D            [ 2]  114 	tsta
   0264 27 54         [ 3]  115 	beq lcn_retorno
   0266 4A            [ 2]  116 	deca
   0267 B7 02 5D      [ 5]  117 	sta lcn_max
   026A 4F            [ 2]  118 	clra
   026B                     119 lcn_lectura:
   026B B1 02 5D      [ 5]  120 	cmpa lcn_max
   026E 24 48         [ 3]  121 	bhs  lcn_finlecturan
   0270 F6 FF 02      [ 5]  122 	ldb teclado
   0273 C1 20         [ 2]  123 	cmpb #32
   0275 27 1B         [ 3]  124 	beq quita_anterior
   0277 C1 41         [ 2]  125 	cmpb #65 		;Comparamos con el codigo ascii 65
   0279 25 32         [ 3]  126 	blo lcn_limpia		; Si es menor, limpia, porque el codigo ascii 65 es la A
   027B C1 5A         [ 2]  127 	cmpb #90		;Comparamos con el ascii 90	
   027D 23 0A         [ 3]  128 	bls sig		; Si es menor, son mayusculas, asi q sigue
   027F C1 61         [ 2]  129 	cmpb #97		;Del 90 al 97 hay caracteres q no nos interesan, asi q limpia
   0281 25 2A         [ 3]  130 	blo lcn_limpia
   0283 C1 7B         [ 2]  131 	cmpb #123		;Si es superior que 123 limpia, y sino convierte
   0285 24 26         [ 3]  132 	bhs lcn_limpia
   0287 25 14         [ 3]  133 	blo lcn_convierte
   0289                     134 sig:
   0289 E7 80         [ 6]  135 	stb, x+
   028B C1 0A         [ 2]  136 	cmpb #'\n
   028D 27 25         [ 3]  137 	beq lcn_finlectura
   028F 4C            [ 2]  138 	inca
   0290 20 D9         [ 3]  139 	bra lcn_lectura
   0292                     140 quita_anterior:
   0292 C6 08         [ 2]  141 	ldb #8
   0294 F7 FF 00      [ 5]  142 	stb pantalla
   0297 F7 FF 00      [ 5]  143 	stb pantalla
   029A 4A            [ 2]  144 	deca				; Decrementamos el contador para que nos deje re-escribir la palabra
   029B 20 CE         [ 3]  145 	bra lcn_lectura
   029D                     146 lcn_convierte:
                            147 
   029D 36 04         [ 6]  148 	pshu b				;Lo metemos en la pila para no perder el valor.
   029F C6 08         [ 2]  149 	ldb #8				;El cursor apunta al anterior.
   02A1 F7 FF 00      [ 5]  150 	stb pantalla
   02A4 37 04         [ 6]  151 	pulu b				;Lo sacamos de la pila
   02A6 C0 20         [ 2]  152 	subb #32			;Le resta 32 al ascii cargado en b
   02A8 F7 FF 00      [ 5]  153 	stb pantalla			;Saca por pantalla y sigue
   02AB 20 DC         [ 3]  154 	bra sig
                            155 	
   02AD                     156 lcn_limpia:
   02AD C6 08         [ 2]  157 	ldb #8
   02AF F7 FF 00      [ 5]  158 	stb pantalla
   02B2 20 B7         [ 3]  159 	bra lcn_lectura
ASxxxx Assembler V05.00  (Motorola 6809), page 4.
Hexidecimal [16-Bits]



   02B4                     160 lcn_finlectura:
   02B4 6F 82         [ 8]  161 	clr ,-x			;Borra la posicion siguiente 
   02B6 20 02         [ 3]  162 	bra lcn_retorno
                            163 
   02B8                     164 lcn_finlecturan:
   02B8 6F 84         [ 6]  165 	clr ,x
                            166 
   02BA                     167 lcn_retorno:
   02BA 35 04         [ 6]  168 	puls b
   02BC 39            [ 5]  169 	rts
                            170 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                            171 ;      Generador Palabra		   ;
                            172 ; Cargamos la pila y cargamos d con palabras
                            173 ; metes d dentro de la pila para q el primer caracter
                            174 ;entre en la pila, añades 1 para q vaya metiendo;
                            175 ;					    
                            176 					   
                            177 					    ;
                            178 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                            179 
   02BD                     180 generar:
   02BD 10 FE F0 00   [ 7]  181 	lds ps
   02C1 CC 04 B3      [ 3]  182 	ldd #palabras
   02C4 34 06         [ 7]  183 	pshs d
   02C6 C3 00 01      [ 4]  184 	addd #1
   02C9 10 83 00 0A   [ 5]  185 	cmpd #'\n
   02CD 27 02         [ 3]  186 	beq g_acabar
   02CF 20 EC         [ 3]  187 	bra generar
   02D1                     188 g_acabar: 
   02D1 39            [ 5]  189 	rts
                            190 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                            191 ;				Comprueba palabra				;
                            192 ;										;
                            193 ;   Subrutina: Comprueba palabra diccionario					;
                            194 ;   										;
                            195 ;   Funcionamiento: Comprueba si la palabra introducida por el usuario	;
                            196 ;   se encuentra en el diccionario o no					;
                            197 ;										;  
                            198 ;   Registros Afectados: X,Y y CC						;
                            199 ;  										;
                            200 ;   										;
                            201 ;										;
                            202 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                            203 
                            204 
   02D2                     205 comprueba:
   02D2 8E 04 B3      [ 3]  206 	ldx #palabras ;Cargamos en X la direccion donde estan las palabras
   02D5 10 8E 01 C9   [ 4]  207 	ldy #palabra
   02D9                     208 sig_palabra:
   02D9 A6 80         [ 6]  209 	lda ,x+ ; Cargamos en a el siguiente caracter de x
   02DB A1 A0         [ 6]  210 	cmpa ,y+ ;Comparamos a con el siguiente caracter de y
   02DD 27 FA         [ 3]  211 	beq sig_palabra; Si es igual, que vuelva a hacer lo mismo.
   02DF 81 0A         [ 2]  212 	cmpa #'\n 
   02E1 27 10         [ 3]  213 	beq comprueba_final_b ; Llamamos a comprueba_final_b e indicamos q la palabra esta en el diccionario.
   02E3                     214 avanza_palabra:
ASxxxx Assembler V05.00  (Motorola 6809), page 5.
Hexidecimal [16-Bits]



   02E3 A6 80         [ 6]  215 	lda ,x+ ;Avanzamos a hasta q lleguemos al \n
   02E5 10 8E 01 C9   [ 4]  216 	ldy #palabra ;Reiniciamos y
   02E9 81 0A         [ 2]  217 	cmpa #'\n ;SI es igual, volvemos al bucle de comprobar los caracteres
   02EB 27 EC         [ 3]  218 	beq sig_palabra
   02ED 81 00         [ 2]  219 	cmpa #'\0
   02EF 27 03         [ 3]  220 	beq comprueba_final_m
   02F1 20 F0         [ 3]  221 	bra avanza_palabra
   02F3                     222 comprueba_final_b:
                            223 	;jsr juego
   02F3 39            [ 5]  224 	rts
   02F4                     225 comprueba_final_m:
   02F4 8E 01 D5      [ 3]  226 	ldx #palabra_mal
   02F7 BD 02 28      [ 8]  227 	jsr imprime_cadena
   02FA BD 01 87      [ 8]  228 	jsr pedir_palabra
   02FD 39            [ 5]  229 	rts
                            230 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                            231 ;										;
                            232 ;										;
                            233 ;			Lógica del Juego					;
                            234 ;										;
                            235 ;	Tenemos un tablero, que en la primera iteracion va a estar vacio	;
                            236 ; 	y vamos a ir guardando cada palabra en una variable, le aplicamos	;
                            237 ;	la logica para los colores, y luego mediante un bucle, vamos sacando	;
                            238 ;	cada fila (cada palabra) ya con los colores				;
                            239 ;										;
                            240 ;										;
                            241 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                            242 ;		0-Verde 1-Amarillo 2-Rojo 3-Blanco				;
                            243 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                            244 ;Palabra 1
   02FE                     245 lpi:
   02FE 20 35         [ 3]  246 	bra imprime_inicio
   0300                     247 lp_carga:
   0300 10 8E 01 CF   [ 4]  248 	ldy #palabra_s
   0304 8E 02 00      [ 3]  249 	ldx #palabra1
   0307                     250 logica_principal:
   0307 A6 80         [ 6]  251 	lda ,x+
   0309 81 00         [ 2]  252 	cmpa #'\0
   030B 27 27         [ 3]  253 	beq lp_fin
   030D A1 A0         [ 6]  254 	cmpa ,y+	
   030F 27 02         [ 3]  255 	beq lp_bien
   0311 26 06         [ 3]  256 	bne lp_comp
   0313                     257 lp_bien:
   0313 BD 02 28      [ 8]  258 	jsr imprime_cadena
   0316 B7 FF 00      [ 5]  259 	sta pantalla
   0319                     260 lp_comp:
   0319 A1 A0         [ 6]  261 	cmpa ,y+
   031B 27 08         [ 3]  262 	beq lp_estan
   031D 10 8C 00 00   [ 5]  263 	cmpy #'\0
   0321 27 0A         [ 3]  264 	beq lp_mal
   0323 20 F4         [ 3]  265 	bra lp_comp
   0325                     266 lp_estan:
   0325 8E 00 3F      [ 3]  267 	ldx #'?
   0328 BD 02 28      [ 8]  268 	jsr imprime_cadena
   032B 20 D3         [ 3]  269 	bra lp_carga
ASxxxx Assembler V05.00  (Motorola 6809), page 6.
Hexidecimal [16-Bits]



   032D                     270 lp_mal:
   032D 86 FE         [ 2]  271 	lda #espacio
   032F B7 FF 00      [ 5]  272 	sta pantalla
   0332 20 CC         [ 3]  273 	bra lp_carga 
   0334                     274 lp_fin:
   0334 39            [ 5]  275 	rts
   0335                     276 imprime_inicio:
   0335 86 01         [ 2]  277 	lda #1
   0337 B7 FF 00      [ 5]  278 	sta pantalla
   033A 8E 02 24      [ 3]  279 	ldx #barra
   033D BD 02 28      [ 8]  280 	jsr imprime_cadena
   0340 20 BE         [ 3]  281 	bra lp_carga
                            282 ;Palabra 2
   0342                     283 lpi2:
   0342 20 F1         [ 3]  284 	bra imprime_inicio
   0344                     285 lp_carga2:
   0344 10 8E 01 CF   [ 4]  286 	ldy #palabra_s
   0348 8E 02 06      [ 3]  287 	ldx #palabra2
   034B                     288 logica_principal2:
   034B A6 80         [ 6]  289 	lda ,x+
   034D 81 00         [ 2]  290 	cmpa #'\0
   034F 27 27         [ 3]  291 	beq lp_fin2
   0351 A1 A0         [ 6]  292 	cmpa ,y+	
   0353 27 02         [ 3]  293 	beq lp_bien2
   0355 26 06         [ 3]  294 	bne lp_comp2
   0357                     295 lp_bien2:
   0357 BD 02 28      [ 8]  296 	jsr imprime_cadena
   035A B7 FF 00      [ 5]  297 	sta pantalla
   035D                     298 lp_comp2:
   035D A1 A0         [ 6]  299 	cmpa ,y+
   035F 27 08         [ 3]  300 	beq lp_estan2
   0361 10 8C 00 00   [ 5]  301 	cmpy #'\0
   0365 27 0A         [ 3]  302 	beq lp_mal2
   0367 20 F4         [ 3]  303 	bra lp_comp2
   0369                     304 lp_estan2:
   0369 8E 00 3F      [ 3]  305 	ldx #'?
   036C BD 02 28      [ 8]  306 	jsr imprime_cadena
   036F 20 D3         [ 3]  307 	bra lp_carga2
   0371                     308 lp_mal2:
   0371 86 FE         [ 2]  309 	lda #espacio
   0373 B7 FF 00      [ 5]  310 	sta pantalla
   0376 20 CC         [ 3]  311 	bra lp_carga2 
   0378                     312 lp_fin2:
   0378 39            [ 5]  313 	rts
   0379                     314 imprime_inicio2:
   0379 86 02         [ 2]  315 	lda #2
   037B B7 FF 00      [ 5]  316 	sta pantalla
   037E 8E 02 24      [ 3]  317 	ldx #barra
   0381 BD 02 28      [ 8]  318 	jsr imprime_cadena
   0384 20 BE         [ 3]  319 	bra lp_carga2
                            320 ;Palabra 3
   0386                     321 lpi3:
   0386 20 35         [ 3]  322 	bra imprime_inicio3
   0388                     323 lp_carga3:
   0388 10 8E 01 CF   [ 4]  324 	ldy #palabra_s
ASxxxx Assembler V05.00  (Motorola 6809), page 7.
Hexidecimal [16-Bits]



   038C 8E 02 0C      [ 3]  325 	ldx #palabra3
   038F                     326 logica_principal3:
   038F A6 80         [ 6]  327 	lda ,x+
   0391 81 00         [ 2]  328 	cmpa #'\0
   0393 27 27         [ 3]  329 	beq lp_fin3
   0395 A1 A0         [ 6]  330 	cmpa ,y+	
   0397 27 02         [ 3]  331 	beq lp_bien3
   0399 26 06         [ 3]  332 	bne lp_comp3
   039B                     333 lp_bien3:
   039B BD 02 28      [ 8]  334 	jsr imprime_cadena
   039E B7 FF 00      [ 5]  335 	sta pantalla
   03A1                     336 lp_comp3:
   03A1 A1 A0         [ 6]  337 	cmpa ,y+
   03A3 27 08         [ 3]  338 	beq lp_estan3
   03A5 10 8C 00 00   [ 5]  339 	cmpy #'\0
   03A9 27 0A         [ 3]  340 	beq lp_mal3
   03AB 20 F4         [ 3]  341 	bra lp_comp3
   03AD                     342 lp_estan3:
   03AD 8E 00 3F      [ 3]  343 	ldx #'?
   03B0 BD 02 28      [ 8]  344 	jsr imprime_cadena
   03B3 20 D3         [ 3]  345 	bra lp_carga3
   03B5                     346 lp_mal3:
   03B5 86 FE         [ 2]  347 	lda #espacio
   03B7 B7 FF 00      [ 5]  348 	sta pantalla
   03BA 20 CC         [ 3]  349 	bra lp_carga3 
   03BC                     350 lp_fin3:
   03BC 39            [ 5]  351 	rts
   03BD                     352 imprime_inicio3:
   03BD 86 03         [ 2]  353 	lda #3
   03BF B7 FF 00      [ 5]  354 	sta pantalla
   03C2 8E 02 24      [ 3]  355 	ldx #barra
   03C5 BD 02 28      [ 8]  356 	jsr imprime_cadena
   03C8 20 BE         [ 3]  357 	bra lp_carga3
                            358 ;Palabra 4
   03CA                     359 lpi4:
   03CA 20 35         [ 3]  360 	bra imprime_inicio4
   03CC                     361 lp_carga4:
   03CC 10 8E 01 CF   [ 4]  362 	ldy #palabra_s
   03D0 8E 02 12      [ 3]  363 	ldx #palabra4
   03D3                     364 logica_principal4:
   03D3 A6 80         [ 6]  365 	lda ,x+
   03D5 81 00         [ 2]  366 	cmpa #'\0
   03D7 27 27         [ 3]  367 	beq lp_fin4
   03D9 A1 A0         [ 6]  368 	cmpa ,y+	
   03DB 27 02         [ 3]  369 	beq lp_bien4
   03DD 26 06         [ 3]  370 	bne lp_comp4
   03DF                     371 lp_bien4:
   03DF BD 02 28      [ 8]  372 	jsr imprime_cadena
   03E2 B7 FF 00      [ 5]  373 	sta pantalla
   03E5                     374 lp_comp4:
   03E5 A1 A0         [ 6]  375 	cmpa ,y+
   03E7 27 08         [ 3]  376 	beq lp_estan4
   03E9 10 8C 00 00   [ 5]  377 	cmpy #'\0
   03ED 27 0A         [ 3]  378 	beq lp_mal4
   03EF 20 F4         [ 3]  379 	bra lp_comp4
ASxxxx Assembler V05.00  (Motorola 6809), page 8.
Hexidecimal [16-Bits]



   03F1                     380 lp_estan4:
   03F1 8E 00 3F      [ 3]  381 	ldx #'?
   03F4 BD 02 28      [ 8]  382 	jsr imprime_cadena
   03F7 20 D3         [ 3]  383 	bra lp_carga4
   03F9                     384 lp_mal4:
   03F9 86 FE         [ 2]  385 	lda #espacio
   03FB B7 FF 00      [ 5]  386 	sta pantalla
   03FE 20 CC         [ 3]  387 	bra lp_carga4
   0400                     388 lp_fin4:
   0400 39            [ 5]  389 	rts
   0401                     390 imprime_inicio4:
   0401 86 04         [ 2]  391 	lda #4
   0403 B7 FF 00      [ 5]  392 	sta pantalla
   0406 8E 02 24      [ 3]  393 	ldx #barra
   0409 BD 02 28      [ 8]  394 	jsr imprime_cadena
   040C 20 BE         [ 3]  395 	bra lp_carga4
                            396 ;Palabra 5
   040E                     397 lpi5:
   040E 20 35         [ 3]  398 	bra imprime_inicio5
   0410                     399 lp_carga5:
   0410 10 8E 01 CF   [ 4]  400 	ldy #palabra_s
   0414 8E 02 18      [ 3]  401 	ldx #palabra5
   0417                     402 logica_principal5:
   0417 A6 80         [ 6]  403 	lda ,x+
   0419 81 00         [ 2]  404 	cmpa #'\0
   041B 27 27         [ 3]  405 	beq lp_fin5
   041D A1 A0         [ 6]  406 	cmpa ,y+	
   041F 27 02         [ 3]  407 	beq lp_bien5
   0421 26 06         [ 3]  408 	bne lp_comp5
   0423                     409 lp_bien5:
   0423 BD 02 28      [ 8]  410 	jsr imprime_cadena
   0426 B7 FF 00      [ 5]  411 	sta pantalla
   0429                     412 lp_comp5:
   0429 A1 A0         [ 6]  413 	cmpa ,y+
   042B 27 08         [ 3]  414 	beq lp_estan5
   042D 10 8C 00 00   [ 5]  415 	cmpy #'\0
   0431 27 0A         [ 3]  416 	beq lp_mal5
   0433 20 F4         [ 3]  417 	bra lp_comp5
   0435                     418 lp_estan5:
   0435 8E 00 3F      [ 3]  419 	ldx #'?
   0438 BD 02 28      [ 8]  420 	jsr imprime_cadena
   043B 20 D3         [ 3]  421 	bra lp_carga5
   043D                     422 lp_mal5:
   043D 86 FE         [ 2]  423 	lda #espacio
   043F B7 FF 00      [ 5]  424 	sta pantalla
   0442 20 CC         [ 3]  425 	bra lp_carga5 
   0444                     426 lp_fin5:
   0444 39            [ 5]  427 	rts
   0445                     428 imprime_inicio5:
   0445 86 05         [ 2]  429 	lda #5
   0447 B7 FF 00      [ 5]  430 	sta pantalla
   044A 8E 02 24      [ 3]  431 	ldx #barra
   044D BD 02 28      [ 8]  432 	jsr imprime_cadena
   0450 20 BE         [ 3]  433 	bra lp_carga5
                            434 ;Palabra 6
ASxxxx Assembler V05.00  (Motorola 6809), page 9.
Hexidecimal [16-Bits]



   0452                     435 lpi6:
   0452 20 35         [ 3]  436 	bra imprime_inicio6
   0454                     437 lp_carga6:
   0454 10 8E 01 CF   [ 4]  438 	ldy #palabra_s
   0458 8E 02 1E      [ 3]  439 	ldx #palabra6
   045B                     440 logica_principal6:
   045B A6 80         [ 6]  441 	lda ,x+
   045D 81 00         [ 2]  442 	cmpa #'\0
   045F 27 27         [ 3]  443 	beq lp_fin6
   0461 A1 A0         [ 6]  444 	cmpa ,y+	
   0463 27 02         [ 3]  445 	beq lp_bien6
   0465 26 06         [ 3]  446 	bne lp_comp6
   0467                     447 lp_bien6:
   0467 BD 02 28      [ 8]  448 	jsr imprime_cadena
   046A B7 FF 00      [ 5]  449 	sta pantalla
   046D                     450 lp_comp6:
   046D A1 A0         [ 6]  451 	cmpa ,y+
   046F 27 08         [ 3]  452 	beq lp_estan6
   0471 10 8C 00 00   [ 5]  453 	cmpy #'\0
   0475 27 0A         [ 3]  454 	beq lp_mal6
   0477 20 F4         [ 3]  455 	bra lp_comp6
   0479                     456 lp_estan6:
   0479 8E 00 3F      [ 3]  457 	ldx #'?
   047C BD 02 28      [ 8]  458 	jsr imprime_cadena
   047F 20 D3         [ 3]  459 	bra lp_carga6
   0481                     460 lp_mal6:
   0481 86 FE         [ 2]  461 	lda #espacio
   0483 B7 FF 00      [ 5]  462 	sta pantalla
   0486 20 CC         [ 3]  463 	bra lp_carga6 
   0488                     464 lp_fin6:
   0488 39            [ 5]  465 	rts
   0489                     466 imprime_inicio6:
   0489 86 06         [ 2]  467 	lda #6
   048B B7 FF 00      [ 5]  468 	sta pantalla
   048E 8E 02 24      [ 3]  469 	ldx #barra
   0491 BD 02 28      [ 8]  470 	jsr imprime_cadena
   0494 20 BE         [ 3]  471 	bra lp_carga6
ASxxxx Assembler V05.00  (Motorola 6809), page 10.
Hexidecimal [16-Bits]

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  0 avanza_palabra     011A R   |   0 barra              005B R
  0 booleano           0034 R   |   0 comprueba          0109 GR
  0 comprueba_fina     012A R   |   0 comprueba_fina     012B R
  0 contador           006D GR  |   0 convertir          0084 GR
  0 espacio            0035 R   |     fin            =   FF01 
  0 g_acabar           0108 R   |   0 generar            00F4 R
  0 ic_sgte            0061 R   |   0 imprime_cadena     005F GR
  0 imprime_inicio     016C R   |   0 imprime_inicio     01B0 R
  0 imprime_inicio     01F4 R   |   0 imprime_inicio     0238 R
  0 imprime_inicio     027C R   |   0 imprime_inicio     02C0 R
  0 incrementa_a       008A GR  |   0 incrementa_b       0072 R
  0 incrementa_con     0075 R   |   0 lcn_convierte      00D4 R
  0 lcn_finlectura     00EB R   |   0 lcn_finlectura     00EF R
  0 lcn_lectura        00A2 R   |   0 lcn_limpia         00E4 R
  0 lcn_max            0094 R   |   0 lcn_retorno        00F1 R
  0 lee_cadena_n       0095 GR  |   0 logica_princip     013E R
  0 logica_princip     0182 R   |   0 logica_princip     01C6 R
  0 logica_princip     020A R   |   0 logica_princip     024E R
  0 logica_princip     0292 R   |   0 lp_bien            014A R
  0 lp_bien2           018E R   |   0 lp_bien3           01D2 R
  0 lp_bien4           0216 R   |   0 lp_bien5           025A R
  0 lp_bien6           029E R   |   0 lp_carga           0137 R
  0 lp_carga2          017B R   |   0 lp_carga3          01BF R
  0 lp_carga4          0203 R   |   0 lp_carga5          0247 R
  0 lp_carga6          028B R   |   0 lp_comp            0150 R
  0 lp_comp2           0194 R   |   0 lp_comp3           01D8 R
  0 lp_comp4           021C R   |   0 lp_comp5           0260 R
  0 lp_comp6           02A4 R   |   0 lp_estan           015C R
  0 lp_estan2          01A0 R   |   0 lp_estan3          01E4 R
  0 lp_estan4          0228 R   |   0 lp_estan5          026C R
  0 lp_estan6          02B0 R   |   0 lp_fin             016B R
  0 lp_fin2            01AF R   |   0 lp_fin3            01F3 R
  0 lp_fin4            0237 R   |   0 lp_fin5            027B R
  0 lp_fin6            02BF R   |   0 lp_mal             0164 R
  0 lp_mal2            01A8 R   |   0 lp_mal3            01EC R
  0 lp_mal4            0230 R   |   0 lp_mal5            0274 R
  0 lp_mal6            02B8 R   |   0 lpi                0135 GR
  0 lpi2               0179 GR  |   0 lpi3               01BD GR
  0 lpi4               0201 GR  |   0 lpi5               0245 GR
  0 lpi6               0289 GR  |   0 palabra            0000 R
  0 palabra1           0037 R   |   0 palabra2           003D R
  0 palabra3           0043 R   |   0 palabra4           0049 R
  0 palabra5           004F R   |   0 palabra6           0055 R
  0 palabra_mal        000C R   |   0 palabra_s          0006 R
    palabras           **** GX  |     pantalla       =   FF00 
    pedir_palabra      **** GX  |     ps             =   F000 
    pu             =   E000     |   0 quita_anterior     00C9 R
  0 ret_imprime_ca     006A R   |   0 retorno_contad     0081 R
  0 salir_bucle        008F GR  |   0 sig                00C0 R
  0 sig_palabra        0110 R   |     teclado        =   FF02 

ASxxxx Assembler V05.00  (Motorola 6809), page 11.
Hexidecimal [16-Bits]

Area Table

[_CSEG]
   0 _CODE            size  2CD   flags C180
[_DSEG]
   1 _DATA            size    0   flags C0C0

