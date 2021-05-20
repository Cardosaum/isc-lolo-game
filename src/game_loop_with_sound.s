#=====================================================================================================
GAME_LOOP_WITH_SOUND:
    # save return address for later
    store_word(t0,ra,RETURN_ADDRESS_GAME_LOOP_WITH_SOUND)

    # init time for play music
    li a7,30
    ecall
    store_word(t0,a0,PLAY_MUSIC_TIME_OF_LAST_REPRODUCED_NOTE)

GAME_LOOP_WITH_SOUND_LOOP:
    # play sound
    jal PLAY_MUSIC

    # keyboard loop
    jal KEYBOARD_INPUT
    bnez a0,GAME_LOOP_WITH_SOUND_EXIT

    # check if lolo collected all needed hears
    jal HEART_CHECK_COLLECTED_ALL
    bnez a0,GAME_LOOP_WITH_SOUND_EXIT

    j GAME_LOOP_WITH_SOUND_LOOP

GAME_LOOP_WITH_SOUND_EXIT:
    # return to caller
    load_word(ra,RETURN_ADDRESS_GAME_LOOP_WITH_SOUND)
    ret
#=====================================================================================================
