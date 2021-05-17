#====================================================================================================
SWAP_FRAMES:
    # write swaped frame to variable and return
    load_word(s0,SELECTED_FRAME)
    li t0,FRAME_MASK
    xor s0,s0,t0
    li t1,FRAME_0
    or s0,s0,t1
    store_word(t0,s0,SELECTED_FRAME)
    li t0,FRAME_SELECTOR
    ori s0,s0,0x00F00000
    srli s0,s0,5
    sb s0,(t0)
    ret
#====================================================================================================
