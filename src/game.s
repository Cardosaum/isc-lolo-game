.include "macros.s"

.data
.include "../sprites/lolo/lolo_l.data"
.include "../sprites/lolo/lolo_n.data"
.include "../sprites/lolo/lolo_r.data"
.include "../sprites/lolo/lolo_u.data"
.include "../sprites/map/map.data"
.include "../sprites/blocks/ground.data"
.include "constants.data"

.text
MAIN:
    #la a0,MAP_1_MATRIX_CURRENT
    #la a1,MAP_1_MATRIX_LAST
    #li a2,300
    #jal COPY_VECTOR

    init()
    li a0,0
    li a1,0
    la a2,map
    print_sprite(a0, a1, a2)

    #li a0,0
    #la a5,lolo_n
    #addi a5,a5,8 # skip the first 2 words of lolo_n. we only need the address of the first lolo_n's pixel
    #add_struct_to_vector(DYN_VECT_STRUCT,0,a0,a0,a5)

    #li a0,64
    #li a1,30
    li a0,0
    li a1,0
    initialize_lolo(a0,a1)
    sleep(1000)

    li a0,200
    li a1,200
    li a2,0
    la a3,lolo_l
    jal MOVE_DYNAMIC_SPRITE
    sleep(1000)
    exit()

    # update struct vector
    # a0: array_address // array of structs' address
    # a1: struct_position // goes from 0 to (how_many_structs - 1)
    # a2: sprite_id
    # a3: current_position
    # a4: next_position
    # a5: hidden_sprite
    #la a0,DYN_VECT_STRUCT
    #lw a0,(a0)
    #li a1,0
    #li a2,0
    #li a3,0
    #li a4,1024
    #la a5,lolo_n
    #addi a5,a5,64 # skip the first 2 words of lolo_n. we only need the address of the first lolo_n's pixel
    #jal UPDATE_STRUCT_VECTOR
    #la a5,lolo_u
    #addi a5,a5,8
    #update_struct_vector(DYN_VECT_STRUCT,0,16,64,1024,a5)

    #exit()
    #print_sprite(0, 0, map, STC_BLOCK)
    #print_sprite(68, 32, lolo_n, DYN_BLOCK)
    #sleep(1000)
    #li a0,68
    #li a1,32
    #li a2,80
    #li a3,80
    #la a4,lolo_n
    #jal RELATIVE_MOVE_DYN_BLOCK
    #sleep(1000)
    #li a0,80
    #li a1,80
    #li a2,68
    #li a3,68
    #la a4,lolo_n
    #jal RELATIVE_MOVE_DYN_BLOCK
#RELATIVE_MOVE_DYN_BLOCK:
    # a0: x_current
    # a1: y_current
    # a2: x_next
    # a3: y_next
    # a4: sprite_address
    #sleep(1000)
    #move_lolo(80,80)
    #sleep(1000)
    #move_lolo(160,80)
    #sleep(1000)
    #move_lolo(52,96)
    #sleep(1000)
    #move_lolo(120,120)
    #print_sprite(68, 32, ground, STC_BLOCK)
    #print_sprite(72, 48, lolo_u, DYN_BLOCK)
    #print_sprite(76, 64, lolo_u, DYN_BLOCK)
    #print_sprite(80, 80, lolo_u, DYN_BLOCK)
    #generate_map_matrix(MAP_1_MATRIX)
    #print_lolo()
    #sleep(1000000)
    #keyboard_input()
    exit()

.include "ui.s"
.include "keyboard.s"
.include "utils.s"
.include "print_sprites.s"
