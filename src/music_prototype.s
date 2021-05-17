.data
DURATION_OF_LAST_NOTE:	.word 0		# duracao da ultima nota
LAST_NOTE_PLAYED:	.word 0		# quando a ultima nota foi tocada
MUSIC_NUM:		.word 112	# total de notas

MUSIC_NOTAS:	.word	60,267,55,133,59,133,57,133,59,133,60,267,55,133,59,133,57,133,59,133,60,267,55,133,60,267,64
               		,133,67,400,69,400,70,267,65,133,69,133,67,133,69,133,70,267,65,133,69,133,67,133,69,133,70,267
               		,70,133,69,133,67,133,65,133,67,667,55,133,60,267,55,133,59,133,57,133,59,133,60,267,55,133,59
               		,133,57,133,59,133,60,267,55,133,60,267,64,133,67,400,69,400,70,267,65,133,69,133,67,133,69,133
               		,70,267,65,133,69,133,67,133,69,133,70,267,70,133,71,133,67,133,71,133,72,400,60,133,64,133,67
               		,133,69,267,68,133,69,267,68,133,69,400,71,400,67,267,66,133,67,801,60,133,62,133,64,133,65,267
               		,64,133,65,267,64,133,65,400,67,267,65,133,64,267,63,133,64,267,65,133,67,667,60,133,68,267,67
               		,133,68,267,72,133,70,400,68,400,67,267,66,133,67,801,65,267,64,133,62,267,61,133,62,267,68,133
               		,69,400,71,400,67,1468,55,133

.text

	jal a0,SET_DEFAULT	# reseta os valores padrões (define o valor de retorno em a0)
	
KING_LOOP:	
	jal PLAY	# tocar música

	#execute aqui acoes que nao irah inteferir na musica
	
	j KING_LOOP		# continuar main loop

PLAY:	la t1,LAST_NOTE_PLAYED	# endereço do last played
	lw t1,0(t1)		# t1 = last played
	beq t1,zero,CONDITIONAL	# if last played == 0 THEN continue loop (primeira ocorrência)

	li a7,30		# inicializacao da syscall para manipulacao do tempo
	ecall			# time
	la t5,DURATION_OF_LAST_NOTE	# DURATION_OF_LAST_NOTE ADRESS
	lw t5,0(t5)		# t5 = duracao da ultima nota
	sub t1,a0,t1		# t1 = (agora - quando a ultima nota foi tocada (quanto tempo passou desde a ultima nota tocada)
	bge t1,t5,CONDITIONAL	# se o tempo que passou for maior ou igual que a duracao da nota, toca a proxima nota
	ret			# retorna ao main loop

CONDITIONAL:	bne s0,s1,P_NOTE# if s0 != s1: toca a proxima nota
	jal a0,SET_DEFAULT	# reseta pro padrao (a musica vai ficar tocando num loop)
	ret			# volta ao main loop

P_NOTE:	
	lw a0,0(s2)		# le o valor da nota
	lw a1,4(s2)		# le a duracao da nota
	li a7,31		# chamada de syscall
	ecall			# reproduz a nota
	
	la t5,DURATION_OF_LAST_NOTE	# endereço da last duration
	sw a1,0(t5)		# salva a duracao da nota atual no last duration

	li a7,30		# define o syscall Time
	ecall			# time
	la t5,LAST_NOTE_PLAYED	# endereço do last played
	sw a0,0(t5)		# salva o instante atual no last played

	addi s2,s2,8		# incrementa para o endereço da próxima nota
	addi s0,s0,1		# incrementa o contador de notas
	ret			# volta ao main loop

# define os valores padrões
SET_DEFAULT:

	li s0,0		# contador notas
	la t5,MUSIC_NUM		# endereço do total de notas
	lw s1,0(t5)		# total de notas
	la s2,MUSIC_NOTAS	# endereço das notas

	li a2,27		# INSTRUMENTO
	li a3,130		# VOLUME
	jr a0			# volta a quem chamou
