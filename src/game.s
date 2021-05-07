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
.include "../sprites/life_number_5.data"
.include "../sprites/life_number_4.data"
.include "../sprites/life_number_3.data"
.include "../sprites/life_number_2.data"
.include "../sprites/life_number_1.data"
.include "../sprites/life_number_0.data"
.include "constants.data"
.include "map_matrix_1x1.data"
.include "../sprites/map_castle.data"

.text
MAIN:
    init()
    init_map_1()
    lolo_life_print()
    keyboard_input()
    exit()


.include "ui.s"
.include "keyboard.s"
.include "utils.s"
.include "colisions.s"
.include "print_sprites.s"
.include "proc_life_lolo.s"
.include "initialize_dynamic_sprites.s"
#.include "read_map_matrix.s"
.include "castle.s"
