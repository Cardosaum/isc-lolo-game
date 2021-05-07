#=====================================================================================================
#lolo movement

READ_CASTLE_DYNAMIC_MAP:
  la t0, RETURN_ADDRESS_READ_CASTLE_DYNAMIC_MAP
  sw ra,(t0)
  
  li a1,320
  li a2,320
  li a3,240
  la a5,map_castle
  jal RENDER_IMAGE
  
  la t0,RETURN_ADDRESS_READ_CASTLE_DYNAMIC_MAP
  lw ra,(t0)
  ret