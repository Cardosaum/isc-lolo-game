.macro init()
    # s0: frame selected
    # s1: canvas width
    # s2: canvas height
    li s0,0xFF000000
    li s1,320
    li s2,240
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

.macro print_sprite(%x, %y, %sprite_address, %is_dynamic)
    li a0,%x
    li a1,%y
    la a3,%sprite_address
    li a4,%is_dynamic
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

.macro update_struct_vector(%array_address,%struct_position,%sprite_id,%current_position,%next_position,%sprite_image)
    la a0,%array_address
    lw a0,(a0)
    li a1,%struct_position
    li a2,%sprite_id
    li a3,%current_position
    li a4,%next_position
    mv a5,%sprite_image
    jal UPDATE_STRUCT_VECTOR
.end_macro
