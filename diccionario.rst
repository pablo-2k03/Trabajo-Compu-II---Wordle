ASxxxx Assembler V05.00  (Motorola 6809), page 1.
Hexidecimal [16-Bits]



                              1 	.module diccionario
                              2 
                     FF00     3 pantalla  .equ 0xFF00
                              4 
                              5 	.globl palabras
                              6 	.globl contador
                              7 	.globl numero_palabras
                              8 	.globl return_c
                              9 	.globl imprime_cadena
                             10 	.globl presentar_diccionario
                             11 	.globl convertir
                             12 	.globl incrementa_a
                             13 	.globl salir_bucle
                             14 
   0496                      15 presentar_diccionario:
   0496 0A 0A 4D 6F 73 74    16 	.asciz "\n\nMostrando diccionario...\n\n"
        72 61 6E 64 6F 20
        64 69 63 63 69 6F
        6E 61 72 69 6F 2E
        2E 2E 0A 0A 00
                             17 
   04B3                      18 palabras:
   04B3 4D 4F 53 43 41 0A    19 	.ascii	"MOSCA\n"
   04B9 50 55 4C 50 4F 0A    20 	.ascii	"PULPO\n"
   04BF 47 41 4E 53 4F 0A    21 	.ascii	"GANSO\n"
   04C5 4C 4C 41 4D 41 0A    22 	.ascii	"LLAMA\n"
   04CB 48 49 45 4E 41 0A    23 	.ascii	"HIENA\n"
   04D1 4C 45 4D 55 52 0A    24 	.ascii	"LEMUR\n"
   04D7 43 45 52 44 4F 0A    25 	.ascii	"CERDO\n"
   04DD 43 49 53 4E 45 0A    26 	.ascii	"CISNE\n"
   04E3 43 41 52 50 41 0A    27 	.ascii	"CARPA\n"
   04E9 43 41 42 52 41 0A    28 	.ascii	"CABRA\n"
   04EF 45 52 49 5A 4F 0A    29 	.ascii	"ERIZO\n"
   04F5 47 41 4C 4C 4F 0A    30 	.ascii	"GALLO\n"
   04FB 54 49 47 52 45 0A    31 	.ascii	"TIGRE\n"
   0501 43 45 42 52 41 0A    32 	.ascii	"CEBRA\n"
   0507 4F 56 45 4A 41 0A    33 	.ascii	"OVEJA\n"
   050D 50 45 52 52 4F 0A    34 	.ascii	"PERRO\n"
   0513 50 41 4E 44 41 0A    35 	.ascii	"PANDA\n"
   0519 4B 4F 41 4C 41 0A    36 	.ascii	"KOALA\n"
   051F 00                   37 	.byte	0
                             38 	
   0520                      39 numero_palabras:
   0520 0A 50 41 4C 41 42    40 	.asciz "\nPALABRAS: "
        52 41 53 3A 20 00
   052C                      41 return_c:
   052C 8E 05 20      [ 3]   42 	ldx #numero_palabras
   052F BD 02 28      [ 8]   43 	jsr imprime_cadena
   0532 4F            [ 2]   44 	clra
   0533 8E 04 B3      [ 3]   45 	ldx #palabras
   0536 BD 02 36      [ 8]   46 	jsr contador
   0539 BD 02 4D      [ 8]   47 	jsr convertir
   053C B7 FF 00      [ 5]   48 	sta pantalla
   053F F7 FF 00      [ 5]   49 	stb pantalla
   0542 39            [ 5]   50 	rts
ASxxxx Assembler V05.00  (Motorola 6809), page 2.
Hexidecimal [16-Bits]

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
    contador           **** GX  |     convertir          **** GX
    imprime_cadena     **** GX  |     incrementa_a       **** GX
  0 numero_palabra     008A GR  |   0 palabras           001D GR
    pantalla       =   FF00     |   0 presentar_dicc     0000 GR
  0 return_c           0096 GR  |     salir_bucle        **** GX

ASxxxx Assembler V05.00  (Motorola 6809), page 3.
Hexidecimal [16-Bits]

Area Table

[_CSEG]
   0 _CODE            size   AD   flags C180
[_DSEG]
   1 _DATA            size    0   flags C0C0

