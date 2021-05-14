#=====================================================================================================
#lolo movement

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

GAME_LOLO_LOOP:
  la a0, LOLO_MOVEMENT_DYNAMIC_MAP