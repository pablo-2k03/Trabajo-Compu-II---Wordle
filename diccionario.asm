	.module diccionario

pantalla  .equ 0xFF00

	.globl palabras
	.globl contador
	.globl numero_palabras
	.globl return_c
	.globl imprime_cadena
	.globl presentar_diccionario
	.globl convertir
	.globl incrementa_a
	.globl salir_bucle

presentar_diccionario:
	.asciz "\n\nMostrando diccionario...\n\n"

palabras:
	.ascii	"MOSCA\n"
	.ascii	"PULPO\n"
	.ascii	"GANSO\n"
	.ascii	"LLAMA\n"
	.ascii	"HIENA\n"
	.ascii	"LEMUR\n"
	.ascii	"CERDO\n"
	.ascii	"CISNE\n"
	.ascii	"CARPA\n"
	.ascii	"CABRA\n"
	.ascii	"ERIZO\n"
	.ascii	"GALLO\n"
	.ascii	"TIGRE\n"
	.ascii	"CEBRA\n"
	.ascii	"OVEJA\n"
	.ascii	"PERRO\n"
	.ascii	"PANDA\n"
	.ascii	"KOALA\n"
	.byte	0
	
numero_palabras:
	.asciz "\nPALABRAS: "
return_c:
	ldx #numero_palabras
	jsr imprime_cadena
	clra
	ldx #palabras
	jsr contador
	jsr convertir
	sta pantalla
	stb pantalla
	rts
