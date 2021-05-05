.macro init()
    # s0: frame selected
    # s1: canvas width
    # s2: canvas height
    li s0,0xFF000000
    li s1,320
    li s2,240
    create_struct_vector(20,DYN_VECT_STRUCT)

    li a0,0
    li a1,0
    la a2,map_1
    li a5,0
    print_sprite(a0, a1, a2, STC_BLOCK, a5)

    li a0,68
    li a1,88
    initialize_lolo(a0,a1)
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

.macro add_struct_to_vector(%array_address,%sprite_id,%current_position,%next_position,%next_dyn_sprite)
    li a1,%sprite_id
    mv a2,%current_position
    mv a3,%next_position
    mv a5,%next_dyn_sprite
    la a0,%array_address
    jal ADD_STRUCT_TO_VECTOR
.end_macro

.macro initialize_lolo(%x,%y)
    mv a0,%x
    mv a1,%y
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
