#=====================================================================================================
PLAY_MAP_LEVEL_1:
    # save return address for later
    store_word(t0,ra,RETURN_ADDRESS_PLAY_MAP_LEVEL_1)

    map(map_level_1,MAP_1_MATRIX)
    map(map_level_2,MAP_2_MATRIX)
    map(map_level_3,MAP_3_MATRIX)
    map(map_level_4,MAP_4_MATRIX)
    map(map_level_maze,MAP_MAZE_MATRIX)

    # return to caller
    load_word(ra,RETURN_ADDRESS_PLAY_MAP_LEVEL_1)
    ret
#=====================================================================================================
