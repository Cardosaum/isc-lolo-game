#=====================================================================================================
# printing map
READ_CASTLE_DYNAMIC_MAP:
  la t0, RETURN_ADDRESS_READ_CASTLE_DYNAMIC_MAP
  sw ra,(t0)

  li a0,0
  li a1,0
  la a2,map_castle
  li a5,0
  print_sprite(a0, a1, a2, STC_BLOCK, a5)

  
  la t0,RETURN_ADDRESS_READ_CASTLE_DYNAMIC_MAP
  lw ra,(t0)
  ret
#=====================================================================================================

#=====================================================================================================
# lolo movement
GAME_LOLO_INTRO:
  la t0,RETURN_ADDRESS_LOLO_MOVEMENT_DYNAMIC_MAP
  sw ra,(t0)
  # a0 = x
  # a1 = y
  li a0,144
  li a1,224
  li a5,0
  store_word(t0,a0,GAME_LOLO_INTRO_X)
  store_word(t0,a1,GAME_LOLO_INTRO_Y)
  store_word(t0,a5,GAME_LOLO_INTRO_INDEX)
  li t1,168
  store_word(t0,t1,GAME_LOLO_INTRO_STOP_Y)

  # initialize lolo
  # lolo always has index of 0
  initialize_lolo(a0,a1,lolo_castle_up_0)

GAME_LOLO_LOOP:
  load_word(a0,GAME_LOLO_INTRO_X)
  load_word(a1,GAME_LOLO_INTRO_Y)
  load_word(a5,GAME_LOLO_INTRO_INDEX)
  la a2,lolo_castle_up_0

  print_sprite(a0,a1,a2,DYN_BLOCK,a5)

  keyboard_input_key(0,-4,0,lolo_castle_up_0,LOLO_U)

  sleep(50)
  load_word(a1,GAME_LOLO_INTRO_Y)
  addi a1,a1,-4
  store_word(t0,a1,GAME_LOLO_INTRO_Y)
  load_word(t0,GAME_LOLO_INTRO_STOP_Y)
  beq a1,t0,GAME_LOLO_EXIT
  j GAME_LOLO_LOOP

GAME_LOLO_EXIT:
  la t0,RETURN_ADDRESS_LOLO_MOVEMENT_DYNAMIC_MAP
  lw ra,(t0)
  ret
#=====================================================================================================
