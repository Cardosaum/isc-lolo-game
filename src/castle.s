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

GAME_LOLO_LOOP:
  la t0,RETURN_ADDRESS_LOLO_MOVEMENT_DYNAMIC_MAP
  sw ra,(t0)
  
  # a0 = x
  # a1 = y
  li a0,0
  li a1,0
  la a2,lolo_castle_up_0
  li a5,0
  
  print_sprite(a0,a1,a2,DYN_BLOCK,a5)
  
  la t0,RETURN_ADDRESS_LOLO_MOVEMENT_DYNAMIC_MAP
  lw ra,(t0)
  ret
