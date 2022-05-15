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
   00AD 0A 20 20 20 20 20    26 	.ascii "\n     | JUEGO |\n"
        7C 20 4A 55 45 47
        4F 20 7C 0A
   00BD 2D 2D 2D 2D 2D 2D    27 	.ascii "--------------\n"
ASxxxx Assembler V05.00  (Motorola 6809), page 2.
Hexidecimal [16-Bits]



        2D 2D 2D 2D 2D 2D
        2D 2D 0A
   00CC 20 20 20 20 20 7C    28 	.ascii "     | 12345 |\n"
        20 31 32 33 34 35
        20 7C 0A
   00DB 2D 2D 2D 2D 2D 2D    29 	.asciz "--------------\n"
        2D 2D 2D 2D 2D 2D
        2D 2D 0A 00
   00EB                      30 int_palabra:
   00EB 0A 49 6E 74 72 6F    31 	.asciz "\nIntroduzca la palabra: "
        64 75 7A 63 61 20
        6C 61 20 70 61 6C
        61 62 72 61 3A 20
        00
                             32 
   0104                      33 err:
   0104 0A 45 72 72 6F 72    34 	.asciz "\nError, valor introducido no valido, introduzca un nuevo valor."
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
   0144                      48 wordle:
   0144 10 CE B0 00   [ 4]   49 	lds #ps
   0148 CE F0 00      [ 3]   50 	ldu #pu
   014B 8E 00 00      [ 3]   51 	ldx #menu
   014E BD 02 C7      [ 8]   52 	jsr imprime_cadena		
                             53 
   0151                      54 opcion:
   0151 B6 FF 02      [ 5]   55 	lda teclado
   0154 81 31         [ 2]   56 	cmpa #'1
   0156 27 0A         [ 3]   57 	beq diccionario
   0158 81 32         [ 2]   58 	cmpa #'2
   015A 27 22         [ 3]   59 	beq juego
   015C 81 33         [ 2]   60 	cmpa #'3
   015E 27 3A         [ 3]   61 	beq acabar
   0160 20 14         [ 3]   62 	bra error
ASxxxx Assembler V05.00  (Motorola 6809), page 3.
Hexidecimal [16-Bits]



                             63 	
   0162                      64 diccionario:
   0162 8E 04 56      [ 3]   65 	ldx #presentar_diccionario
   0165 BD 02 C7      [ 8]   66 	jsr imprime_cadena
   0168 8E 04 73      [ 3]   67 	ldx #palabras
   016B BD 02 C7      [ 8]   68 	jsr imprime_cadena
   016E BD 04 F2      [ 8]   69 	jsr return_c
   0171 B6 FF 02      [ 5]   70 	lda teclado	;Como system("pause") de C, hasta q no meta nada por teclado no avanza.
   0174 20 CE         [ 3]   71 	bra wordle
   0176                      72 error:
   0176 8E 01 04      [ 3]   73 	ldx #err
   0179 BD 02 C7      [ 8]   74 	jsr imprime_cadena
   017C 20 D3         [ 3]   75 	bra opcion
                             76 
   017E                      77 juego:
   017E 8E 00 A6      [ 3]   78 	ldx #menujogo
   0181 BD 02 C7      [ 8]   79 	jsr imprime_cadena
   0184 BD 01 87      [ 8]   80 	jsr pedir_palabra
   0187                      81 pedir_palabra:
   0187 8E 00 EB      [ 3]   82 	ldx #int_palabra
   018A BD 02 C7      [ 8]   83 	jsr imprime_cadena
   018D 86 06         [ 2]   84 	lda #6	;Numero maximo de caracteres q pueden introducir(n-1)
   018F BD 02 FD      [ 8]   85 	jsr lee_cadena_n
   0192 BD 03 8D      [ 8]   86 	jsr comprueba
   0195 BD 03 B9      [ 8]   87 	jsr inicio
   0198 20 ED         [ 3]   88 	bra pedir_palabra
   019A                      89 acabar:
   019A 4F            [ 2]   90 	clra
   019B B7 FF 01      [ 5]   91 	sta fin
                             92 		
                             93 		.area FIJA(ABS)
                             94 		
   FFFE                      95 		.org 0xFFFE
   FFFE 01 44                96 		.word wordle
ASxxxx Assembler V05.00  (Motorola 6809), page 4.
Hexidecimal [16-Bits]

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  0 acabar             019A GR  |     comprueba          **** GX
  0 diccionario        0162 R   |   0 err                0104 R
  0 error              0176 R   |     fin            =   FF01 
    imprime_cadena     **** GX  |     inicio             **** GX
  0 int_palabra        00EB R   |   0 juego              017E GR
    lee_cadena_n       **** GX  |   0 menu               0000 R
  0 menujogo           00A6 R   |     numero_palabra     **** GX
  0 opcion             0151 R   |     palabras           **** GX
    pantalla       =   FF00     |   0 pedir_palabra      0187 GR
    presentar_dicc     **** GX  |     ps             =   B000 
    pu             =   F000     |     return_c           **** GX
    teclado        =   FF02     |   0 wordle             0144 GR

ASxxxx Assembler V05.00  (Motorola 6809), page 5.
Hexidecimal [16-Bits]

Area Table

[_CSEG]
   0 _CODE            size  19E   flags C180
   2 FIJA             size    0   flags  908
[_DSEG]
   1 _DATA            size    0   flags C0C0

