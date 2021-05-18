#=====================================================================================================    
#START PRINTING
READ_MENU_1:
  la t0, RETURN_ADRESS_READ_START_OPTIONS_1
  sw ra,(t0)

  li a0,0
  li a1,0
  la a2,start_game_1
  li a5,0
  print_sprite(a0, a1, a2, STC_BLOCK, a5)

  la t0,RETURN_ADRESS_READ_START_OPTIONS_1
  lw ra,(t0)
  ret
  
#=====================================================================================================
# KEYBORD INTERFACE
KEY2:
  store_word(t0,ra,RETURN_ADDRESS_KEY2)
  li t1,0xFF200000		# carrega o endereco de controle do KDMMIO
  lw t0,0(t1)			# Le bit de Controle Teclado
  andi t0,t0,0x0001		# mascara o bit menos significativo
  beq t0,zero,KEY2   	   	# Se nao ha tecla pressionada entao vai para FIM
  
  lw t2,4(t1)  			# le o valor da tecla tecla
  
  li t0,'w'
  beq t2,t0,READ_START_OPTIONS_1
  
  li t0,'s'
  beq t2,t0,READ_START_OPTIONS_2
  
  li t0,'a'
  beq t2,t0,FIM
  
  j KEY2
  

#=====================================================================================================
# PRINTING OPTIONS 1

READ_START_OPTIONS_1:

  li a0,0
  li a1,0
  la a2,start_game_1
  li a5,0
  print_sprite(a0, a1, a2, STC_BLOCK, a5)

  j KEY2
  
#=====================================================================================================
# PRINTING OPTIONS 2

READ_START_OPTIONS_2:

  li a0,0
  li a1,0
  la a2,start_game_2
  li a5,0
  print_sprite(a0, a1, a2, STC_BLOCK, a5)

  j KEY2
#=====================================================================================================

FIM:
  load_word(ra,RETURN_ADDRESS_KEY2)
  ret