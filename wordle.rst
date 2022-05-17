ASxxxx Assembler V05.00  (Motorola 6809), page 1.
Hexidecimal [16-Bits]



                              1 			.module wordle
                              2 ;+----------------------------------------------+
                              3 ;                      WORDLE  	  	  ;
                              4 ; 	¬Pablo Agüera Hernández  		  ;
                              5 ; 	¬Eduardo Juanes Ramos    		  ;
                              6 ;+----------------------------------------------+
                     FF01     7 fin		.equ 0xFF01
                     FF02     8 teclado 	.equ 0xFF02
                     FF00     9 pantalla	.equ 0xFF00		
                     F000    10 pu		.equ 0xF000
                     B000    11 ps		.equ 0xB000
                             12 
                             13 
                             14 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   0000                      15 menu: 	
   0000 1B 5B 32 4A 1B 5B    16 	.ascii "\33[2J\33[H" ;Limpia la pantalla y pone el cursor arriba.
        48
   0007 0A 2B 2D 2D 2D 2D    17 	.ascii	"\n+-----------------------------+\n"
        2D 2D 2D 2D 2D 2D
        2D 2D 2D 2D 2D 2D
        2D 2D 2D 2D 2D 2D
        2D 2D 2D 2D 2D 2D
        2D 2B 0A
   0028 7C 20 20 20 20 20    18 	.ascii	"|           WORDLE            |\n"
        20 20 20 20 20 20
        57 4F 52 44 4C 45
        20 20 20 20 20 20
        20 20 20 20 20 20
        7C 0A
   0048 2B 2D 2D 2D 2D 2D    19 	.ascii	"+-----------------------------+\n"
        2D 2D 2D 2D 2D 2D
        2D 2D 2D 2D 2D 2D
        2D 2D 2D 2D 2D 2D
        2D 2D 2D 2D 2D 2D
        2B 0A
   0068 31 29 20 56 45 52    20 	.ascii  "1) VER DICCIONARIO\n"
        20 44 49 43 43 49
        4F 4E 41 52 49 4F
        0A
   007B 32 29 20 4A 55 47    21 	.ascii  "2) JUGAR\n"
        41 52 0A
   0084 33 29 20 53 41 4C    22 	.ascii  "3) SALIR\n"
        49 52 0A
   008D 0A 49 6E 74 72 6F    23 	.asciz "\nIntroduzca una opcion: "
        64 75 7A 63 61 20
        75 6E 61 20 6F 70
        63 69 6F 6E 3A 20
        00
   00A6                      24 menujogo:
   00A6 1B 5B 32 4A 1B 5B    25 	.ascii "\33[2J\33[H" ;Limpia la pantalla y pone el cursor arriba.
        48
   00AD 0A 20 20 20 20 20    26 	.ascii "\n     | BIEN  | ESTAN | \n"
        7C 20 42 49 45 4E
        20 20 7C 20 45 53
        54 41 4E 20 7C 20
ASxxxx Assembler V05.00  (Motorola 6809), page 2.
Hexidecimal [16-Bits]



        0A
   00C6 2D 2D 2D 2D 2D 2D    27 	.ascii "----------------------\n"
        2D 2D 2D 2D 2D 2D
        2D 2D 2D 2D 2D 2D
        2D 2D 2D 2D 0A
   00DD 20 20 20 20 20 7C    28 	.ascii "     | 12345 | 12345 | \n"
        20 31 32 33 34 35
        20 7C 20 31 32 33
        34 35 20 7C 20 0A
   00F5 2D 2D 2D 2D 2D 2D    29 	.asciz "----------------------"
        2D 2D 2D 2D 2D 2D
        2D 2D 2D 2D 2D 2D
        2D 2D 2D 2D 00
   010C                      30 int_palabra:
   010C 0A 49 6E 74 72 6F    31 	.asciz "\nIntroduzca la palabra: "
        64 75 7A 63 61 20
        6C 61 20 70 61 6C
        61 62 72 61 3A 20
        00
                             32 
   0125                      33 err:
   0125 0A 45 72 72 6F 72    34 	.asciz "\nError, valor introducido no valido, introduzca un nuevo valor."
        2C 20 76 61 6C 6F
        72 20 69 6E 74 72
        6F 64 75 63 69 64
        6F 20 6E 6F 20 76
        61 6C 69 64 6F 2C
        20 69 6E 74 72 6F
        64 75 7A 63 61 20
        75 6E 20 6E 75 65
        76 6F 20 76 61 6C
        6F 72 2E 00
                             35 
                             36 			.globl wordle
                             37 			.globl imprime_cadena
                             38 			.globl palabras
                             39 			.globl numero_palabras
                             40 			.globl return_c
                             41 			.globl lee_cadena_n
                             42 			.globl presentar_diccionario
                             43 			.globl comprueba
                             44 			.globl pedir_palabra
                             45 			.globl inicio
                             46 			.globl juego
                             47 			.globl acabar
                             48 			.globl mensaje_fallo
                             49 			.globl inicio2
                             50 			.globl inicio_genera
   0165                      51 wordle:
   0165 10 CE B0 00   [ 4]   52 	lds #ps
   0169 CE F0 00      [ 3]   53 	ldu #pu
   016C BD 03 B7      [ 8]   54 	jsr inicio_genera
   016F 8E 00 00      [ 3]   55 	ldx #menu
   0172 BD 03 00      [ 8]   56 	jsr imprime_cadena		
                             57 
