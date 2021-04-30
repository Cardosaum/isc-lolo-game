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
    #init()
    print_sprite(0, 0, map, STC_BLOCK)
    print_sprite(68, 32, lolo_n, DYN_BLOCK)
    sleep(1000)
    move_lolo(80,80)
    sleep(1000)
    move_lolo(160,80)
    sleep(1000)
    move_lolo(52,96)
    sleep(1000)
    move_lolo(120,120)
    #print_sprite(68, 32, ground)
    #print_sprite(72, 48, lolo_u)
    #print_sprite(76, 64, lolo_u)
    #print_sprite(80, 80, lolo_u)
    #generate_map_matrix(MAP_1_MATRIX)
    #print_lolo()
    keyboard_input()
    exit()

.include "ui.s"
.include "keyboard.s"
