#=====================================================================================================
# KEYBORD INTERFACE
SHOW_CREDITS:
  store_word(t0,ra,RETURN_ADDRESS_SHOW_CREDITS)

  li a0,0
  li a1,0
  la a2,credits
  li a5,0
  print_sprite(a0, a1, a2, STC_BLOCK, a5)

SHOW_CREDITS_LOOP:
  li t1,0xFF200000          # carrega o endereco de controle do KDMMIO
  lw t0,0(t1)               # Le bit de Controle Teclado
  andi t0,t0,0x0001         # mascara o bit menos significativo
  beqz t0,SHOW_CREDITS_LOOP     # Se nao ha tecla pressionada entao vai para FIM

  lw t2,4(t1)               # le o valor da tecla tecla

  li t0,10         # enter
  beq t2,t0,SHOW_CREDITS_EXIT

  j SHOW_CREDITS_LOOP

SHOW_CREDITS_EXIT:
  load_word(ra,RETURN_ADDRESS_SHOW_CREDITS)
  ret
#=====================================================================================================
