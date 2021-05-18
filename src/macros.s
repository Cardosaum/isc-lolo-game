.macro init()
    # s0: frame selected
    # s1: canvas width
    # s2: canvas height
    li s0,0xFF000000
    li s1,320
    li s2,240
    create_struct_vector(40,DYN_VECT_STRUCT)
.end_macro

.macro init_map_1()
    # print base map on the 2 frames
    li a0,0
    li a1,0
    la a2,map_1
    li a5,0
    print_sprite(a0, a1, a2, STC_BLOCK, a5)

    # initialize lolo
    # lolo always has index of 0
    li a0,64
    li a1,112
    initialize_lolo(a0,a1,lolo_n)

    la a0,MAP_1_MATRIX
    li a1,300
    jal READ_AND_PRINT_MAP_MATRIX_DYNAMIC_SPRITES

    # add snake with index 1
    #initialize_dynamic_sprite(128,192,1,0,chest_closed)
    # add heart with index 2
    #initialize_dynamic_sprite(240,112,2,0,heart)
    # add heart with index 3
    #initialize_dynamic_sprite(128,48,3,0,heart)
    # add snake with index 4
    initialize_dynamic_sprite(160,144,4,1,snake_r_1)
.end_macro

.macro exit()
    li a7,10
    ecall
.end_macro

.macro load_word(%register,%var_address)
    la %register,%var_address # get the address of memory that we want to read
    lw %register,(%register) # actualy read the value stored in this memory address
.end_macro

.macro load_half(%register,%var_address)
    la %register,%var_address # get the address of memory that we want to read
    lhu %register,(%register) # actualy read the value stored in this memory address
.end_macro

.macro load_byte(%register,%var_address)
    la %register,%var_address # get the address of memory that we want to read
    lbu %register,(%register) # actualy read the value stored in this memory address
.end_macro

.macro store_word(%reg_tmp,%reg_data,%var_address)
    la %reg_tmp,%var_address # get the address of memory that we want to write
    sw %reg_data,(%reg_tmp) # actualy write the value stored in this memory address
.end_macro

.macro store_half(%reg_tmp,%reg_data,%var_address)
    la %reg_tmp,%var_address # get the address of memory that we want to write
    sh %reg_data,(%reg_tmp) # actualy write the value stored in this memory address
.end_macro

.macro store_byte(%reg_tmp,%reg_data,%var_address)
    la %reg_tmp,%var_address # get the address of memory that we want to write
    sbu %reg_data,(%reg_tmp) # actualy write the value stored in this memory address
.end_macro

.macro print_sprite(%x, %y, %sprite_address, %is_dynamic, %array_struct_index)
    mv a0,%x
    mv a1,%y
    mv a3,%sprite_address
    li a4,%is_dynamic
    mv a5,%array_struct_index
    jal PRINT_SPRITE
.end_macro

.macro move_lolo(%x,%y)
    li a0,%x
    li a1,%y
    jal MOVE_LOLO
.end_macro

.macro print_lolo()
    jal PRINT_LOLO
.end_macro

.macro sleep(%time_ms)
    li a7,32
    li a0,%time_ms
    ecall
.end_macro

.macro keyboard_input()
    jal KEYBOARD_INPUT
.end_macro

.macro generate_map_matrix(%map_matrix_address)
    la a0,%map_matrix_address
    jal GENERATE_MAP_MATRIX
.end_macro


.macro save_current_pixels_to_var(%x,%y,%width,%height,%variable_address)
    mv a0,%x
    mv a1,%y
    li a2,%width
    li a3,%height
    la a4,%variable_address
    jal SAVE_CURRENT_PIXELS_TO_VAR
.end_macro

.macro create_struct_vector(%how_many_structs,%dest_var)
    li a0,%how_many_structs
    la a1,%dest_var
    jal CREATE_STRUCT_VECTOR
.end_macro

.macro update_struct_vector(%array_address,%struct_position,%sprite_id,%current_position,%next_position,%hidden_sprite)
    la a0,%array_address
    li a1,%struct_position
    li a2,%sprite_id
    li a3,%current_position
    li a4,%next_position
    mv a5,%hidden_sprite
    jal UPDATE_STRUCT_VECTOR
.end_macro

.macro add_struct_to_vector(%array_address,%sprite_id,%current_position,%next_position,%next_dyn_sprite,%collide)
    li a1,%sprite_id
    mv a2,%current_position
    mv a3,%next_position
    mv a5,%next_dyn_sprite
    la a0,%array_address
    mv a6,%collide
    jal ADD_STRUCT_TO_VECTOR
