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
    li t1,0x00100000
    and s0,s0,t1
    srli s0,s0,20
    sb s0,(t0)
    ret
#====================================================================================================
