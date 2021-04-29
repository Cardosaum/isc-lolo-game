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
    #print_sprite(0, 0, map)
    #print_sprite(150, 100, lolo_l)
    #sleep(1000)
    #print_sprite(166, 100, lolo_n)
    #print_sprite(182, 100, lolo_r)
    #print_sprite(198, 100, lolo_u)
    #print_sprite(198, 100, ground)
    print_sprite(0, 0, map)
    #print_sprite(198, 100, lolo_u)
    #print_sprite(68, 32, lolo_u)
    #print_sprite(72, 48, lolo_u)
    #print_sprite(76, 64, lolo_u)
    #print_sprite(80, 80, lolo_u)
    #sleep(1000)
    #generate_map_matrix(MAP_1_MATRIX)
    #keyboard_input()
    exit()

.include "ui.s"
.include "keyboard.s"