.end_macro

.macro initialize_lolo(%x,%y,%sprite_address)
    mv a0,%x
    mv a1,%y
    la a2,%sprite_address
    jal INITIALIZE_LOLO
.end_macro

.macro copy_vector(%src,%dest,%size)
    mv a0,%src
    mv a1,%dest
    li a2,%size
    jal COPY_VECTOR
.end_macro

.macro move_dynamic_sprite(%x,%y,%array_struct_index,%sprite)
    li a0,%x
    li a1,%y
    li a2,%array_struct_index
    la a3,%sprite
    jal MOVE_DYNAMIC_SPRITE
.end_macro

.macro can_lolo_move_get_pixel_lower_left(%reg_x,%reg_y,%reg_tmp)
    li %reg_tmp,12 # sprite_width
    mv %reg_x,a1
    add %reg_y,a2,%reg_tmp
.end_macro

.macro can_lolo_move_get_pixel_lower_right(%reg_x,%reg_y,%reg_tmp)
    li %reg_tmp,12 # sprite_width
    add %reg_x,a1,%reg_tmp
    add %reg_y,a2,%reg_tmp
.end_macro

.macro can_lolo_move_get_pixel_upper_right(%reg_x,%reg_y,%reg_tmp)
    li %reg_tmp,12 # sprite_width
    add %reg_x,a1,%reg_tmp
    mv %reg_y,a2
.end_macro

.macro can_lolo_move_get_pixel_upper_left(%reg_x,%reg_y,%reg_tmp)
    mv %reg_x,a1
    mv %reg_y,a2
.end_macro

.macro keyboard_input_key(%x_rel,%y_rel,%key_code,%sprite,%sprite_movement)
    la a0,%sprite
    li a1,0
    li a2,0
    li a4,0
    jal MOVE_LOLO

    li a1,%x_rel
    li a2,%y_rel
    li a3,%key_code
    jal CAN_LOLO_MOVE
    beqz a1,KEYBOARD_INPUT_LOOP_POOL

    # TODO: fix animations
    #la a0,%sprite_movement
    la a0,%sprite
    li a1,%x_rel
    li a2,%y_rel
    li a4,1
    jal MOVE_LOLO
    #sleep(100)
.end_macro

.macro initialize_dynamic_sprite(%x,%y,%struct_array_index,%collide,%address_sprite_data)
    li a0,%x
    li a1,%y
    li a2,%struct_array_index
    li a3,%collide
    la a5,%address_sprite_data
    jal INITIALIZE_DYNAMIC_SPRITE
.end_macro

.macro lolo_life_print()
    jal LOLO_LIFE_RESET
    #jal LOLO_LIFE_DECOUNTER
    jal LOLO_LIFE_PRINT
.end_macro

.macro print_sprite_animation(%x, %y, %sprite_address, %is_dynamic, %array_struct_index)
    mv a0,%x
    mv a1,%y
    mv a3,%sprite_address
    li a4,%is_dynamic
    mv a5,%array_struct_index
    jal PRINT_RAW_COMBINED_SPRITE
.end_macro

.macro keyboard_input_key_v2(%x_rel,%y_rel,%movement_code,%sprite_address,%sleep_time)
    li a0,%x_rel
    li a1,%y_rel
    li a2,%movement_code
    la a3,%sprite_address
    li a4,%sleep_time
    jal KEYBOARD_INPUT_KEY_MOVEMENT
    j KEYBOARD_INPUT_LOOP_POOL
.end_macro

.macro swap_frames()
    jal SWAP_FRAMES
.end_macro

.macro lolo_shot_print()
    jal LOLO_SHOT_PRINT
.end_macro

.macro lolo_shot_reset()
    jal LOLO_SHOT_RESET
.end_macro

.macro lolo_shot_set_two_shot()
    jal LOLO_SHOT_SET_TWO_SHOT
.end_macro

.macro lolo_shot_decounter()
    jal LOLO_SHOT_DECOUNTER
.end_macro

.macro matrix_map_change_value(%x,%y,%new_value,%base_adress) # base_adress = chosen matrix
    li a0,%x
    li a1,%y
    la a2,%base_adress
    li a3,%new_value
    jal MATRIX_MAP_CHANGE_VALUE
.end_macro

.macro lolo_map_heart_reset()
    jal LOLO_MAP_HEART_RESET
.end_macro

.macro lolo_map_heart_counter()
    jal LOLO_MAP_HEART_COUNTER
.end_macro

.macro lolo_map_print_test_heart()
    jal LOLO_MAP_PRINT_TEST_HEART
.end_macro
