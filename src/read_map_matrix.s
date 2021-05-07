#====================================================================================================
READ_AND_PRINT_MAP_MATRIX_DYNAMIC_SPRITES:
    # this function parses the map represented by an array in 'a0' and print all needed dynamic sprites

    # a0: map_matrix_array // something similar to MAP_1_MATRIX
    # a1: size of map_matrix_array // something similar to 300 (for MAP_1_MATRIX for instance)

READ_AND_PRINT_MAP_MATRIX_DYNAMIC_SPRITES_LOOP:
    blez a1,READ_AND_PRINT_MAP_MATRIX_DYNAMIC_SPRITES_EXIT

READ_AND_PRINT_MAP_MATRIX_DYNAMIC_SPRITES_EXIT:
#====================================================================================================
