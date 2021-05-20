#=====================================================================================================
#define os valores essenciais
PLAY_MUSIC:
    # save return address for later
    store_word(t0,ra,RETURN_ADDRESS_PLAY_MUSIC)

    # check if we need to reproduce next note
    load_word(t0,PLAY_MUSIC_TIME_OF_LAST_REPRODUCED_NOTE)
    load_word(t2,PLAY_MUSIC_CURRENT_NOTE)
    slli t2,t2,3
    la t3,PLAY_MUSIC_NOTE_AND_DURATION
    add t2,t2,t3
    lw t1,4(t2)
    add t0,t0,t1
    li a7,30
    ecall
    blt a0,t0,PLAY_MUSIC_END

    # update current note
    load_word(t0,PLAY_MUSIC_CURRENT_NOTE)
    load_word(t1,PLAY_MUSIC_NUMBER_OF_NOTES)
    addi t0,t0,1 # new current note
    rem t0,t0,t1 # make sure we always have a valid note
    store_word(t1,t0,PLAY_MUSIC_CURRENT_NOTE)

    # update reproduced time
    li a7,30
    ecall
    store_word(t1,a0,PLAY_MUSIC_TIME_OF_LAST_REPRODUCED_NOTE)

    # get address of current note
    la t1,PLAY_MUSIC_NOTE_AND_DURATION
    slli t0,t0,3
    add t0,t0,t1

    # play desired note
    lw a0,0(t0) # read note value
    lw a1,4(t0) # read note duration
    li a2,45    # instrument
    li a3,140   # volume
    li a7,31    # syscall to play sound
    ecall

PLAY_MUSIC_END:
    # return to caller
    load_word(ra,RETURN_ADDRESS_PLAY_MUSIC)
    ret
#=====================================================================================================