ASxxxx Assembler V05.00  (Motorola 6809), page 3.
Hexidecimal [16-Bits]



   0175                      58 opcion:
   0175 B6 FF 02      [ 5]   59 	lda teclado
   0178 81 31         [ 2]   60 	cmpa #'1
   017A 27 0A         [ 3]   61 	beq diccionario
   017C 81 32         [ 2]   62 	cmpa #'2
   017E 27 22         [ 3]   63 	beq juego
   0180 81 33         [ 2]   64 	cmpa #'3
   0182 27 44         [ 3]   65 	beq acabar
   0184 20 14         [ 3]   66 	bra error
                             67 	
   0186                      68 diccionario:
   0186 8E 04 CF      [ 3]   69 	ldx #presentar_diccionario
   0189 BD 03 00      [ 8]   70 	jsr imprime_cadena
   018C 8E 04 EC      [ 3]   71 	ldx #palabras
   018F BD 03 00      [ 8]   72 	jsr imprime_cadena
   0192 BD 05 6B      [ 8]   73 	jsr return_c
   0195 B6 FF 02      [ 5]   74 	lda teclado	;Como system("pause") de C, hasta q no meta nada por teclado no avanza.
   0198 20 CB         [ 3]   75 	bra wordle
   019A                      76 error:
   019A 8E 01 25      [ 3]   77 	ldx #err
   019D BD 03 00      [ 8]   78 	jsr imprime_cadena
   01A0 20 D3         [ 3]   79 	bra opcion
                             80 
   01A2                      81 juego:
   01A2 8E 00 A6      [ 3]   82 	ldx #menujogo
   01A5 BD 03 00      [ 8]   83 	jsr imprime_cadena
   01A8 BD 01 AB      [ 8]   84 	jsr pedir_palabra
   01AB                      85 pedir_palabra:
   01AB C1 36         [ 2]   86 	cmpb #'6
   01AD 27 16         [ 3]   87 	beq intentos_acabados
   01AF 8E 01 0C      [ 3]   88 	ldx #int_palabra
   01B2 BD 03 00      [ 8]   89 	jsr imprime_cadena
   01B5                      90 lee_cadena:
   01B5 86 06         [ 2]   91 	lda #6	;Numero maximo de caracteres q pueden introducir(n-1)
   01B7 BD 03 39      [ 8]   92 	jsr lee_cadena_n
   01BA BD 03 E4      [ 8]   93 	jsr comprueba
   01BD BD 04 10      [ 8]   94 	jsr inicio
   01C0 BD 04 51      [ 8]   95 	jsr inicio2
   01C3 20 F0         [ 3]   96 	bra lee_cadena
                             97 
   01C5                      98 intentos_acabados:
   01C5 BD 04 B0      [ 8]   99 	jsr mensaje_fallo
   01C8                     100 acabar:
   01C8 4F            [ 2]  101 	clra
   01C9 B7 FF 01      [ 5]  102 	sta fin
                            103 		
                            104 		.area FIJA(ABS)
                            105 		
   FFFE                     106 		.org 0xFFFE
   FFFE 01 65               107 		.word wordle
ASxxxx Assembler V05.00  (Motorola 6809), page 4.
Hexidecimal [16-Bits]

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  0 acabar             01C8 GR  |     comprueba          **** GX
  0 diccionario        0186 R   |   0 err                0125 R
  0 error              019A R   |     fin            =   FF01 
    imprime_cadena     **** GX  |     inicio             **** GX
    inicio2            **** GX  |     inicio_genera      **** GX
  0 int_palabra        010C R   |   0 intentos_acaba     01C5 R
  0 juego              01A2 GR  |   0 lee_cadena         01B5 R
    lee_cadena_n       **** GX  |     mensaje_fallo      **** GX
  0 menu               0000 R   |   0 menujogo           00A6 R
    numero_palabra     **** GX  |   0 opcion             0175 R
    palabras           **** GX  |     pantalla       =   FF00 
  0 pedir_palabra      01AB GR  |     presentar_dicc     **** GX
    ps             =   B000     |     pu             =   F000 
    return_c           **** GX  |     teclado        =   FF02 
  0 wordle             0165 GR

ASxxxx Assembler V05.00  (Motorola 6809), page 5.
Hexidecimal [16-Bits]

Area Table

[_CSEG]
   0 _CODE            size  1CC   flags C180
   2 FIJA             size    0   flags  908
[_DSEG]
   1 _DATA            size    0   flags C0C0

