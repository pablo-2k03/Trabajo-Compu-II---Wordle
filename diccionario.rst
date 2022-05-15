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
   0456                      15 presentar_diccionario:
   0456 0A 0A 4D 6F 73 74    16 	.asciz "\n\nMostrando diccionario...\n\n"
        72 61 6E 64 6F 20
        64 69 63 63 69 6F
        6E 61 72 69 6F 2E
        2E 2E 0A 0A 00
                             17 
   0473                      18 palabras:
   0473 4D 4F 53 43 41 0A    19 	.ascii	"MOSCA\n"
   0479 50 55 4C 50 4F 0A    20 	.ascii	"PULPO\n"
   047F 47 41 4E 53 4F 0A    21 	.ascii	"GANSO\n"
   0485 4C 4C 41 4D 41 0A    22 	.ascii	"LLAMA\n"
   048B 48 49 45 4E 41 0A    23 	.ascii	"HIENA\n"
   0491 4C 45 4D 55 52 0A    24 	.ascii	"LEMUR\n"
   0497 43 45 52 44 4F 0A    25 	.ascii	"CERDO\n"
   049D 43 49 53 4E 45 0A    26 	.ascii	"CISNE\n"
   04A3 43 41 52 50 41 0A    27 	.ascii	"CARPA\n"
   04A9 43 41 42 52 41 0A    28 	.ascii	"CABRA\n"
   04AF 45 52 49 5A 4F 0A    29 	.ascii	"ERIZO\n"
   04B5 47 41 4C 4C 4F 0A    30 	.ascii	"GALLO\n"
   04BB 54 49 47 52 45 0A    31 	.ascii	"TIGRE\n"
   04C1 43 45 42 52 41 0A    32 	.ascii	"CEBRA\n"
   04C7 4F 56 45 4A 41 0A    33 	.ascii	"OVEJA\n"
   04CD 50 45 52 52 4F 0A    34 	.ascii	"PERRO\n"
   04D3 50 41 4E 44 41 0A    35 	.ascii	"PANDA\n"
   04D9 4B 4F 41 4C 41 0A    36 	.ascii	"KOALA\n"
   04DF 4D 4F 52 53 41 0A    37 	.ascii  "MORSA\n"
   04E5 00                   38 	.byte	0
                             39 	
   04E6                      40 numero_palabras:
   04E6 0A 50 41 4C 41 42    41 	.asciz "\nPALABRAS: "
        52 41 53 3A 20 00
   04F2                      42 return_c:
   04F2 8E 04 E6      [ 3]   43 	ldx #numero_palabras
   04F5 BD 02 C7      [ 8]   44 	jsr imprime_cadena
   04F8 4F            [ 2]   45 	clra
   04F9 8E 04 73      [ 3]   46 	ldx #palabras
   04FC BD 02 D5      [ 8]   47 	jsr contador
   04FF BD 02 EC      [ 8]   48 	jsr convertir
   0502 B7 FF 00      [ 5]   49 	sta pantalla
   0505 F7 FF 00      [ 5]   50 	stb pantalla
ASxxxx Assembler V05.00  (Motorola 6809), page 2.
Hexidecimal [16-Bits]



   0508 39            [ 5]   51 	rts
ASxxxx Assembler V05.00  (Motorola 6809), page 3.
Hexidecimal [16-Bits]

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
    contador           **** GX  |     convertir          **** GX
    imprime_cadena     **** GX  |     incrementa_a       **** GX
  0 numero_palabra     0090 GR  |   0 palabras           001D GR
    pantalla       =   FF00     |   0 presentar_dicc     0000 GR
  0 return_c           009C GR  |     salir_bucle        **** GX

ASxxxx Assembler V05.00  (Motorola 6809), page 4.
Hexidecimal [16-Bits]

Area Table

[_CSEG]
   0 _CODE            size   B3   flags C180
[_DSEG]
   1 _DATA            size    0   flags C0C0

