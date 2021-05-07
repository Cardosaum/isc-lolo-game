.include "macros.s"

.data
.include "../sprites/lolo_l.data"
.include "../sprites/lolo_l_1.data"
.include "../sprites/lolo_l_2.data"
.include "../sprites/lolo_l_3.data"
.include "../sprites/lolo_l_4.data"
.include "../sprites/lolo_n.data"
.include "../sprites/lolo_n_1.data"
.include "../sprites/lolo_n_2.data"
.include "../sprites/lolo_n_3.data"
.include "../sprites/lolo_n_4.data"
.include "../sprites/lolo_r.data"
.include "../sprites/lolo_r_1.data"
.include "../sprites/lolo_r_2.data"
.include "../sprites/lolo_r_3.data"
.include "../sprites/lolo_r_4.data"
.include "../sprites/lolo_u.data"
.include "../sprites/lolo_u_1.data"
.include "../sprites/lolo_u_2.data"
.include "../sprites/lolo_u_3.data"
.include "../sprites/lolo_u_4.data"
.include "../sprites/map/map.data"
.include "../sprites/map_1.data"
.include "../sprites/chest_closed.data"
.include "../sprites/heart.data"
.include "../sprites/snake_l_1.data"
.include "../sprites/snake_l_2.data"
.include "../sprites/snake_r_1.data"
.include "../sprites/snake_r_2.data"
.include "../sprites/blocks/ground.data"
.include "constants.data"
.include "map_matrix_320x240.data"

.text
MAIN:
    init()
    init_map_1()
    keyboard_input()
    exit()


.include "ui.s"
.include "keyboard.s"
.include "utils.s"
.include "colisions.s"
.include "print_sprites.s"
.include "initialize_dynamic_sprites.s"
