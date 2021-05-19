#=====================================================================================================    
# KEYBORD INTERFACE
MENU_INTERFACE:
  store_word(t0,ra,RETURN_ADDRESS_MENU_INTERFACE)

  li a0,0
  li a1,0
  la a2,menu_option_1
  li a5,0
  print_sprite(a0, a1, a2, STC_BLOCK, a5)

MENU_INTERFACE_LOOP:
  li t1,0xFF200000          # carrega o endereco de controle do KDMMIO
  lw t0,0(t1)               # Le bit de Controle Teclado
  andi t0,t0,0x0001         # mascara o bit menos significativo
  beqz t0,MENU_INTERFACE_LOOP     # Se nao ha tecla pressionada entao vai para FIM
  
  lw t2,4(t1)               # le o valor da tecla tecla
  
  li t0,'w'
  beq t2,t0,READ_MENU_OPTIONS_1
  
  li t0,'s'
  beq t2,t0,READ_MENU_OPTIONS_2
  
  li t0,10         # enter
  beq t2,t0,FIM

  j MENU_INTERFACE_LOOP
  

READ_MENU_OPTIONS_1:
  li a0,0
  li a1,0
  la a2,menu_option_1
  li a5,0
  print_sprite(a0, a1, a2, STC_BLOCK, a5)
  j MENU_INTERFACE_LOOP
  
READ_MENU_OPTIONS_2:
  li a0,0
  li a1,0
  la a2,menu_option_2
  li a5,0
  print_sprite(a0, a1, a2, STC_BLOCK, a5)
  j MENU_INTERFACE_LOOP

FIM:
  load_word(ra,RETURN_ADDRESS_MENU_INTERFACE)
  ret
#=====================================================================================================
